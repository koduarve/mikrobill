<h2 style="color:#FF0000">Auto deployment MikroBILL via docker-compose</h2>

<h3 style="color:#FF0000">MikroBILL is a complete billing platform for Mikrotik routers (RouterOS)</h3>
<b>MikroBILL official web site:</b>
https://mikro-bill.com

This script will work on Debian, Ubuntu, CentOS and probably other distros
of the same families. It will probably work if you simply want to setup a MikroBILL on
your Debian/Ubuntu/CentOS box via docker compose. It has been designed to be as universal as possible.

This is a free shell script under GNU GPL version 3.0 or above
Copyright (C) 2023 MikroBill project.<br />
Feedback/comment/suggestions : dev@koduarve.ee
Author: Timofei Ivastsenko Company: KODUARVE OÜ | [![www.koduarve.ee](https://koduarve.ee/template/koduarve/images/logo.png)](https://koduarve.ee/)


[![screenshots](https://koduarve.ee/mikrobill.png)](https://mikro-bill.com/)

<b>Debian/Ubuntu/CentOS install servers</b>

MikroBILL v2.0.1.10 - BETA

  * This version supports deployment of MikroBILL on Docker.
  * To get started, install the latest version of docker-compose, git, and docker on your server.

You can see it

docker-compose --version

  - Output: Docker Compose version v2.12.2

docker --version

  - Output: Docker version 19.03.15, build 99e3ed8919

Installation:

  * git clone https://github.com/koduarve/mikrobill.git
  * cd mikrobill/
  * - NB! Set passwords in .env and ./etc/proxysql/proxysql.cnf
  * Start command
  * - docker-compose up -d
  
