#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy#ucweb.com
# Q Q: 3 0 4 4 2 8 7 6 8
# Data:   2013-01

OLD_DIR=`pwd`
DIR=$(cd $(dirname $0); pwd)
if [ -z "$DP_HOME" ]; then export DP_HOME=$DIR; fi
. $DIR/support/PUB.sh

#==========
cd $DP_HOME

file_die "logs/${AP}_ok" "mysql is already installed"
if [ ! -e logs/install_deployer_ok ]; then
  ./install_deployer.sh
  source ~/.bash_profile
fi
notfile_die logs/install_deployer_ok "need pre install deployer"

show_head;

check_tool gcc
check_tool make

cpu_cores=`cat /proc/cpuinfo|sed -n "1,20p"| grep "cpu cores"|sed -e "s/cpu cores[ \t]\+\:[ \t]//"`

mkdir -p $HOME/download

cd $HOME/download
wget --no-check-certificate -c http://cdn.mysql.com/Downloads/MySQL-5.5/mysql-5.5.29.tar.gz 
tar -xzvf mysql-5.5.29.tar.gz
cd mysql-5.5.29

MYSQL_HOME=$HOME/local/mysql
cmake \
  -DCMAKE_INSTALL_PREFIX=$MYSQL_HOME \
  -DMYSQL_UNIX_ADDR=$MYSQL_HOME/tmp/mysql.sock \
  -DDEFAULT_CHARSET=utf8 \
  -DDEFAULT_COLLATION=utf8_general_ci \
  -DWITH_EXTRA_CHARSETS=all \
  -DWITH_MYISAM_STORAGE_ENGINE=1 \
  -DWITH_INNOBASE_STORAGE_ENGINE=1 \
  -DWITH_MEMORY_STORAGE_ENGINE=1 \
  -DWITH_READLINE=1 \
  -DENABLED_LOCAL_INFILE=1 \
  -DMYSQL_DATADIR=$MYSQL_HOME/data \
  -DMYSQL_USER=$USER

make -j $cpu_cores
make install

source ~/.bash_profile

cd $MYSQL_HOME

#config
cp $DP_HOME/support/mysql_conf/my.cnf ./
sed -i "s:/home/mysql/:$HOME/:g" ./my.cnf
sed -i "s:port[ \t]*=.*:port=${MYSQL_PORT_PREFIX}336:" ./my.cnf
mkdir -p ./log
echo "./bin/mysqld_safe --defaults-file=my.cnf &" > start_mysql.sh
echo "./bin/mysqladmin --defaults-file=my.cnf -u root shutdown" > stop_mysql.sh

#init
./scripts/mysql_install_db --defaults-file=$MYSQL_HOME/my.cnf --force
sh start_mysql.sh
sleep 15
./bin/mysqladmin -h 127.0.0.1 -P ${MYSQL_PORT_PREFIX}336 -u root password "$MYSQL_ROOT_PASS"
#./bin/mysqladmin -h localhost -P ${MYSQL_PORT_PREFIX}336 -u root password "$MYSQL_ROOT_PASS" ||:;
./bin/mysqladmin -h $ME -P ${MYSQL_PORT_PREFIX}336 -u root password "$MYSQL_ROOT_PASS" ||:;
echo "./bin/mysqladmin --defaults-file=my.cnf -u root -p${MYSQL_ROOT_PASS} shutdown" > stop_mysql.sh
sh stop_mysql.sh
echo "./bin/mysql -defaults-file=my.cnf -u root -p${MYSQL_ROOT_PASS}" > mysql_client.sh

cd $DP_HOME
has_ME="0"
for s in $MYSQL_NODES; do
  [ -f "logs/${AP}_ok_${s}" ] && continue 
  echo "deploy $s"
  if [ "$ME" == "$s" ]; then has_ME="1"; fi
  same_to $s $HOME/local/mysql
  touch "logs/${AP}_ok_${s}"
  echo ">>"
done
if [ "$has_ME" == "0" ]; then
  rm -rf $MYSQL_HOME;
fi
touch logs/${AP}_ok

echo ">> OK"
echo ">> !!!Please Run: source ~/.bash_profile"

cd $OLD_DIR
