pipeline {
    agent any

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
        stage('Quality Gate') {
            steps {
                timeout(time: 1)
            }
        }
    }
}