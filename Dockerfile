#FROM node:16 version of node
#always use latest like below unline above
FROM node:lts-alpine

#create folder for our app
#all commands will run in this app folder now
WORKDIR /app

#copy from current source (.) which is app source code
# to current working directory (.) (image)
#COPY . . #breaking commands to use layers and caching
#COPYING package-lock.json
COPY package*.json ./
COPY client/package*.json client/

#devdeps are excluded #to make use of layers / caching
#break this install in two steps, client and server
#RUN npm install --only=production
#for client
RUN npm run install-client --only=production

COPY server/package*.json server/

#for server
RUN npm run install-server --only=production

#copy source code
COPY client/ client/

#react app is built and publisehd in public of server
RUN npm run build --prefix client

COPY server/ server/

#docker will run these commands as root user, whic has full access to that 
#container - security issue
#node image has node user with less previlegs
USER node

CMD ["npm", "start", "--prefix", "server"]

#expose port outside of the container, app is running on 8000 
EXPOSE 8000