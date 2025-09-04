pipeline {
    agent any
    environment {
        IMAGE_NAME = "asbhanu1986/cicd-e2e"
    }
    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/asbhanu1986/cicd-end-to-end.git',
                    credentialsId: '2b194bde-6566-4870-a21c-44547586c229'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', 
                                                     passwordVariable: 'DOCKER_PASSWORD', 
                                                     usernameVariable: 'DOCKER_USERNAME')]) {
                        sh """
                            echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin
                            docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                        """
                    }
                }
            }
        }

        stage('Update K8S manifest & push to Repo') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '2b194bde-6566-4870-a21c-44547586c229', 
                                                     passwordVariable: 'GIT_PASSWORD', 
                                                     usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                        if [ -f deploy/deploy.yaml ]; then
                            echo "Before update:"
                            cat deploy/deploy.yaml

                            # Update BUILD_NUMBER
                            sed -i "s/32/${BUILD_NUMBER}/g" deploy/deploy.yaml

                            echo "After update:"
                            cat deploy/deploy.yaml

                            # Commit and push changes
                            git add deploy/deploy.yaml
                            git commit -m "Updated deploy.yaml | Jenkins Pipeline"
                            git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/asbhanu1986/cicd-demo-manifests-repo.git HEAD:main
                        else
                            echo "Error: deploy/deploy.yaml not found"
                            exit 1
                        fi
                        '''
                    }
                }
            }
        }
    }
} // <-- Added this closing brace for the pipeline
