FROM node

WORKDIR /usr/src/app

COPY . /usr/src/app

# #Enable another containers to access this one from port 3000
EXPOSE 3000

# RUN cd $pwd/usr/src/app
RUN npm install express --verbose

RUN ls -a
ENTRYPOINT [ "node","index.js" ]