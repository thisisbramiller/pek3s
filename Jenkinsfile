pipeline {
    agent any

    stages{
        stage('SonarCloud Analysis') {
            steps {
                script {
                    scannerHome = tool('sonarScanner')
                }
                withSonarQubeEnv('SonarCloud') {
                    sh """
                        ${scannerHome}/bin/sonar-scanner
                        -Dsonar.organization=thisisbramiller \
                        -Dsonar.projectKey=thisisbramiller_pek3s \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=https://sonarcloud.io
                    """
                }
            }
        }
    }
}