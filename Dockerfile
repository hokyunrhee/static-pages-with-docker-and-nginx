FROM node:16-alpine as app1-builder
WORKDIR /app
COPY app1 .
RUN npm install && npm run build

FROM node:16-alpine as app2-builder
WORKDIR /app
COPY app2 .
RUN npm install && npm run build

FROM nginx:alpine
COPY nginx /etc/nginx
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=app1-builder /app/out /usr/share/nginx/html/app1
COPY --from=app2-builder /app/out /usr/share/nginx/html/app2
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]