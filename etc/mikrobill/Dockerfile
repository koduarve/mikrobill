FROM debian:buster

WORKDIR /home
ARG BRANCH=master

RUN apt-get update && apt-get -y install wget gnupg unzip mc cron bash socat curl procps openssl

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        \
        # .NET dependencies
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        #libicu66 \
        libssl1.1 \
        libstdc++6 \
        zlib1g \
        libssl-dev \
        openssl \
        procps \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get clean

# Install .NET
ENV DOTNET_VERSION=6.0.0

RUN curl -fSL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-x64.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

RUN mkdir -p /home/MikroBILL
RUN wget -O /home/MikroBILL.zip http://mikro-bill.com/downloads/beta
RUN unzip /home/MikroBILL.zip -d /home/MikroBILL && chmod -R a+rX /home/MikroBILL/web && chown -R www-data:www-data /home/MikroBILL/web && rm /home/MikroBILL.zip

WORKDIR /root
RUN wget -O - https://get.acme.sh | sh

