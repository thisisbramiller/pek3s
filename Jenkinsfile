pipeline {
    agent any

    environment {
        PM_API_TOKEN_ID     = credentials('pm-api-token-id')
        PM_API_TOKEN_SECRET = credentials('pm-api-token-secret') 
    }

    tools {
        sonarHome 'sonarScanner'
        terraform 'terraform'
    }
    
    stages{
        stage('Terraform Init') {
            steps {
                script {
                    terraform = tool('terraform')
                }
                sh "${terraform} init"
            }
        }
        stage('Quality') {
            parallel {
                stage('SonarCloud Analysis') {
                    steps {
                        withSonarQubeEnv('SonarCloud') {
                            sh "${scannerHome}/bin/sonar-scanner"
                        }
                    }
                }
                stage('Validate') {
                    steps {
                        sh "${terraform} validate"
                    }
                }
                
            }
        }

        stage('Terraform Apply') {
            steps {               
                sh "${terraform} apply --auto-approve"
            }
        } 
    }
}