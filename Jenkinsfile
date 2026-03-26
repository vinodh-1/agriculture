pipeline {
    agent any

    environment {
        DOCKER_USER = "vinodh21"
        IMAGE_NAME = "agriculture"
        IMAGE_TAG = "latest"
        EMAIL_RECIPIENTS = "vinodhmaninadh2001@gmail.com"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/vinodh-1/agriculture.git'
            }
            post {
                success {
                    emailext subject: "Checkout SUCCESS",
                             body: "Checkout stage completed successfully.",
                             to: "${EMAIL_RECIPIENTS}"
                }
                failure {
                    emailext subject: "Checkout FAILED",
                             body: "Checkout stage failed.",
                             to: "${EMAIL_RECIPIENTS}"
                }
            }
        }

        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
            post {
                success {
                    emailext subject: "Build SUCCESS",
                             body: "Docker image build successful.",
                             to: "${EMAIL_RECIPIENTS}"
                }
                failure {
                    emailext subject: "Build FAILED",
                             body: "Docker image build failed.",
                             to: "${EMAIL_RECIPIENTS}"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker_CRED', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                    echo "$PASS" | docker login -u "$USER" --password-stdin
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    docker push ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
            post {
                success {
                    emailext subject: "Docker Push SUCCESS",
                             body: "Image pushed to DockerHub successfully.",
                             to: "${EMAIL_RECIPIENTS}"
                }
                failure {
                    emailext subject: "Docker Push FAILED",
                             body: "Failed to push image to DockerHub.",
                             to: "${EMAIL_RECIPIENTS}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                export KUBECONFIG=/var/lib/jenkins/.kube/config
                kubectl apply -f deployment.yml
                """
            }
            post {
                success {
                    emailext subject: "Deployment SUCCESS",
                             body: "Kubernetes deployment successful.",
                             to: "${EMAIL_RECIPIENTS}"
                }
                failure {
                    emailext subject: "Deployment FAILED",
                             body: "Kubernetes deployment failed.",
                             to: "${EMAIL_RECIPIENTS}"
                }
            }
        }
    }

    post {
        always {
            emailext subject: "Pipeline Completed",
                     body: "Jenkins Pipeline execution finished.",
                     to: "${EMAIL_RECIPIENTS}"
        }
    }
}
