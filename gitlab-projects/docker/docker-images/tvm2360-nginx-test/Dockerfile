FROM nginx:stable-alpine
EXPOSE 80
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /usr/share/nginx/html/test
COPY ./www /usr/share/nginx/html/test
CMD [ "nginx", "-g", "daemon off;" ]

