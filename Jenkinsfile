pipeline {
    agent any
    environment {
        registry = "supermadu7/capstone"
        registryCredential = 'supermadu'
        dockerImage = ''
    }
    stages {
         stage('Lint files') {
              steps {
                  sh 'make lint'
              }
         }
         stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage('Upload Image to Docker hub') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
        stage('Update Kube Config'){
            steps {
                withAWS(region:'us-east-2',credentials:'supermaduaws') {
                    sh 'sudo aws eks --region us-east-2 update-kubeconfig --name supermadu-capstone'                    
                }
            }
        }
        stage('Deploy Updated Image to Cluster'){
            steps {
                sh '''
                    export IMAGE="$registry:$BUILD_NUMBER"
                    sed -ie "s~IMAGE~$IMAGE~g" resources/container.yml
                    sudo kubectl apply -f ./resources
                    '''
            }
        }
    }
}