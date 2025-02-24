# Utilisation de l'image officielle Python
FROM python:3.13.0-alpine3.20

# Définition du répertoire de travail
WORKDIR /app

# Copie du script dans le conteneur
COPY sum.py /app/sum.py

# Commande de base pour que le conteneur reste actif
CMD ["tail", "-f", "/dev/null"]
