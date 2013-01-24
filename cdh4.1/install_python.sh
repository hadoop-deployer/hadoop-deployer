#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

OLD_DIR=`pwd`
DIR=$(cd $(dirname $0); pwd)

export DP_HOME=$DIR
. $DIR/support/PUB.sh



#必要工具的检查
check_tools()
{
  check_tool bash 
  check_tool ssh 
  check_tool scp 
  check_tool expect
  check_tool rsync
}

#==========
cd $DIR

show_head;
check_tools;

file_die "logs/install_deployer_ok" "deployer is installed"
cpu_cores=`cat /proc/cpuinfo|sed -n "1,20p"| grep "cpu cores"|sed -e "s/cpu cores[ \t]\+\:[ \t]//"`

mkdir $HOME/download
cd $HOME/download
wget http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz
tar -xzvf Python-2.7.3.tgz
cd Python-2.7.3
./configure --prefix=$HOME/local/python
make -j $cpu_cores
make install
cd $D

for s in ${NODES[*]}; do
  [ -f "logs/${AP}_ok_${s}" ] && continue 
  same_to $s $HOME/local/python
  touch "logs/${AP}_ok_${s}"
  echo ">>"
done

touch logs/${AP}_ok

echo ">> OK"
echo ">> !!!Please Run: source ~/.bash_profile"

cd $OLD_DIR
