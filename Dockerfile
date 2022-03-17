# Build ARGS for base image versions
ARG NODE_BASE=lts-buster-slim
ARG NGINX_BASE=1.21.6-alpine

FROM node:${NODE_BASE} as builder
COPY . /src
#RUN ls -la
WORKDIR /src
#RUN ls -a
RUN npm install \
  && npm run build

FROM nginx:${NGINX_BASE} as prod
LABEL maintainer="marco.blessing@googlemail.com"
HEALTHCHECK  --interval=15s --timeout=5s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1
COPY --from=builder src/public /usr/share/nignx/html/
COPY nginx.conf /etc/nginx/nginx.conf
