
FROM node:20-alpine

#WORKDIR /app

#ENV PATH /node_modules/.bin:$PATH

#COPY package.json /app/package.json
#RUN npm install @vue/cli -g
#RUN npm install @vue/cli-service -g
#RUN npm install

#CMD ["npm", "run", "serve"]
WORKDIR /app
RUN apk update && apk upgrade && apk add curl py-pip make g++
COPY package*.json ./
COPY . .
EXPOSE 8080
RUN npm install
CMD npm run serve