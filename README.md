# Docker image for Platform-Manager

This image contains everything needed to create an instance of Platform-Manager
using an external mysql database

## Using the Container

We highly recommend using a `docker-compose.yml` to run your containers.

If you have an external MySQL server:

```yaml
version: "2"
services:
  report:
    image: quay.io/bgo_bioimagerie/platformmanager:latest
    environment:
        MYSQL_HOST: mysql # Host of the mysql server
        MYSQL_DBNAME: platformmanager # name of the database on the mysql server
        MYSQL_USER: platform_manager # Admin account to connect to mysql
        MYSQL_PASS: platform_manager # Password to connect to mysql
        SMTP_HOST: some.smtp.host # The hostname of an SMTP server to send emails
        MAIL_FROM: support@genouest.org # The sender address for emails sent by platformmanager (should be a real one to avoid being classified as spam)
    volumes:
      - ./data/platformmanager:/var/www/platformmanager/data/ # Mount the application data directory and backup it
    ports:
      - "3000:80"
```

If you want to use a dockerized MySQL server:

```yaml
version: "2"
services:
  report:
    image: quay.io/bgo_bioimagerie/platformmanager:latest
    environment:
        MYSQL_HOST: mysql # Host of the mysql server
        MYSQL_DBNAME: platformmanager # name of the database on the mysql server
        MYSQL_USER: platform_manager # Admin account to connect to mysql
        MYSQL_PASS: platform_manager # Password to connect to mysql
        SMTP_HOST: some.smtp.host # The hostname of an SMTP server to send emails
        MAIL_FROM: support@genouest.org # The sender address for emails sent by platformmanager (should be a real one to avoid being classified as spam)
    links:
      - mysql
    volumes:
      - ./data/platformmanager:/var/www/platformmanager/data/ # Mount the application data directory
    ports:
      - "3000:80"

  mysql:
    image: mysql:5.5
    environment:
        MYSQL_DATABASE: platform_manager
        MYSQL_USER: platform_manager
        MYSQL_PASSWORD: platform_manager
        MYSQL_ROOT_PASSWORD: platform_manager
    volumes:
       -./data/mysql_data:/var/lib/mysql # Mount the mysql data directory and backup it
```
