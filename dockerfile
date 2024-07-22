FROM python:3.9-bookworm as api

WORKDIR /app
COPY ./Raito-Server/conanfile.py ./Raito-Server/CMakeLists.txt ./

RUN pip install conan
RUN apt-get update && apt-get install -y --no-install-recommends cmake

RUN conan profile detect
RUN conan install . --output-folder=build --build=missing

COPY ./Raito-Server/src src/
RUN cd /app/build && cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release && make

FROM golang:1-bookworm as sync

WORKDIR /app

COPY ./Raito-Sync/ .
RUN go mod download

RUN GOAMD64=v3 CGO_ENABLED=1 go build .

FROM node:16 as web

WORKDIR /app

COPY ./Raito-Web-Client/ .
RUN yarn install

ENV SYNC_ADDRESS=/sync/ DEFAULT_SOURCE_ADDRESS=/api/
RUN yarn run build

FROM nginx:stable-bookworm
COPY default.conf /etc/nginx/conf.d/default.conf

COPY --from=api /app/build/Raito-Server /app/api/build/Raito-Server
RUN cd /app/api/build && chmod +x Raito-Server

COPY --from=sync /app/Raito-Sync /app/sync/Raito-Sync
RUN cd /app/sync && chmod +x Raito-Sync

COPY --from=web /app/build /usr/share/nginx/html

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates python3

WORKDIR /app
COPY ./setup.py ./start.sh ./
RUN chmod +x ./start.sh

CMD [ "/app/start.sh" ]
