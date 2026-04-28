pipeline {
    agent any

    environment {
        DOCKER_USER = "kiruthikaannaduari"
    }

    stages {

        stage('Docker Test') {
            steps {
                sh 'docker ps'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Build Backend') {
            steps {
                sh '''
                docker buildx create --use || true
                docker buildx build --platform linux/amd64,linux/arm64 -t $DOCKER_USER/backend:latest --push ./backend
                '''
            }
        }

        stage('Build Frontend') {
            steps {
                sh '''
                docker buildx build --platform linux/amd64,linux/arm64 -t $DOCKER_USER/frontend:latest --push ./frontend
                '''
            }
        }

        stage('Deploy Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
}