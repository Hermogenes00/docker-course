FROM nginx:latest

WORKDIR /app

#ENTRYPOINT cannot be replaced when try run image
#ENTRYPOINT [ "echo", "Hello " ]

#Can be replaced, frequently used as parameter to entrypoint
#CMD [ "World" ]

# Native of nginx image
ENTRYPOINT ["/docker-entrypoint.sh"]
# Native of nginx image
CMD ["nginx", "-g", "daemon off;"]

RUN apt-get update && \
    apt-get install vim -y

COPY html/ /usr/share/nginx/html