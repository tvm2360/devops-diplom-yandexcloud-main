FROM nginx:stable-alpine
EXPOSE 80
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY ./www /usr/share/nginx/html
CMD [ "nginx", "-g", "daemon off;" ]

