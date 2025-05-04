pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "abayomi2/demo-app"
        REGISTRY_CREDENTIALS = credentials('dockerhub-creds')
        GIT_CREDENTIALS = credentials('git-creds') // Jenkins username/password credentials
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    env.IMAGE_TAG = "${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    sh "docker build -t ${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "echo $REGISTRY_CREDENTIALS_PSW | docker login -u $REGISTRY_CREDENTIALS_USR --password-stdin"
                    sh "docker push ${IMAGE_TAG}"
                }
            }
        }

        stage('Update K8s Manifest for ArgoCD') {
            steps {
                script {
                    sh """
                      sed -i 's|image: .*|image: ${IMAGE_TAG}|' k8s/deployment.yaml
                      git config user.email "jenkins@ci.com"
                      git config user.name "Jenkins CI"
                      git add k8s/deployment.yaml
                      git commit -m "Update image tag to ${IMAGE_TAG} [ci skip]" || echo "No changes to commit"
                      git push https://${GIT_CREDENTIALS_USR}:${GIT_CREDENTIALS_PSW}@github.com/abayomi2/your-repo.git HEAD:main
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
