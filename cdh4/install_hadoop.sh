#!/usr/bin/env bash
# -- utf-8 --
DIR=$(cd $(dirname $0); pwd)
. $DIR/support/PUB.sh

# $0 host
deploy()
{
  echo ">> deploy $1";
  # 1. 解压安装
  ssh "$USER@$1" sh $DIR/support/deploy_hadoop.sh
  # 2. profile文件
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/profile_hadoop.sh;
    profile;
  "
  # 3. 配置 xml文件 
  ssh $USER@$1 sh $DIR/support/xml_hadoop.sh; 
}

#==========
cd $DIR

show_head;

file_die logs/install_hadoop_ok "hadoop is installed"
notfile_die logs/install_deployer_ok "deployer is not installed"
if [ ! -e logs/install_zookeeper_ok ]; then 
  #先安装zk
  bash install_zookeeper.sh; 
fi

. ./config_hadoop.sh

download

for s in $HADOOP_NODES; do
  same_to $s $DIR
  [ -f "logs/install_hadoop_ok_${s}" ] && continue 
  deploy $s; 
  touch "logs/install_hadoop_ok_${s}"
done

. $HOME/.bash_profile

touch logs/install_hadoop_ok

echo ">> OK"
cd $OLD_DIR

