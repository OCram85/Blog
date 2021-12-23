FROM klakegg/hugo:0.91.0-ext-ubuntu as builder
COPY . /src
#RUN ls -la
WORKDIR /src
#RUN ls -a
RUN hugo --gc --minify

FROM caddy:2.4.5-alpine
LABEL maintainer="marco.blessing@googlemail.com"
COPY --from=builder src/public /usr/share/caddy/
HEALTHCHECK  --interval=15s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1
#RUN ls -la /usr/share/caddy/
