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
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', 
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

        stage('Update K8S manifests & push to Repo') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '2b194bde-6566-4870-a21c-44547586c229', 
                                                     passwordVariable: 'GIT_PASSWORD', 
                                                     usernameVariable: 'GIT_USERNAME')]) {
                        sh """
                        set -e
                        for file in deploy/deploy.yaml deploy/pod.yaml; do
                            if [ -f \$file ]; then
                                echo "Before update: \$file"
                                cat \$file

                                # Update image version
                                sed -i "s|v[0-9]\\+|v${BUILD_NUMBER}|g" \$file

                                echo "After update: \$file"
                                cat \$file
                            else
                                echo "Warning: \$file not found"
                            fi
                        done

                        # Commit only if there are changes
                        git add deploy/deploy.yaml deploy/pod.yaml || true
                        if ! git diff --cached --quiet; then
                            git commit -m "Updated manifests | Jenkins build ${BUILD_NUMBER}"
                            git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/asbhanu1986/cicd-demo-manifests-repo.git HEAD:main
                        else
                            echo "No changes to commit"
                        fi
                        """
                    }
                }
            }
        }
    }
}
