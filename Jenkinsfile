pipeline {
    agent any

    environment {
        CONTAINER_ID = ''
        SUM_PY_PATH = './sum.py'
        DIR_PATH = '.'
        TEST_FILE_PATH = './test_variables.txt'
        DOCKER_IMAGE = 'awatraore06/sum-app:latest'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/evatra06/mon-projet.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    bat 'docker build -t sum-app .'
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    def output = bat(script: 'docker run -dit sum-app', returnStdout: true).trim()
                    env.CONTAINER_ID = output.tokenize().last() // Récupérer l'ID du conteneur
                    echo "Container ID: ${env.CONTAINER_ID}"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    def testLines = readFile(TEST_FILE_PATH).split('\n')

                    for (line in testLines) {
                        def vars = line.split(' ')
                        if (vars.length < 3) {
                            echo "⚠️ Ligne invalide ignorée : ${line}"
                            continue
                        }

                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        def output = bat(script: "docker exec ${env.CONTAINER_ID} python /app/sum.py ${arg1} ${arg2}", returnStdout: true).trim()
                        def result = output.toFloat()

                        if (result == expectedSum) {
                            echo "✅ Test réussi : ${arg1} + ${arg2} = ${expectedSum}"
                        } else {
                            error "❌ Échec du test : attendu ${expectedSum}, obtenu ${result}"
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKER_PASSWORD')]) {
                        // Connexion à DockerHub
                        bat "echo %DOCKER_PASSWORD% | docker login -u 'awatraore06' --password-stdin"

                        // Taguer l’image avant de l'envoyer
                        bat "docker tag sum-app ${DOCKER_IMAGE}"

                        // Pousser l’image sur DockerHub
                        bat "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
    }
}
