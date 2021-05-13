pipeline {
    agent any
    stages {
        stage('Checkout Watchlist') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/andywuest/harbour-watchlist.git'
            }
        }
        stage('Run C++ tests'){
            steps {
                sh "cd tests && ls -l && bash runTests.sh"
            }
        }
        stage('Run QML test'){
            steps {
                sh "ls -l"
            }
        }
    }
    post {
        always{
            xunit (
                thresholds: [ skipped(failureThreshold: '0'), failed(failureThreshold: '0') ],
                tools: [ QtTest(pattern: 'tests/**/*.xml') ])
            
        }
    }
}

