FROM node:12.7-alpine as base-build

## BUILD
FROM base-build as build

RUN mkdir /build
COPY babel.config.js /build
COPY config /build/config
#COPY package-lock.json /build
COPY package.json /build
#COPY runtimeconfig.sh /build
COPY src /build/src
COPY vue.config.js /build/vue.config.js

WORKDIR /build

RUN yarn install
RUN yarn run build

## DEPLOY
FROM nginx:alpine as deploy
COPY --from=build /build/dist /usr/share/nginx/html/

EXPOSE 8080
#ADD dist /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY runtimeconfig.sh /

RUN chmod +x /runtimeconfig.sh

CMD [ "/runtimeconfig.sh" ]
