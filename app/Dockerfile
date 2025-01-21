FROM node:18-alpine
WORKDIR /app
COPY package.json .
RUN npm install --production && npm cache clean --force
COPY . .
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
