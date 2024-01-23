# Raito Manga

Raito Manga is an open-source application aimed at simplifying the reading process. Check out our [demonstration](https://raitomanga.app).
This application contains 3 components, including [Raito-Web-Client](https://github.com/nohackjustnoobb/Raito-Web-Client), [Raito-Server](https://github.com/nohackjustnoobb/Raito-Server), and [Raito-Sync](https://github.com/nohackjustnoobb/Raito-Sync).

#### Raito Web Client

This is the front-end of the application, written in Typescript and React. It can be built as static files. Check its repository for more information.

#### Raito Server

This server is used to fetch the manga from different sources. Each source has its own driver that can handle how the data is fetched. The server is written in different languages, and the web client is able to use multiple servers at the same time. Therefore, you can set up your own server but use our sync server and webpage. Check its repository for more information.

#### Raito Sync

This server is used to sync the data between devices. It is written in Golang and uses SQLite to store the data. Check its repository for more information.

## Quick Start

The front-end webpage should be built separately and served by a web server like Nginx. Check the repository for more information.

The servers can be set up easily by using `docker-compose`.

1. Create the configuration file for both servers. The template file of server can be found in the corresponding repository,

2. Create a `docker-compose.yml` file like this:

```yml
version: "3.7"

services:
  raito-sync:
    image: nohackjustnoobb/raito-sync
    container_name: raito-sync
    restart: unless-stopped
    ports:
      - 3080:3000
    volumes:
      - ./db.sqlite3:/app/db.sqlite3
      - ./sync_config.json:/app/config.json:ro

  raito-server:
    # Check https://github.com/nohackjustnoobb/Raito-Server for different images.
    image: nohackjustnoobb/raito-server-cpp
    container_name: raito-server
    restart: unless-stopped
    ports:
      - 3081:8000
    volumes:
      - ./server_config.json:/app/config.json:ro
```

3. Create the container

```bash
sudo docker-compose up -d
```
