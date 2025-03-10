# DOCKER COURSE

## Learned Commands

### Containers

- docker run [image_name]
- docker run -it [image_name] [command_to_use_in_container]
- docker exec -it [container_name] [command_to_use_in_container_that_is_running]
- docker ps
- docker ps -a
- docker rm [container_name,container_id]
- docker rm [container_name,container_id] -f
- docker stop [container_name/container_id/container_alias]
- docker start [container_name/container_id/container_alias]
- docker pull [image_name]
- docker attach [container_name]

### Volumes

- docker run -d --name [some_alias_to_container] -p [local_port]:[internal_container_port] -v [absolute_local_path]:[container_path_to_bind] [image_name]

- docker run -d --name [some_alias_to_container] -p [local_port]:[internal_container_port] --mount type=[type_to_bind],source=[absolute_local_path],target=[container_path_to_bind] [image_name]
    - Ex:
    ```
    docker run -d --name [nginx] -p 8080:80 -v [volume_name]:usr/share/nginx/html nginx
    ```
    ```
    docker run -d --name [nginx] -p 8080:80 --mount type=bind,source=~neto/projects/  docker-course/,target=usr/share/nginx/html nginx
    ```
    ```
    docker run -d --name [nginx] -p 8080:80 --mount type=volume,source=[volume_name],target=usr/share/nginx/html nginx
    ```
- docker volume ls
- docker volume create [volume_name]
- docker volume inspect [volume_name]
- docker volume prune

### Images

- Creating a dockerfile
    ```dockerfile
    FROM nginx:latest

    WORKDIR /app

    RUN apt-get update && \
        apt-get install vim -y

    COPY html/ /usr/share/nginx/html
    ```
    - Creating image from dockerfile
    ```
    docker build -t netosantos122/nginx-with-vim:latest .
    ```

### Entrypoint vs cmd
 - Ex
    ```yaml
        FROM nginx:latest

        WORKDIR /app

        #ENTRYPOINT cannot be replaced when try run image
        ENTRYPOINT [ "echo", "Hello " ]

        #Can be replaced, frequently used as parameter to entrypoint
        CMD [ "World" ]

        RUN apt-get update && \
            apt-get install vim -y

        COPY html/ /usr/share/nginx/html
    ```
    Ex:
    ```sh
      docker build -t netosantos122/nginx-with-vim:latest . 
      docker run --name [alias_container_name] netosantos122/nginx-with-vim [insert_any_value_here_will_replace_the_cmd_in_docker_file]
    ```


**keywords**: *container registry, docker host, client, process, image, container, dockerfile*

### Publishing docker image on dockerhub
- Login
    ```
    docker login | Necessary to publish images
    ```
- Publishing
    ```
    docker push [image_name] | If the image didn´t have download during 90 days, the docker hub will remove it
    ```

### Networks
- Bridge | Enable containers see one each other
- Host | Enable containers into the same host (pc of user) machine network
- Overlay | ???
- Macvlan | ???
- None | Don´t enable communication between containers each container runs on isolated network
- docker network ls
- docker network prune
- docker network [network_name] inspect

    #### Working with Bridge network
    - docker network create --driver [network_type (bridge,host,overlay,macvlan,none)] [network_alias_name]
        - Ex(running 2 container in the same network):
            ```docker
                docker run -d -it --name [container_alias_name1] --network [network_alias_name] [image_name] bash
            ```
            ```docker
                docker run -d -it --name [container_alias_name2] --network [network_alias_name] [image_name] bash
            ```
        - As result becomes possible enter in the container1 and to access container2
            ```docker
                docker exec -it [container_name_1] bash && ping [container_name_2]
            ```
    - If exists a container running on another network and we want change it to other network:
        ```docker
            # This container is running on different network. The connection with container above will not possible
            # We need change the its network 
            docker run -d -it --name [container_alias_name3] [image_name] bash
        ```
        ```docker
            # Changing network of [container_alias_name3] to network [network_alias_name]
            docker network connect [network_alias_name] [container_alias_name3]
        ```
    #### Container accesing the host machine
        
    - in the container, instead of use: curl http://localhost:[port], we must use: http://host.docker.internal:[external_port]

    ### Installing framework Laravel on container
    - Dockerfile configuration
    ```dockerfile
        # Giving alias (builder) to process
        FROM php:7.4-cli as builder

        WORKDIR /var/www

        RUN apt-get update && \
            apt-get install zip -y

        RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
            php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
            php composer-setup.php && \
            php -r "unlink('composer-setup.php');"

        RUN mv composer.phar /usr/local/bin/composer && \
            composer global require laravel/installer

        RUN composer create-project --prefer-dist laravel/laravel laravel


        # Multistaging build
        FROM php:7.4-fpm-alpine

        WORKDIR /var/www

        RUN rm -rf /var/www/html

        # Using the builder process as reference to copy files
        COPY --from=builder /var/www/laravel .
        RUN chown -R www-data:www-data /var/www

        EXPOSE 9000

        ENTRYPOINT [ "php","laravel/artisan","serve" ]
        CMD [ "--host=0.0.0.0" ]
    ```
    
    ```
        docker build -t netosantos122/laravel:latest .
    ```
    ```
        docker run -p 8000:8000 netosantos122/laravel
    ```

    ### Installing Express.js on container

    ```yaml
        FROM node:15

        WORKDIR /usr/src/app

        COPY . /usr/src/app

        #Enable another containers to access this one from port 3000
        EXPOSE 3000 

        RUN npm install

        ENTRYPOINT [ "node","index.js" ]
    ```



## DOCKER-COMPOSE

   ### Docker-compose
   ```yaml
    services:
    laravel:
        # Using build to create a image using the docker file
        build: 
        # Path context
        context: ./php_laravel
        # Dockerfile name in path context
        dockerfile: Dockerfile
        # The imagem name built
        image: netosantos122/phplaravelapp
        container_name: laravel
        networks:
        - mynetwork
        ports:
        - "8000:8000"

    node:
        build: 
        context: ./node
        dockerfile: Dockerfile
        image: netosantos122/nodeapp
        container_name: node
        # volumes:
        #   - "/node:/usr/src/app"
        networks:
        - mynetwork
        ports:
        - "8080:80"

    db:
        build:
        context: ./postgres
        dockerfile: Dockerfile
        image: netosantos122/postgre    
        container_name: database
        restart: always    
        tty: true
        ports:
        - "5432:5432"
        volumes:
        - "/database:/var/lib/postgresql/data"
        networks:
        - mynetwork

    volumes:
    database:
    networks:
    mynetwork:
        driver: "bridge"
   ```
# Continuous Integration
