#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

DIR=$(cd $(dirname $0);pwd)
. $DIR/support/PUB.sh

# $0 host
deploy()
{
  echo ">> deploy $1";
  ssh $USER@$1 " 
    cd $D;
    . support/PUB.sh;
    . support/hbase_deploy_env.sh;
    echo \">> +-->deploy hbase\";
    tar -xzf tars/\$HBASE_TAR -C $HOME;
    ln -sf ./\$HBASE_VERSION \$HOME/hbase;
  "

  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/hbase_profile.sh;
    profile;
  "

  #配置文件
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/hbase_deploy_env.sh;
    . support/hbase_conf.sh;
  "
}

# main
#==========
cd $DIR

file_die logs/install_hbase_ok "hbase is installed"
if [ ! -e logs/install_hadoop_ok ]; then
  ./install_hadoop.sh
  source ~/.bash_profile
fi
notfile_die logs/install_hadoop_ok "must install hadoop first"

show_head;

for s in $HBASE_NODES; do
  same_to $s $DIR
  [ -f "logs/install_hbase_ok_${s}" ] && continue 
  deploy $s; 
  touch "logs/install_hbase_ok_${s}"
  echo ">>"
done

. $HOME/.bash_profile

touch logs/install_hbase_ok

echo ">> OK"
echo ">> \!\!\!Please Run: source ~/.bash_profile"
cd $OLD_DIR

