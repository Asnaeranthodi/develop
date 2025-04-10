pipeline {
  agent any

  environment {
    IMAGE_NAME = "asnashameel/develop:latest"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build with Maven') {
      steps {
        sh 'mvn clean install'      }
    }

    stage('Docker Build & Pull') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
            def image = docker.build("$IMAGE_NAME")
            image.push()
          }
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh 'kubectl delete deploy --all || true'
        sh 'kubectl apply -f deploy.yaml'
        sh 'kubectl delete svc --all || true'
        sh 'kubectl apply -f nodeport.yaml'
      }
    }
  }
}
