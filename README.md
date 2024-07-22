# Raito Manga

Raito Manga is an open-source application aimed at simplifying the reading process. Check out our [demonstration](https://raitomanga.app).
This application contains 3 components, including [Raito-Web-Client](https://github.com/nohackjustnoobb/Raito-Web-Client), [Raito-Server](https://github.com/nohackjustnoobb/Raito-Server), and [Raito-Sync](https://github.com/nohackjustnoobb/Raito-Sync). There is also one optional component, [Raito-Admin-Panel](https://github.com/nohackjustnoobb/Raito-Admin-Panel).

### Raito Web Client

This is the front-end of the application, written in Typescript and React. It can be built as static files. Check its repository for more information.

### Raito Server

This server is used to fetch the manga from different sources. The web client is able to use multiple servers at the same time. Therefore, you can set up your own server but use our sync server and webpage. Check its repository for more information.

### Raito Sync

This server is used to sync the data between devices. It is written in Golang and uses SQLite to store the data. Check its repository for more information.

### Raito Admin Panel

This is the front-end of the admin panel, written in Typescript and Svelte. If you enabled the CMS feature on the server, you need this to access the interface.

## Quick Start

_There is an all-in-one Docker image that includes the front-end and back-end. The all-in-one Docker image will internally start the two backend servers and use Nginx to reverse proxy the incoming requests to the corresponding server. Therefore, the performance can be improved by setting the server separately._

1. Create the configuration based on the `config_template.json`. The minimal configuration is a single file named 'config.json', which can be created with `touch config.json`.

2. Create a `docker-compose.yml` file like this:

```yml
version: "3"

services:
  raito-manga:
    image: nohackjustnoobb/raito-manga
    container_name: raito-manga
    restart: unless-stopped
    ports:
      - 8080:80
    volumes:
      - ./data:/app/data
      - ./config.json:/app/config.json
```

3. Create the container

```bash
sudo docker-compose up -d
```
