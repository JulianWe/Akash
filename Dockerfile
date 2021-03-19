FROM ubuntu:bionic

RUN apt-get update && apt-get install -y curl
RUN apt-get update && apt-get install -y nginx
RUN apt-get install npm -y
RUN apt-get install nodejs -y

COPY ./app /var/www/html/

CMD ["nginx", "-g", "daemon off;"]
