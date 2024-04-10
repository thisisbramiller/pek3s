pipeline {
    agent any

    environment {
        PM_API_TOKEN_ID     = credentials('pm-api-token-id')
        PM_API_TOKEN_SECRET = credentials('pm-api-token-secret') 
    }

    triggers {
        // No schedule configured so will only run due to
        // SCM changes if triggered by a post-commit hook
        // No ingress internet to this server for incoming
        // GitHub webhook request
        pollSCM '' 
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
                        script {
                            scannerHome = tool('sonarScanner')
                        }
                        withSonarQubeEnv('SonarCloud') {
                            sh "${scannerHome}/bin/sonar-scanner"
                        }
                    }
                }
                stage('Validate') {
                    steps {
                        script {
                            terraform = tool('terraform')
                        }
                        sh "${terraform} validate"
                    }
                }
                
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    terraform = tool('terraform')
                }                
                sh "${terraform} apply --auto-approve"
            }
        } 
    }
}