pipeline {
    agent any

    environment {
        CONTAINER_ID = ''
        SUM_PY_PATH = './sum.py'
        DIR_PATH = '.'
        TEST_FILE_PATH = './test_variables.txt'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    sh 'docker build -t sum-app .'
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    def output = sh(script: 'docker run -dit sum-app', returnStdout: true).trim()
                    env.CONTAINER_ID = output
                }
            }
        }

        

stage('Test') {
    steps {
        script {
            def testLines = readFile(TEST_FILE_PATH).split('\n')

            for (line in testLines) {
                def vars = line.split(' ')
                def arg1 = vars[0]
                def arg2 = vars[1]
                def expectedSum = vars[2].toFloat()

                def output = sh(script: "docker exec ${env.CONTAINER_ID} python /app/sum.py ${arg1} ${arg2}", returnStdout: true).trim()
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
            // Connexion à DockerHub
            sh "docker login -u 'awatraore06' -p 'tonken Docker'"

            // Taguer l’image avant de l'envoyer
            sh "docker tag sum-app awatraore06/sum-app:latest"

            // Pousser l’image sur DockerHub
            sh "docker push awatraore06/sum-app:latest"
        }
    }
}

