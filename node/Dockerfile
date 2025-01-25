FROM node

WORKDIR /usr/src/app

COPY . /usr/src/app

# #Enable another containers to access this one from port 3000
EXPOSE 3000

RUN npm install jest -g
RUN npm install

RUN ls -a
ENTRYPOINT [ "node","index.js" ]