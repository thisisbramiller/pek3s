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

    parameters {
        choice choices: ['1', '2'], name: 'K8S_CONTROL_INSTANCES'
        choice choices: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '28', '26', '27', '28', '29', '30', '31', '32'], name: 'K8S_WORKER_INSTANCES'
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
                    sh "terraform apply --auto-approve -var k8s_control_instances=${params.K8S_CONTROL_INSTANCES} -var k8s_worker_instances=${params.K8S_WORKER_INSTANCES}"
                    echo 'Waiting for OS Bootup...'
                    sleep 30
                    echo 'Generating known_hosts...'
                    sh './scripts/generate_known_hosts.sh'
                }
            }
        }
        stage('Configure and Deploy K3S') {
            steps {
                dir('ansible') {
                    sh "${ANSIBLE_BIN}/ansible-galaxy collection install -r ./collections/requirements.yaml"
                    ansiblePlaybook(installation: 'ansible', inventory: "${WORKSPACE}/ansible/inventory/inventory.ini", playbook: "${WORKSPACE}/ansible/site.yaml")
                }
            }
        }
    }
}