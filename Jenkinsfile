pipeline {
    agent any

    environment {
        PM_API_TOKEN_ID     = credentials('pm-api-token-id')
        PM_API_TOKEN_SECRET = credentials('pm-api-token-secret')
        SONAR_SCANNER = tool('sonarScanner')
    }

    tools {
        terraform 'terraform'
    }
    
    stages{
        stage('Terraform Init') {
            steps {
                sh "terraform init"
            }
        }
        stage('Quality') {
            parallel {
                stage('SonarCloud Analysis') {
                    steps {
                        withSonarQubeEnv('SonarCloud') {
                            sh "${SONAR_SCANNER}/bin/sonar-scanner"
                        }
                    }
                }
                stage('Validate') {
                    steps {
                        sh "terraform validate"
                    }
                }
                
            }
        }

        stage('Terraform Apply') {
            steps {               
                sh "terraform apply --auto-approve"
            }
        } 
    }
}