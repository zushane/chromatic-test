pipeline {
    agent any
    environment {
        SLACK_CHANNEL = "#test-private"
        PROJECT_NAME = "storybook-test"
        PROJECT_PATH_TO_STORYBOOK = "/var/www/html/storybook-static"
        NODE_TAG = "lts"
        AWSCLI_TAG = "2.1.3"
        AWSCLI_PROFILE = "${PROJECT_NAME}"
        AWSCLI_S3_BUCKET = "storybook-test-dev.zu.com"
    }

    stages {
        stage('Pull docker containers.') {
            steps {
                sh 'make docker_pull'
            }
        }

        stage('Node package installation') {
            steps {
                sh 'make npm_install'
            }
        }

        stage('Build storybook') {
            steps {
               sh 'make build_storybook' 
            }
        }
    
        stage('Publish storybook') {
            steps {
                sh 'make publish_storybook'
            }
        }    
    
    }
    post {
        success {
            echo "StoryBook for ${PROJECT_NAME} on branch ${env.BRANCH_NAME}. Please view using VPN or in-office network.\n http://storybook-test-dev.zu.com.s3-website-us-west-2.amazonaws.com/${env.BRANCH_NAME}/."
        }

        failure {
            echo "${repo_label} - Failed to build ${PROJECT_NAME} on branch ${env.BRANCH_NAME}. (${env.RUN_DISPLAY_URL})"
        }

        always {
            sh 'make docker_prune'
        }
    }
}
