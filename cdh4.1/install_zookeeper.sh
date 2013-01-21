#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

DIR=$(cd $(dirname $0); pwd)
. $DIR/support/PUB.sh

# $0 host
deploy()
{
  echo ">> deploy $1";
  ZK_TAR=`find_tar "zookeeper.*-cdh4.*"`
  ZK_VERSION=${ZK_TAR%.tar.gz}
  
  # 1. 分发安装
  ssh "$USER@$1" "
    cd $D;
    . support/PUB.sh;
    tar -xzf tars/$ZK_TAR -C $HOME;
    ln -sf ./$ZK_VERSION $HOME/zookeeper;
  "

  # 2. profile文件
  ssh $USER@$1 "
    cd $D;
    . support/zookeeper_profile.sh;
    . support/PUB.sh;
  "
  
  # 3. 配置文件 
  #ssh $USER@$1 sh $DIR/support/xml_zookeeper.sh; 

  ssh $USER@$1 "
    cd $D; 
    . support/PUB.sh;
    ZOO_CFG=\"\$ZK_CONF_DIR/zoo.cfg\";
  
    :>\$ZOO_CFG;
    echo \"tickTime=2000\" >> \$ZOO_CFG;
    echo \"initLimit=10\" >> \$ZOO_CFG;
    echo \"syncLimit=2\" >> \$ZOO_CFG;
    echo \"clientPort=${PORT_PREFIX}181\" >> \$ZOO_CFG;
    echo \"dataDir=$ZK_HOME/data\" >> \$ZOO_CFG;
    echo \"dataLogDir=$ZK_HOME/data\" >> \$ZOO_CFG;
    mkdir -p $ZK_HOME/data;
    mkdir -p $ZK_HOME/logs;

    local i=0;
    for s in \$ZK_NODES; do
      echo \"server.\${i}=\$s:${PORT_PREFIX}288:${PORT_PREFIX}388\" >> \$ZOO_CFG;
      if [ \"\$ME\" == \"\$s\" ]; then
        echo \"\$i\" > $ZK_HOME/data/myid
      fi
      i=\$[i+1];
    done;
    #复制小工具脚本
    cp support/zookeeper_conf/*.sh $ZK_HOME/bin/
    echo \">> config zookeeper ok\"
  "
}

#------------------
# main
#------------------
cd $DIR

show_head;

file_die logs/install_zookeeper_ok "zookeeper is installed"
if [ ! -e logs/install_deployer_ok ]; then
  ./install_deployer.sh
fi
notfile_die logs/install_deployer_ok "deployer is not installed"

. ./config_zookeeper.sh

for s in $ZK_NODES; do
  same_to $s $DIR
  [ -f "logs/install_zookeeper_ok_${s}" ] && continue 
  deploy $s; 
  touch "logs/install_zookeeper_ok_${s}"
done

touch logs/install_zookeeper_ok
echo ">> OK"
cd $OLD_DIR
