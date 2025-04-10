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
        sh 'mvn clean install'
      }
    }

    stage('SonarQube Analysis') {
      environment {
        SONAR_TOKEN = credentials('sonarqube-token') // Jenkins secret text credential
      }
      steps {
        sh '''
          mvn clean verify sonar:sonar \
          -Dsonar.projectKey=develop \
          -Dsonar.projectName=develop \
          -Dsonar.host.url=http://54.90.118.188:9000 \
          -Dsonar.token=$SONAR_TOKEN
        '''
      }
    }

    stage('Docker Build & Push') {
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
