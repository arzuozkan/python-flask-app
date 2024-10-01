pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                // GitHub'dan kodu çek
                git 'https://github.com/kullanici-adi/repo-adi.git'
            }
        }
        /*stage('SonarQube Analysis') {
            steps {
                // SonarQube ile kaynak kod analizi
                script {
                    sh 'sonar-scanner -Dsonar.projectKey=flask-app -Dsonar.sources=./ -Dsonar.host.url=http://your-sonarqube-url -Dsonar.login=your-sonarqube-token'
                }
            }
        }*/
        stage('Trivy Source Code Scan') {
            steps {
                // Trivy ile kaynak kod güvenlik taraması (misconfiguration)
                script {
                    sh 'trivy fs --exit-code 1 ./'
                }
            }
        }
        /*stage('Build Docker Image') {
            steps {
                script {
                    // Docker image oluştur
                    sh 'docker build -t flask-app:latest .'
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                // Trivy ile imaj taraması
                script {
                    sh 'trivy image --exit-code 1 flask-app:latest'
                }
            }
        }
        stage('Deploy to Kubernetes') {
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
