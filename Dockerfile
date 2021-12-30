FROM node:lts-buster-slim as builder
COPY . /src
#RUN ls -la
WORKDIR /src
#RUN ls -a
RUN npm install \
  && npm run build

FROM caddy:2.4.6-alpine
LABEL maintainer="marco.blessing@googlemail.com"
COPY --from=builder src/public /usr/share/caddy/
HEALTHCHECK  --interval=15s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1
#RUN ls -la /usr/share/caddy/
