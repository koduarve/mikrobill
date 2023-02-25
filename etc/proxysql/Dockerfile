FROM debian:buster

RUN apt-get update && apt-get install -y wget lsb-release gnupg apt-transport-https ca-certificates && wget -O - 'https://repo.proxysql.com/ProxySQL/repo_pub_key' | apt-key add - && echo deb https://repo.proxysql.com/ProxySQL/proxysql-2.3.x/$(lsb_release -sc)/ ./ | tee /etc/apt/sources.list.d/proxysql.list && apt-get update && apt-get install proxysql && rm -rf /var/lib/apt/lists/*

#RUN apt-get update && apt-get -y install procps
#RUN sysctl -w net.ipv4.ip_nonlocal_bind=1

EXPOSE 6070
EXPOSE 6080
EXPOSE 6032
EXPOSE 6033

ENTRYPOINT ["proxysql", "-f", "--idle-threads", "-D", "/var/lib/proxysql"]
