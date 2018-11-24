FROM node:alpine as build_stage
WORKDIR /store
COPY . /store
RUN apk -U add python make g++ util-linux && npm i && npm run build

FROM nginx
COPY --from=build_stage /store/public /usr/share/nginx/html
# COPY --from=build_stage /store/nginx.conf /etc/nginx/conf.d/default.conf
