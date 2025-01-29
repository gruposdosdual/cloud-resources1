# Usar la imagen base de Nginx
FROM nginx:latest

# Copiar el archivo index.html al directorio predeterminado de Nginx
COPY index.html /usr/share/nginx/html/index.html

# Exponer el puerto 80 para servir el contenido
EXPOSE 80

# Comando predeterminado para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
