# Usar la imagen base de Node.js 18
FROM node:18

# Establecer el directorio de trabajo en el contenedor
WORKDIR /app/backend

# Copiar los archivos package.json y package-lock.json del backend
COPY backend/package*.json ./

# Instalar las dependencias del backend
RUN npm install

# Copiar todo el código del backend al contenedor
COPY backend/ ./  


# Exponer el puerto 3000
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "server.js"]















