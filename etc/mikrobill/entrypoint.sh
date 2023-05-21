#!/bin/bash
echo 'Mikrobill Container'
touch /var/MikroBILL/DOCKER_MODE
mikrobill_service () {
FILE=/var/MikroBILL/bin
CERT=/var/MikroBILL/cert
UPDATE=/var/MikroBILL/UPDATE_ME

if [ -f "$UPDATE" ]; then
    mikrobill_update
else
    if [ -d "$FILE" ]; then
       echo "Start MikroBILL Service"
       dotnet /var/MikroBILL/bin/MikroBILL.dll /SERVER
    fi
fi
}

mikrobill_install () {
echo "DotNET Core start process MikroBILL silent Installation"
dotnet /home/MikroBILL/MikroBILL.dll /SILENT_INSTALL="{\"web_path\":\"/var/www/web\",\"check_db\":\"0\",\"language\":\"ru\",\"db_ip\":\"mysql\",\"db_port\":\"3306\",\"db_name\":\"${MYSQL_DATABASE}\",\"db_login\":\"root\",\"db_pass\":\"${MYSQL_ROOT_PASSWORD}\",\"admin_login\":\"${ADMIN_LOGIN}\",\"admin_pass\":\"${ADMIN_PASSWORD}\",\"admin_allowed_ip\":\"\",\"lic_accept\":\"1\"}"&> /dev/null
sleep 5 && ln -s /var/MikroBILL/Log.txt /var/log/MikroBILL/Log.txt && mikrobill_web_install
}

mikrobill_update () {
if [ -f "$UPDATE" ]; then
    if grep -q 1 $UPDATE; then
       BUILD="beta"
    else
       BUILD="beta"
    fi
    echo "Mikrobill updating..." && rm -rf /tmp/MikroBILL && mkdir -p /tmp/MikroBILL && wget -O /tmp/MikroBILL/MikroBILL.zip https://mikro-bill.com/downloads/$BUILD && unzip /tmp/MikroBILL/MikroBILL.zip -d /tmp/MikroBILL && dotnet /tmp/MikroBILL/MikroBILL.dll && echo "Mikrobill updated!" && rm -rf /tmp/MikroBILL && chmod -R a+rX /var/www/web/ && rm -rf $UPDATE && ln -s /var/MikroBILL/Log.txt /var/log/MikroBILL/Log.txt && exit && exit
else
    echo "Updated to latest version"
fi

}

mikrobill_web_install () {
FILE=/var/MikroBILL/bin/web/web.ver
if [ -f "$FILE" ]; then
    echo "MikroBILL exist."
    FILE=/var/www/web/web.ver
    if [ -f "$FILE" ]; then
        echo "MikroBILL WEB exist in path /var/www/web"
    else
        echo "COPY MikroBILL WEB to /var/www" && \
        cp -r /var/MikroBILL/bin/web /var/www/web && \
        chmod -R a+rX /var/www/web/ && \
        echo "Instalation MikroBILL Web [success]"
    fi
else
    echo "MikroBILL WEB does not exist."
fi
}

FILE=/var/MikroBILL/MikroBILL.xml
if [ -f "$FILE" ]; then
    echo "$FILE installed."

    FILE=/var/www/web/web.ver
    if [ -f "$FILE" ]; then
        mikrobill_service
    else
        mikrobill_web_install
    fi

else
    echo "$FILE does not installed."
    mikrobill_install
fi

