pipeline {
    agent any

    /*environment{
        SONARQUBE_TOKEN = credentials('sonartoken')
    }*/
    
    stages {
        stage('Checkout') {
            steps {
                // GitHub'dan kodu çek
                git 'https://github.com/arzuozkan/python-flask-app'
            }
        }
        stage('SonarQube Code Scan') {
            environment {
                scannerHome = tool 'sonar-scanner-tool';
            }
            steps {
              withSonarQubeEnv(credentialsId: 'sonartoken', installationName: 'sonarqube-1') {
                sh """
                ${scannerHome}/bin/sonar-scanner\
                      -Dsonar.projectKey=my_project_key \  # Projeyi tanımlayan benzersiz anahtar
                      -Dsonar.sources=. \                 # Kaynak kod dizini
                """
              }
            }
        }
        stage('Trivy Source Code Scan') {
            steps {
                // Trivy ile kaynak kod güvenlik taraması (misconfiguration)
                script {
                    sh 'trivy fs --exit-code 1 ./'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Docker image oluştur
                    sh 'docker build -t my-flask-app:latest .'
                }
            }
        }
        /*stage('Push to Docker Hub') {
            steps {
                echo 'Pushing to Docker Hub'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo "${PASS}" | docker login --username "${USER}" --password-stdin
                    docker tag flask-monitoring ${USER}/flask-monitoring:latest
                    docker push ${USER}/flask-monitoring:latest
                    '''
                }
            }
        }*/
        stage('Trivy Image Scan') {
            steps {
                // Trivy ile imaj taraması
                script {
                    sh 'trivy image --exit-code 1 my-flask-app:latest'
                }
            }
        }
        /*stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Kubernetes'e deploy et
                    sh 'kubectl apply -f k8s/deployment.yaml'
                    sh 'kubectl apply -f k8s/service.yaml'
                }
            }
        }*/
    }
    post {
        always {
            // İşlem sonrası temizlik
            cleanWs()
        }
    }
}
