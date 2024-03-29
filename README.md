# Docker image for Platform-Manager

**DEPRECATED** : this repo is deprecated, now also docker stuff is
located in platform-manager repository in *docker* directory

This image contains everything needed to create an instance of Platform-Manager
using an external mysql database

## Building

Specify to docker the build arg BRANCH (defaults to master)

   docker build --build-arg BRANCH=master ...

## Using the Container

We highly recommend using a `docker-compose.yml` to run your containers.

**UPDATE** docker-compose env variables to match your needs or create a .env file

    PFM_WEB_URL=https://url_to_pfm_container_port
    PFM_ADMIN=pfmadmin
    # secrets !!!!!
    # min 8 characters
    MYSQL_ROOT_PASSWORD=xxxxx
    MYSQL_PASSWORD=xxxxxx
    PFM_ADMIN_PASSWORD=admin4genouest
    PFM_ADMIN_EMAIL=admin@pfm.org
    PFM_ADMIN_APIKEY=xxxxxx
    PFM_INFLUXDB_TOKEN=xxxxxx

If you have an external MySQL server, add MYSQL_xx env variables:

```yaml
version: "2"
services:
  report:
    image: quay.io/bgo_bioimagerie/platformmanager:latest
    environment:
        MYSQL_HOST: mysql # Host of the mysql server
        MYSQL_DBNAME: platform_manager # name of the database on the mysql server
        MYSQL_USER: platform_manager # Admin account to connect to mysql
        MYSQL_PASS: platform_manager # Password to connect to mysql
        SMTP_HOST: some.smtp.host # The hostname of an SMTP server to send emails
        MAIL_FROM: support@genouest.org # The sender address for emails sent by platformmanager (should be a real one to avoid being classified as spam)
        .....
    volumes:
      - ./data/platformmanager:/var/www/platformmanager/data/ # Mount the application data directory and backup it
    ports:
      - "3000:80"
```

See [./docker-compose.yml](docker-compose.yml) for another example for development purpose.
