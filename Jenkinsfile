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
                script {
                    // Utilisation de la branche 'main' pour récupérer le code
                    git branch: 'master', url: 'https://github.com/evatra06/mon-projet.git'
                    // Vérification du statut du dépôt après le clone
                    sh 'git status'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Construction de l'image Docker
                    bat 'docker build -t sum-app .'
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    // Lancement du conteneur Docker et récupération de son ID
                    def output = bat(script: 'docker run -dit sum-app', returnStdout: true).trim()
                    env.CONTAINER_ID = output // Le conteneur ID est directement récupéré ici
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

                        // Exécution du test dans le conteneur Docker
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
                    // Connexion à DockerHub et déploiement de l'image
                    withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKER_PASSWORD')]) {
                        bat "echo %DOCKER_PASSWORD% | docker login -u 'awatraore06' --password-stdin"
                        bat "docker tag sum-app ${DOCKER_IMAGE}"
                        bat "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
    }
}
