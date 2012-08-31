#!/usr/bin/env bash
# -- utf-8 --
DIR=$(cd $(dirname $0); pwd)
# DIR 是support目录
. $DIR/PUB.sh

config()
{
  echo ">> config zookeeper"
  
  ZOO_CFG="$ZK_CONF_DIR/zoo.cfg"
  
  :> $ZOO_CFG;
  echo "tickTime=2000" >> $ZOO_CFG;
  echo "initLimit=10" >> $ZOO_CFG;
  echo "syncLimit=2" >> $ZOO_CFG;
  echo "clientPort=${ZK_PORT_PREFIX}181" >> $ZOO_CFG;
  echo "dataDir=$HOME/zookeeper/data" >> $ZOO_CFG;
  echo "dataLogDir=$HOME/zookeeper/logs" >> $ZOO_CFG;
  mkdir -p $HOME/zookeeper/data;
  mkdir -p $HOME/zookeeper/logs;

  local i=0;
  for s in $ZK_NODES; do
    echo "server.${i}=$s:${ZK_PORT_PREFIX}288:${ZK_PORT_PREFIX}388" >> $ZOO_CFG;
    if [ "$ME" == "$s" ]; then
      echo "$i" > $HOME/zookeeper/data/myid
    fi
    i=$[i+1];
  done
  echo ">> config zookeeper ok"
}

main() 
{
  cd $DIR
  config; 
  cd $OLD_DIR
}

#==========
main $*;

