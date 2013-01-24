#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

OLD_DIR=`pwd`
DIR=$(cd $(dirname $0); pwd)

. $DIR/support/PUB.sh

#==========
cd $D

show_head;

file_die "logs/${AP}_ok_${s}" "mysql is already installed"

check_tool gcc
check_tool make

cpu_cores=`cat /proc/cpuinfo|sed -n "1,20p"| grep "cpu cores"|sed -e "s/cpu cores[ \t]\+\:[ \t]//"`

mkdir -p $HOME/download

cd $HOME/download
wget http://cdn.mysql.com/Downloads/MySQL-5.5/mysql-5.5.29.tar.gz 
tar -xzvf mysql-5.5.29.tar.gz
cd mysql-5.5.29
./configure \
  --prefix=$HOME/local/mysql \
  --without-debug \
  --with-unix-socket-path=$HOME/local/mysql/tmp/mysql.sock \
  --with-client-ldflags=-all-static \
  --with-mysqld-ldflags=-all-static \
  --enable-assembler \
  --with-extra-charsets=latin1,gbk,utf8 \
  --with-pthread \
  --enable-thread-safe-client \
  --with-plugins=partition,heap,innobase,myisam,myisammrg,csv
make -j $cpu_cores
make install

cd $D
touch logs/${AP}_ok

echo ">> OK"
echo ">> !!!Please Run: source ~/.bash_profile"

cd $OLD_DIR
