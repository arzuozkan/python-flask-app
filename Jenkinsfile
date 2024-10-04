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
                sh "${scannerHome}/bin/sonar-scanner"
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
        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing to Docker Hub'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo "${PASS}" | docker login --username "${USER}" --password-stdin
                    docker tag my-flask-app ${USER}/flask-app:latest
                    docker push ${USER}/flask-app:latest
                    '''
                }
            }
        }
        /*stage('Trivy Image Scan') {
            steps {
                // Trivy ile imaj taraması
                script {
                    sh 'trivy image --exit-code 1 my-flask-app:latest'
                }
            }
        }*/
        stage('Trivy Image Scan') {
            steps {
                script {
                    // Run Trivy to scan the Docker image
                    def trivyOutput = sh(script: "trivy image my-flask-app:latest", returnStdout: true).trim()

                    // Display Trivy scan results
                    println trivyOutput

                    // Check if vulnerabilities were found
                    if (trivyOutput.contains("Total: 0")) {
                        echo "No vulnerabilities found in the Docker image."
                    } else {
                        echo "Vulnerabilities found in the Docker image."
                        // You can take further actions here based on your requirements
                        // For example, failing the build if vulnerabilities are found
                        // error "Vulnerabilities found in the Docker image."
                    }
                }
            }
        }
        stage('Deploy App on k8s') {
            steps {
                withCredentials([
                    string(credentialsId: 'my_kubernetes', variable:'api_token')
                    ]) {
                    sh '''
                    kubectl --token $api_token --server https://192.168.49.2:8443 --insecure-skip-tls-verify=true apply -f flask-app.yaml
                    '''
               }
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
        }
    }*/
    post {
        always {
            // İşlem sonrası temizlik
            cleanWs()
        }
    }
}