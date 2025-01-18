# docker-course

## Learned Commands

* docker run [image_name]
* docker run -it [image_name] [command_to_use_in_container]
* docker exec -it [image_name] [command_to_use_in_container_that_is_running]
* docker ps
* docker ps -a
* docker rm [container_name,container_id]
* docker rm [container_name,container_id] -f
* docker stop [container_name/container_id/container_alias]
* docker start [container_name/container_id/container_alias]
* docker pull [image_name]
* docker run -d --name [some_alias_to_container] -p [local_port]:[internal_container_port] -v [absolute_local_path]:[container_path_to_bind] [image_name]
* docker run -d --name [some_alias_to_container] -p [local_port]:[internal_container_port] --mount type=[type_to_bind],source=[absolute_local_path],target=[container_path_to_bind] [image_name]
