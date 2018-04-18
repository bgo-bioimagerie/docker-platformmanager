# Docker image for Platform-Manager

This image contains everything needed to create an instance of Platform-Manager
using an external mysql database

## Using the Container

We highly recommend using a `docker-compose.yml` to run your containers.

```yaml
version: "2"
services:
  report:
    image: quay.io/bgo_bioimagerie/platformmanager:latest
    environment:
        MYSQL_HOST: mysql # Host of the mysql server
        MYSQL_DBNAME: platformmanager # name of the database on the mysql server
        MYSQL_USER: admin@platformmanager # Admin account to connect to mysql
        MYSQL_PASS: password # Password to connect to mysql
    volumes:
      - ./data/platformmanager:/var/www/platformmanager/data/ # Mount the application data directory
    ports:
      - "3000:80"
```
