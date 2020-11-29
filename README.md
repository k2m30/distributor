# Deployment instructions
## locally
```psql -U username -d postgres
sudo mate /Users/Mikhail/.ssh/known_hosts
```

## server

``` apt-get -y update

apt-get -y upgrade

apt-get -y install curl git-core g++ mc htop memcached net-tools build-essential
```

# remove apache

```
apt-get --purge remove apache*

```

# change timezone && set locale

```

ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime

echo 'Europe/Minsk' >> /etc/timezone

locale-gen ru_RU.UTF-8

```

# Change locale in ```/etc/default/locale```

```

LANG="ru_RU.UTF-8"

LANGUAGE="ru_RU:en"

LC_NUMERIC="ru_RU.UTF-8"

LC_TIME="ru_RU.UTF-8"

LC_MONETARY="ru_RU.UTF-8"

LC_PAPER="ru_RU.UTF-8"

LC_IDENTIFICATION="ru_RU.UTF-8"

LC_NAME="ru_RU.UTF-8"

LC_ADDRESS="ru_RU.UTF-8"

LC_TELEPHONE="ru_RU.UTF-8"

LC_MEASUREMENT="ru_RU.UTF-8"

```

# Reboot

```reboot```

# nginx

```

add-apt-repository ppa:nginx/stable

apt-get -y update

apt-get -y install nginx

service nginx start

```

# PostgreSQL

```
add-apt-repository ppa:pitti/postgresql

apt-get -y update

apt-get -y install postgresql libpq-dev

sudo -u postgres psql

\password

create user distributor with password '12345678';

create database distributor_production owner distributor;

alter user distributor superuser createrole createdb replication;

\q
```
# Add deployer user

```
adduser deployer --ingroup root
sudo usermod -a -G sudo deployer
adduser deployer sudo
su deployer
cd
```

Open a Terminal window and type:

`sudo visudo`

In the bottom of the file, add the following line:

`$USER ALL=(ALL) NOPASSWD: ALL`



# Ruby with rvm

sudo \curl -sSL https://get.rvm.io | bash -s stable --ruby --rails

source /home/deployer/.rvm/scripts/rvm

gem update bundler

ssh git@github.com

# locally

cat ~/.ssh/id_rsa.pub | ssh deployer@78.47.161.129 'cat >> ~/.ssh/authorized_keys' #cat ~/.ssh/id_rsa.pub | ssh deployer@144.76.161.235 'cat >> ~/.ssh/authorized_keys'

ssh-add -K


* local cap setup

cap deploy:setup

#Server commands

cd

touch ds

sudo mcedit ds

echo 'cd ~/apps/distributor/current' >> ds

sudo chmod +x ds

. ./ds

RAILS_ENV=production rake db:drop

sudo -u postgres psql

UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';

DROP DATABASE template1;

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';

UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';

\c template1

VACUUM FREEZE;

UPDATE pg_database SET datallowconn = FALSE WHERE datname = 'template1';

\q

RAILS_ENV=production rake db:create

RAILS_ENV=production rake db:schema:load

RAILS_ENV=production rake db:migrate

# local cap deploy cold

cap deploy:cold

# Server

sudo rm /etc/nginx/sites-enabled/default

sudo service nginx restart

sudo /usr/sbin/update-rc.d -f unicorn_distributor defaults

* install google chrome

sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

sudo apt-get update

sudo apt-get install google-chrome-stable

* install chromedriver

wget http://chromedriver.storage.googleapis.com/2.7/chromedriver_linux64.zip

unzip chromedriver_linux64.zip

sudo cp chromedriver /usr/local/bin

sudo chmod +x /usr/local/bin/chromedriver

* install xvfb

sudo apt-get install xvfb

* /etc/hosts file

127.0.0.1 www.google-analytics.com

127.0.0.1 vk.com

127.0.0.1 stats.g.doubleclick.net

127.0.0.1 st2.vk.me

127.0.0.1 mc.yandex.ru

127.0.0.1 fbstatic-a.akamaihd.net

127.0.0.1 connect.facebook.net

127.0.0.1 counter.rambler.ru

127.0.0.1 static.facetz.net

127.0.0.1 static.siteheart.com

127.0.0.1 vkontakte.ru

127.0.0.1 widget.siteheart.com
