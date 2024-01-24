from debian:latest

run apt update -y && apt upgrade -y

volume /app

workdir /app

run apt install npm -y

run npm i -g @adguard/hostlist-compiler

CMD ["hostlist-compiler"]
