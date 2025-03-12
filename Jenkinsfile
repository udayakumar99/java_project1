pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
        SCANNER_HOME = tool 'mysonar'
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout Code') {
            steps {
                git 'https://github.com/udayakumar99/maven_project1.git'
            }
        }
        stage('Code Quality Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=maven_project1'
                }
            }
        }
        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./target --format XML', 
                    odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('Trivy Scan (Filesystem)') {
            steps {
                sh 'trivy fs . > trivyfs.txt'
            }
        }
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: '7643a792-59c0-4068-b7a0-6d91be39cc75') {
                        sh 'docker build -t image1 .'
                        sh 'docker tag image1 udayakumar99/maven_project:$BUILD_ID'
                        sh 'docker push udayakumar99/maven_project:$BUILD_ID'
                    }
                }
            }
        }
        stage('Scan Docker Image') {
            steps {
                sh 'trivy image udayakumar99/maven_project:$BUILD_ID'
            }
        }
        stage('Run Container') {
            steps {
                sh 'docker run -d --name cont1 -p 8080:8080 udayakumar99/maven_project:$BUILD_ID'
            }
        }
    }
}
