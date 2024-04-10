pipeline {
    agent any

    environment {
        PM_API_TOKEN_ID     = credentials('pm-api-token-id')
        PM_API_TOKEN_SECRET = credentials('pm-api-token-secret')
        SONAR_SCANNER       = tool('sonarScanner')
        TF_VAR_ssh_key      = credentials('proxmox-ssh-key')
        TF_VAR_ssh_key_ci   = credentials('jenkins-ssh-key')
    }

    tools {
        terraform 'terraform'
    }
    
    stages{
        stage('SonarCloud Analysis') {
            steps {
                withSonarQubeEnv('SonarCloud') {
                    sh "${SONAR_SCANNER}/bin/sonar-scanner"
                }
            }
        }
        stage('Provision Infrastructure') {
            steps {
                sh "terraform init"
                sh "terraform validate"
                sh "terraform apply --auto-approve"
            }
        }
        stage('Configure and Deploy K3S') {
            steps {
                echo 'ansiblePlaybook()'
            }
        }
    }
}