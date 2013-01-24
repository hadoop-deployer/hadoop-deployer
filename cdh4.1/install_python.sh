#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

OLD_DIR=`pwd`
DIR=$(cd $(dirname $0); pwd)

. $DIR/support/PUB.sh

#==========
cd $DIR

file_die "logs/${AP}_ok" "python is installed"
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
wget http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz
tar -xzvf Python-2.7.3.tgz
cd Python-2.7.3
./configure --prefix=$HOME/local/python
make -j $cpu_cores
make install
source ~/.bash_profile

cd $HOME/download
wget http://peak.telecommunity.com/dist/ez_setup.py
python ez_setup.py
easy_install thrift

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
