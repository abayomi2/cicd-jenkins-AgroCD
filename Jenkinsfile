pipeline {
  agent any

  environment {
    IMAGE_NAME = "your-artifactory-domain.com/your-repo/your-app"
    GIT_REPO = "git@github.com:your-org/your-repo.git"
    DEPLOYMENT_FILE = "k8s/deployment.yaml"
    BRANCH = "main"
    JFROG_USERNAME = credentials('jfrog-username')
    JFROG_PASSWORD = credentials('jfrog-password')
  }

  stages {
    stage('Checkout Code') {
      steps {
        git branch: "${BRANCH}", url: "${GIT_REPO}"
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          IMAGE_TAG = "v${BUILD_NUMBER}"
          sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ./app"
        }
      }
    }

    stage('Push to JFrog Artifactory') {
      steps {
        script {
          sh """
            echo "${JFROG_PASSWORD}" | docker login ${IMAGE_NAME} --username "${JFROG_USERNAME}" --password-stdin
            docker push ${IMAGE_NAME}:${IMAGE_TAG}
          """
        }
      }
    }

    stage('Update Kubernetes Manifests') {
      steps {
        script {
          sh """
            sed -i 's|image: .*$|image: ${IMAGE_NAME}:${IMAGE_TAG}|' ${DEPLOYMENT_FILE}
            git config user.name "jenkins-bot"
            git config user.email "jenkins@example.com"
            git add ${DEPLOYMENT_FILE}
            git commit -m "Update image to ${IMAGE_TAG}"
            git push origin ${BRANCH}
          """
        }
      }
    }
  }

  post {
    failure {
      echo 'Build failed!'
    }
    success {
      echo "Build ${BUILD_NUMBER} completed and pushed to Git. ArgoCD will sync automatically."
    }
  }
}
