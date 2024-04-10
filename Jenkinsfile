pipeline {
    agent any

    triggers {
        // No schedule configured so will only run due to
        // SCM changes if triggered by a post-commit hook
        // No ingress internet to this server for incoming
        // GitHub webhook request
        pollSCM '' 
    }
    
    stages{
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

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate and Apply') {
            steps {
                sh 'terraform validate'
                sh 'terraform apply --auto-approve' 
            }
        } 
    }
}