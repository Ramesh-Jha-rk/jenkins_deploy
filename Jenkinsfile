pipeline {
    agent any
    
    parameters {
        choice(
            name: 'REPO_TYPE',
            choices: ['public', 'private'],
            description: 'Select repository type'
        )
        string(
            name: 'GIT_REPO_URL',
            defaultValue: '',
            description: 'Git repository URL'
        )
        string(
            name: 'GIT_BRANCH',
            defaultValue: 'main',
            description: 'Git branch to deploy'
        )
        credentials(
            name: 'GIT_CREDENTIALS',
            description: 'Git credentials for private repositories',
            defaultValue: '',
            credentialType: 'Username with password',
            required: false
        )
        string(
            name: 'DEPLOY_ENV',
            defaultValue: 'staging',
            description: 'Deployment environment (staging/production)'
        )
    }
    
    environment {
        BUILD_TIMESTAMP = sh(script: "date +%Y%m%d-%H%M%S", returnStdout: true).trim()
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Checking out ${params.REPO_TYPE} repository: ${params.GIT_REPO_URL}"
                    echo "Branch: ${params.GIT_BRANCH}"
                    
                    if (params.REPO_TYPE == 'private') {
                        // Checkout private repository with credentials
                        if (!params.GIT_CREDENTIALS) {
                            error("Credentials required for private repository")
                        }
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: "*/${params.GIT_BRANCH}"]],
                            userRemoteConfigs: [[
                                url: params.GIT_REPO_URL,
                                credentialsId: params.GIT_CREDENTIALS
                            ]]
                        ])
                    } else {
                        // Checkout public repository without credentials
                        checkout([
                            $class: 'GitSCM',
                            branches: [[name: "*/${params.GIT_BRANCH}"]],
                            userRemoteConfigs: [[
                                url: params.GIT_REPO_URL
                            ]]
                        ])
                    }
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    echo "Building application..."
                    echo "Environment: ${params.DEPLOY_ENV}"
                    echo "Build timestamp: ${env.BUILD_TIMESTAMP}"
                    
                    // Add your build commands here
                    // Example:
                    // sh 'npm install'
                    // sh 'npm run build'
                    // sh 'mvn clean package'
                    // sh 'docker build -t myapp:${BUILD_TIMESTAMP} .'
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    echo "Running tests..."
                    
                    // Add your test commands here
                    // Example:
                    // sh 'npm test'
                    // sh 'mvn test'
                    // sh 'pytest'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    echo "Deploying to ${params.DEPLOY_ENV}..."
                    
                    // Add your deployment commands here based on environment
                    if (params.DEPLOY_ENV == 'production') {
                        echo "Deploying to production environment..."
                        // Add production deployment steps
                    } else {
                        echo "Deploying to staging environment..."
                        // Add staging deployment steps
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "Deployment successful!"
            echo "Repository: ${params.GIT_REPO_URL}"
            echo "Branch: ${params.GIT_BRANCH}"
            echo "Environment: ${params.DEPLOY_ENV}"
        }
        failure {
            echo "Deployment failed!"
        }
        always {
            echo "Cleaning up..."
            cleanWs()
        }
    }
}
