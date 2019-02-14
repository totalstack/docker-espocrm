# docker-espocrm
This Dockerfile will create an image with Ubuntu 16.04, Apache, PHP 7.0 and EspoCRM

## Procedure
### 1. Create MySQL Container
To create a mysql container
```
docker run -p 3306:3306 --name=container-name -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7
```

* -p = publish the port "docker-host-port:container-port"
* --name = to assign container name
* -d = run container in background and print container ID

To access MySQL CLI
```
docker exec -ti container-name mysql  -uroot -p
```
* MySQL container should be running

### 2. Build an Image using Dockerfile
To create an image
```
docker build -t image-name:version .
```
* -t = set the image tag name and version.
* . = the location of Dockerfile

### 3. Create a container with the image
To create a container and link mysql container to it
```
docker run -p 80:80 --name=container-name -d --link mysql-container:db dockerfile-image-name:version
```

To access the container interactive mode
```
docker exec -ti container-name /bin/bash
```

To run the container
```
docker start container-name
```

To stop the container
```
docker stop container-name
```
