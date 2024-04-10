pipeline {
    agent any

    environment {
        PM_API_TOKEN_ID     = credentials('pm-api-token-id')
        PM_API_TOKEN_SECRET = credentials('pm-api-token-secret')
        SONAR_SCANNER       = tool('sonarScanner')
        ANSIBLE_BIN         = tool('ansible')
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
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform validate'
                    sh 'terraform apply --auto-approve'
                    echo 'Waiting for OS Bootup...'
                    sleep 30
                    echo 'Generating known_hosts...'
                    sh './scripts/generate_known_hosts.sh'
                }
            }
        }
        stage('Configure and Deploy K3S') {
            steps {
                sh "${ANSIBLE_BIN}/ansible-galaxy collection install -r ./collections/requirements.yml"
                ansiblePlaybook(installation: 'ansible', inventory: "${WORKSPACE}/ansible/inventory/inventory.ini", playbook: "${WORKSPACE}/ansible/site.yaml")
            }
        }
    }
}