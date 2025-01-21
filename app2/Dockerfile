FROM node:18-alpine
WORKDIR /app2
COPY package.json ./
RUN npm install 
# --production && npm cache clean --force
COPY . .
# Ejecutar el script de construcción
RUN npm run build

# Etapa 2: Servir los archivos estáticos con Nginx
FROM nginx:alpine

# Copiar los archivos estáticos generados en la etapa de construcción
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponer el puerto que usa Nginx
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]






EXPOSE 3000
CMD ["node", "app.js"]






#FROM node:18
#WORKDIR /app
#COPY package.json .
#RUN npm install
#COPY . .
#EXPOSE 3000
# Define el comando para iniciar la aplicación
#CMD ["node", "app.js"]
