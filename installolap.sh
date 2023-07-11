#!/bin/bash

echo "update for olap..."
apt-get update
apt-get upgrade
apt-get install openssh-server
apt-get install ufw
ufw allow ssh
apt-get install gnupg
apt-get install curl
cd /home/testuser/
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
   gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
apt-get update
apt-get install -y mongodb-org
systemctl start mongod
systemctl status mongod
systemctl enable mongod
cd /home/testuser/
wget https://info-mongodb-com.s3.amazonaws.com/mongodb-bi/v2/mongodb-bi-linux-x86_64-ubuntu2004-v2.14.6.tgz
tar -xvzf mongodb-bi-linux-x86_64-ubuntu2004-v2.14.6.tgz
cd mongodb-bi-linux-x86_64-ubuntu2004-v2.14.6
install -m755 bin/mongo* /usr/local/bin/
cd /home/testuser/
apt-get install make
apt-get install gcc
wget https://www.openssl.org/source/openssl-1.1.1o.tar.gz
tar -zxvf openssl-1.1.1o.tar.gz
cd openssl-1.1.1o
./config
make
make test
make install
cd /home/testuser/
ln -s /usr/local/lib/libssl.so.1.1  /usr/lib/libssl.so.1.1
ln -s /usr/local/lib/libcrypto.so.1.1 /usr/lib/libcrypto.so.1.1
apt-get install unzip
cd /home/testuser/
curl https://cube.dev/downloads/events-dump.zip > events-dump.zip
unzip events-dump.zip
systemctl restart mongod
mongorestore dump/stats/events.bson

curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
apt install nodejs -y

npx cubejs-cli create real-time-dashboard -d mongobi
cd /home/testuser/real-time-dashboard
echo " " >> .env
echo "CUBEJS_DB_TYPE=mongobi" >> .env
echo "CUBEJS_DB_HOST=127.0.0.1" >> .env
echo "CUBEJS_DB_PORT=3307" >> .env
echo "CUBEJS_DB_NAME=stats" >> .env



