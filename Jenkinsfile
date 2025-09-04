pipeline {
    
    agent any 
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        
        stage('Checkout'){
           steps {
                git credentialsId: '2b194bde-6566-4870-a21c-44547586c229', 
                url: 'https://github.com/asbhanu1986/cicd-end-to-end/',
                branch: 'main'
           }
        }

        stage('Build Docker'){
            steps{
                script{
                    sh '''
                    echo 'Buid Docker Image'
                    docker build -t asbhanu1986/cicd-e2e:${BUILD_NUMBER} .
                    '''
                }
            }
        }

stage('Push the artifacts'){
    steps {
        script {
            withCredentials([usernamePassword(
                credentialsId: 'dockerhub-creds',   // 👈 ID of your DockerHub credentials in Jenkins
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASS'
            )]) {
                sh '''
                echo 'Login to DockerHub'
                echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                echo 'Push to Repo'
                docker push asbhanu1986/cicd-e2e:${BUILD_NUMBER}
                '''
            }
        }
    }
}
        
        stage('Checkout K8S manifest SCM'){
            steps {
                git credentialsId: '2b194bde-6566-4870-a21c-44547586c229', 
                url: 'https://github.com/asbhanu1986/cicd-demo-manifests-repo.git',
                branch: 'main'
            }
        }
        
        stage('Update K8S manifest & push to Repo') {
    steps {
        script {
            withCredentials([usernamePassword(credentialsId: '2b194bde-6566-4870-a21c-44547586c229', 
                                             passwordVariable: 'GIT_PASSWORD', 
                                             usernameVariable: 'GIT_USERNAME')]) {
                sh '''
                # Check file exists
                if [ -f deploy/deploy.yaml ]; then
                    echo "Before update:"
                    cat deploy/deploy.yaml

                    # Update BUILD_NUMBER
                    sed -i "s/32/${BUILD_NUMBER}/g" deploy/deploy.yaml

                    echo "After update:"
                    cat deploy/deploy.yaml

                    # Commit and push
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

                        '''                        
                    }
                }
            }
        }
    }
}
