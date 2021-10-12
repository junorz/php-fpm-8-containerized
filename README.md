A FastCGI PHP run in container

## Usage
### Build from Dockerfile
#### Build
```
docker build -t php-fpm-8:latest .
```
#### Run
```
docker run -d --name php-fpm php-fpm-8:latest
```
#### Run with Mysql(docker-compose)
```
version: '3'
services:
  mysql:
    image: mysql
    container_name: mysql
    restart: always
    volumes:
      - "./mysql/data:/var/lib/mysql"
      - "./mysql/run:/var/run/mysqld"
    environment:
      MYSQL_ROOT_PASSWORD: 123456

  php-fpm:
    build: ./Dockerfile
    restart: always
    container_name: php-fpm
    depends_on:
      - mysql
    volumes:
      - "./mysql/run:/var/run/mysqld"
```

### Use pre-build image
You can use the pre-build image.
```
docker run -d --name php-fpm junorz/php-fpm-8-containerized:latest
```