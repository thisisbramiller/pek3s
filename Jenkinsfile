pipeline {
    agent any

    stages{
        stage('SonarCloud Analysis') {
            steps{
                def scannerHome = tool('sonarScanner')
                withSonarQubeEnv('SonarCloud') {
                    sh '''
                        sonar-scanner
                        -Dsonar.organization=thisisbramiller \
                        -Dsonar.projectKey=thisisbramiller_pek3s \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=https://sonarcloud.io
                    '''
                }
            }
        }
    }
}