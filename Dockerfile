FROM node:lts-alpine

VOLUME /app
WORKDIR /app

RUN npm i -g @adguard/hostlist-compiler

CMD ["hostlist-compiler"]
