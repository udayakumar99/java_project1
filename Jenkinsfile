pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
        SCANNER_HOME = tool 'mysonar'
        IMAGE_NAME = "udayakumar99/java_project"
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout Code') {
            steps {
                git 'https://github.com/udayakumar99/java_project1.git'
            }
        }
        stage('Code Quality Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=java_project1'
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
                sh 'trivy fs --format json -o trivyfs.json .'
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
                    def imageTag = "${IMAGE_NAME}:${BUILD_ID}"
                    withDockerRegistry(credentialsId: '7643a792-59c0-4068-b7a0-6d91be39cc75') {
                        sh "docker build -t ${imageTag} ."
                        sh "docker push ${imageTag}"
                    }
                }
            }
        }
        stage('Scan Docker Image') {
            steps {
                sh "trivy image ${IMAGE_NAME}:${BUILD_ID} "
            }
        }
        stage('Run Container') {
            steps {
                script {
                    sh "docker run -d --name cont1 -p 8080:8080 ${IMAGE_NAME}:${BUILD_ID} "
                }
            }
        }
    }
}
