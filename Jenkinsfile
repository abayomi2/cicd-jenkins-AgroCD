pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "abayomi2/demo-app"
    }

    tools {
        jdk 'java'
        maven 'maven'
    }

    options {
        disableConcurrentBuilds()
    }

    stages {
        stage('Check Commit Source') {
            steps {
                script {
                    def lastCommitEmail = sh(script: "git log -1 --pretty=format:'%ae'", returnStdout: true).trim()
                    def lastCommitMsg = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()

                    if (lastCommitEmail == "jenkins@ci.com" || lastCommitMsg.contains("[ci skip]")) {
                        echo "Build triggered by Jenkins or contains [ci skip]; skipping pipeline."
                        currentBuild.result = 'SUCCESS'
                        // Exit pipeline early
                        error("Stopping pipeline - Not a CLI-triggered commit.")
                    } else {
                        echo "Commit appears to be from CLI: ${lastCommitEmail}"
                    }
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                dir('app') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                dir('app') {
                    sh 'mvn test'
                }
            }
        }

        stage('Verify WAR Exists') {
            steps {
                dir('app') {
                    sh 'ls -l target/*.war || { echo "WAR not found!"; exit 1; }'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    script {
                        env.IMAGE_TAG = "${DOCKER_IMAGE}:${BUILD_NUMBER}"
                        sh 'cp target/*.war cicd-expertise.war'
                        sh "docker build -t ${IMAGE_TAG} ."
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'REGISTRY_CREDENTIALS', usernameVariable: 'REGISTRY_USER', passwordVariable: 'REGISTRY_PASS')]) {
                    script {
                        sh """
                            echo "${REGISTRY_PASS}" | docker login -u "${REGISTRY_USER}" --password-stdin
                            docker push ${IMAGE_TAG}
                        """
                    }
                }
            }
        }

        stage('Update K8s Manifest for ArgoCD') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'GIT_CREDENTIALS', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    script {
                        def encodedPass = java.net.URLEncoder.encode(GIT_PASS, "UTF-8")
                        def repoUrl = "https://${GIT_USER}:${encodedPass}@github.com/abayomi2/cicd-jenkins-AgroCD.git"

                        sh """
                            sed -i 's|image: .*|image: ${IMAGE_TAG}|' argocd/manifests/deployment.yaml
                            git config user.email "jenkins@ci.com"
                            git config user.name "Jenkins CI"
                            git add argocd/manifests/deployment.yaml
                            git commit -m "Update image tag to ${IMAGE_TAG} [ci skip]" || echo "No changes to commit"
                            git push ${repoUrl} HEAD:main
                        """
                    }
                }
            }
        }

        stage('Post Build Cleanup') {
            steps {
                sh 'docker system prune -f'
            }
        }
    }

    post {
        always {
            dir('app') {
                junit 'target/surefire-reports/*.xml'
            }
        }
    }
}
