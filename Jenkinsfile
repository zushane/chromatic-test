pipeline {
    agent any
    environment {
        SLACK_CHANNEL = "#test-private"
        PROJECT_NAME = "storybook_test"
        PROJECT_PATH_TO_STORYBOOK = "./storybook-static"
        AWSCLI_TAG = "2.6.0"
        AWSCLI_PROFILE = ${PROJECT_NAME}
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

    post {
        success {
            slackSend channel: "${SLACK_CHANNEL}", color: "good", message: ":book: StoryBook for ${PROJECT_NAME} on branch ${env.BRANCH_NAME}. Please view using VPN or in-office network.\n http://storybook-test-dev.zu.com.s3website-us-west-2.amazonaws.com/${env.BRANCH_NAME}/."
        }
        failure {
            slackSend channel: "${SLACK_CHANNEL", color: "bad", message: ":x: ${repo_label} - Failed to build ${PROJECT_NAME} on branch ${env.BRANCH_NAME}. (<${env.RUN_DISPLAY_URL}|Open>)"
        }
    }
}
