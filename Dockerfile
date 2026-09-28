FROM nginx:alpine

# App 100% estática: solo se copia el index.html al directorio público de nginx
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
