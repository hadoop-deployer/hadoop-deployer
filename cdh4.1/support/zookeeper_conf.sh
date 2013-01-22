#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

if [ -z "$DP_HOME" ]; then
  echo "deployer is not installed or install fail"
  exit -1
fi
. $DP_HOME/support/PUB.sh

echo ">> --config zookeeper"

ZOO_CFG="$ZK_CONF_DIR/zoo.cfg"

:> $ZOO_CFG;
echo "tickTime=2000" >> $ZOO_CFG;
echo "initLimit=10" >> $ZOO_CFG;
echo "syncLimit=2" >> $ZOO_CFG;
echo "clientPort=${ZK_PORT_PREFIX}181" >> $ZOO_CFG;
echo "dataDir=$HOME/zookeeper/data" >> $ZOO_CFG;
echo "dataLogDir=$HOME/zookeeper/data" >> $ZOO_CFG;
mkdir -p $HOME/zookeeper/data;
mkdir -p $HOME/zookeeper/logs;

i=0;
for s in $ZK_NODES; do
  echo "server.${i}=$s:${ZK_PORT_PREFIX}288:${ZK_PORT_PREFIX}388" >> $ZOO_CFG;
  if [ "$ME" == "$s" ]; then
    echo "$i" > $HOME/zookeeper/data/myid
  fi
  i=$[i+1];
done
unset i
#复制小工具脚本
cp $DP_HOME/support/zookeeper_conf/zk-*-all.sh $HOME/zookeeper/bin/
