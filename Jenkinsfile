pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "abayomi2/demo-app"
        REGISTRY_CREDENTIALS = credentials('REGISTRY_CREDENTIALS') // DockerHub/JFrog etc.
        GIT_CREDENTIALS = credentials('GIT_CREDENTIALS') // GitHub token or username/password
    }

    tools {
        jdk 'java'
        maven 'maven'
    }

    stages {
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

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    script {
                        env.IMAGE_TAG = "${DOCKER_IMAGE}:${BUILD_NUMBER}"
                        sh "docker build -t ${IMAGE_TAG} ."
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh """
                        echo "${REGISTRY_CREDENTIALS_PSW}" | docker login -u "${REGISTRY_CREDENTIALS_USR}" --password-stdin
                        docker push ${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Update K8s Manifest for ArgoCD') {
            steps {
                script {
                    sh """
                        sed -i 's|image: .*|image: ${IMAGE_TAG}|' manifest/deployment.yaml

                        git config --global user.email "jenkins@ci.com"
                        git config --global user.name "Jenkins CI"

                        git add manifest/deployment.yaml
                        git commit -m "Update image tag to ${IMAGE_TAG} [ci skip]" || echo "No changes to commit"

                        git push https://${GIT_CREDENTIALS_USR}:${GIT_CREDENTIALS_PSW}@github.com/abayomi2/cicd-jenkins-AgroCD.git HEAD:main
                    """
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
            junit 'target/surefire-reports/*.xml'
        }
    }
}
