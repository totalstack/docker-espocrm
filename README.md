# docker-espocrm
Dockerfile will create an image with Ubuntu 16.04, Apache, PHP 7.0 and EspoCRM. 
With Docker Compose yml file it can create 2 volumes and launch 3 containers.

Volumes are:
1. espo-data
2. mysql-data

Containers are;
1. Ubuntu 16.04, Apache, PHP 7.0 and EspoCRM.
2. PHPmyAdmin
3. MySQL 5.7

## Procedures
### 1. Build an Image using Dockerfile
To create an image
```
docker build -t image-name:version .
```
* -t = set the image tag name and version.
* . = the location of Dockerfile

For another ESPOCRM Version
```
docker build --build-arg ESPO_VERSION=5.5.5 -t espocrm:5.5.5 .
```

### 2. Create the containers using docker-compose.yml file
Before running the yml file.
* Create the volume paths on your local machine.
* Check the container names.
* Check the image names and tag names.

Then apply all changes in docker-compose.yml file.

To run the docker-compose.yml file.
```
docker-compose -f docker-compose.yml up -d
```

