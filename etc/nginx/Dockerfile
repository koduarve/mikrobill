FROM debian:buster

#RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

RUN apt-get update && apt-get install -y nginx cron socat openssl wget curl procps

RUN rm /etc/nginx/sites-available/default

RUN rm /etc/nginx/sites-enabled/default
ADD app.conf /etc/nginx/sites-available/app.conf
RUN ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/app

RUN mkdir -p /etc/nginx/ssl
RUN  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "/etc/nginx/conf.d/options-ssl-nginx.conf"
RUN  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "/etc/nginx/ssl/ssl-dhparams.pem"

RUN mkdir -p /etc/nginx/ssl/live/mikrobill
RUN openssl req -nodes -newkey rsa:2048 -keyout "/etc/nginx/ssl/live/mikrobill/mikrobill.key" -out "/etc/nginx/ssl/live/mikrobill/mikrobill.csr" -subj "/C=GB/ST=Russia/L=Moscow/O=Global Security/OU=IT Department/CN=localhost"
RUN openssl x509 -req -days 3650 -in "/etc/nginx/ssl/live/mikrobill/mikrobill.csr" -signkey "/etc/nginx/ssl/live/mikrobill/mikrobill.key" -out "/etc/nginx/ssl/live/mikrobill/mikrobill.crt"

ADD letsencrypt-acme-challenge.conf /etc/nginx/conf.d/letsencrypt-acme-challenge.conf

RUN echo "upstream apache { server apache:8080 fail_timeout=0; }" > /etc/nginx/conf.d/upstream.conf

RUN echo '#!/bin/bash' > /bootstrap.sh
RUN echo 'function nginx_stop () { kill $(ps aux | grep "[n]ginx" | awk "{print $2}"); }' >> /bootstrap.sh
RUN echo 'function nginx_sslon () { sed -i "/ssl_/s/#//" /etc/nginx/sites-available/app.conf && sed -i "s|ssl off|ssl on|g" /etc/nginx/sites-available/app.conf && dns="$(openssl x509 -noout -text -in /etc/nginx/ssl/live/mikrobill/mikrobill.crt | grep NS: |sed "s/.*://g")"; sed -i "s/server_name.*/server_name $dns\;/gI" /etc/nginx/sites-available/app.conf; }' >> /bootstrap.sh
RUN echo 'function nginx_ssloff () { sed -i "/ssl_/s/^/#/" /etc/nginx/sites-available/app.conf && sed -i "s|ssl on|ssl off|g" /etc/nginx/sites-available/app.conf && sed -i "s/server_name.*/server_name localhost\;/gI" /etc/nginx/sites-available/app.conf; }' >> /bootstrap.sh
RUN echo 'function nginx_start () { nginx; }' >> /bootstrap.sh
RUN echo 'while true' >> /bootstrap.sh
RUN echo 'do' >> /bootstrap.sh
RUN echo '    if [ -f "/etc/nginx/task/nginx/RESTART" ]; then' >> /bootstrap.sh
RUN echo '         nginx_stop && rm -rf /etc/nginx/task/nginx/RESTART && rm -rf /var/run/nginx.pid' >> /bootstrap.sh
RUN echo '    else' >> /bootstrap.sh
RUN echo '          if [ ! -e /var/run/nginx.pid ]; then' >> /bootstrap.sh
RUN echo '             if grep -q 1 /etc/nginx/task/nginx/USE_HTTPS; then' >> /bootstrap.sh
RUN echo '                echo "SSL ON" && nginx_sslon' >> /bootstrap.sh
RUN echo '             else' >> /bootstrap.sh
RUN echo '                echo "SSL OFF" && nginx_ssloff' >> /bootstrap.sh
RUN echo '             fi' >> /bootstrap.sh
RUN echo '             sleep 2 && nginx_start &' >> /bootstrap.sh
RUN echo '          fi' >> /bootstrap.sh
RUN echo '    fi' >> /bootstrap.sh
RUN echo 'sleep 10' >> /bootstrap.sh
RUN echo 'done' >> /bootstrap.sh
RUN chmod +x /bootstrap.sh
CMD ["bash", "/bootstrap.sh"]

EXPOSE 80
EXPOSE 443