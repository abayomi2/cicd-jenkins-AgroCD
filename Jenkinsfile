pipeline {
  agent any
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/abayomi2/gitops-project.git'
      }
    }
    stage('Build & Push') {
      steps {
        sh 'docker build -t abayomi2/gitops-app:latest ./app'
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
        sh 'docker push abayomi2/gitops-app:latest'
      }
    }
    stage('Update Manifest') {
      steps {
        sh '''
          sed -i 's|abayomi2/gitops-app:.*|abayomi2/gitops-app:latest|' manifests/deployment.yaml
          git config user.name "Jenkins Bot"
          git config user.email "jenkins@example.com"
          git add manifests/deployment.yaml
          git commit -m "Update image tag via Jenkins"
          git push
        '''
      }
    }
  }
}
