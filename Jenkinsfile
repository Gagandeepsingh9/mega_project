pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "mrsinghdocker/mega_app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        GIT_BRANCH = "master"
    }
    stages {
        stage('Cleaning Workspace') {
            steps{
                cleanWs()
            }
        }
        stage('Cloning') {
            steps{
                git url: "https://github.com/Gagandeepsingh9/mega_project.git", branch: "$GIT_BRANCH"
            }
        }
        stage('building') {
            steps {
                sh ' docker build -t $DOCKER_IMAGE:$IMAGE_TAG .'
            }
        }
        stage('pushing') {
            steps{
                withCredentials([usernamePassword(
                    credentialsId: "DOCKER_CREDS",
                    usernameVariable: "DOCKER_USER",
                    passwordVariable: "DOCKER_PASS"
                )]){
                sh ' echo ${DOCKER_PASS} | docker login -u "$DOCKER_USER" --password-stdin '
                sh ' docker push $DOCKER_IMAGE:$IMAGE_TAG '
                }
            }
        }
        stage('testing') {
            steps {
                sh 'trivy fs .'
            }
        }
        stage('updating manifest files') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "GITHUB_CREDS",
                    usernameVariable: "GIT_USER",
                    passwordVariable: "GIT_PASS"
                    )]){
                sh '''
                 sed -i "s|image:.*|image: $DOCKER_IMAGE:$IMAGE_TAG|g" k8s/shop-deployment.yml
                 git add k8s/shop-deployment.yml
                 git commit -m "UPDATED BY JENKINS"
                 git remote set-url origin "https://$GIT_PASS@github.com/$GIT_USER/mega_project.git"
                 git push origin $GIT_BRANCH
                '''
                }
            }
        }
    }
}