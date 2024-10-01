pipeline {
    agent any
    environment{
        SONARQUBE_TOKEN = credentials('sonartoken')
    }
    stages {
        stage('Checkout') {
            steps {
                // GitHub'dan kodu çek
                git 'https://github.com/arzuozkan/python-flask-app'
            }
        }
        stage('SonarQube Code Scan') {
            steps {
                script {
                    // SonarQube ortam değişkenini kullanarak kaynak kodu analiz et
                    withSonarQubeEnv(credentialsId: 'sonartoken') {  // 'SonarQube', Jenkins'teki SonarQube server ayarlarının ismi
                        sh """
                        sonar-scanner \
                          -Dsonar.projectKey=my_project_key \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=http://192.168.133:9000 \
                          -Dsonar.login=${SONARQUBE_TOKEN}
                        """
                    }
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
