FROM node:10.5.0-stretch

RUN apt-get update && apt-get install -y \
    ghostscript \
    unoconv \
    ffmpeg \
    imagemagick \
    curl

COPY . /home/node/app

RUN cd /home/node/app && npm install 

RUN mkdir /preview

WORKDIR /home/node/app
EXPOSE 3000

CMD node app.js
