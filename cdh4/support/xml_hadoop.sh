#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09
DIR=$(cd $(dirname $0); pwd)
# DIR是support目录
. $DIR/PUB.sh
. $DIR/deploy_hadoop_env.sh

conf_hadoop()
{
  echo ">> conf hadoop"

  ENVSH="$HADOOP_CONF_DIR/hadoop-env.sh"
  CORE="$HADOOP_CONF_DIR/core-site.xml"
  HDFS="$HADOOP_CONF_DIR/hdfs-site.xml"

  cp -f hadoop_conf/* $HADOOP_CONF_DIR;
 
  #是别名在脚本中可用
  #sed -r "/# The java implementation to use./i\\shopt -s expand_aliases;" -i $ENVSH;

  # core-site.xml
  xml_set $CORE hadoop.tmp.dir $HADOOP_TMP_DIR
  quorum=""
  for s in $ZK_NODES; do
    if [ $quorum == "" ]; then
      quorum="$s:${ZK_PORT_PREFIX}181"
    else
      quorum="$quorum,$s:${ZK_PORT_PREFIX}181"
    fi
  done
  #quorum=`echo $ZK_NODES|sed "s/ /,/g"` #注意，前面的$ZK..变量不可以加引号"
  xml_set $CORE ha.zookeeper.quorum $quorum

  # hdfs-site.xml
  i=1
  for s in $NAME_NODES; do
    xml_set $HDFS dfs.namenode.rpc-address.zgycluster.nn${i} "$s:${HADOOP_PORT_PREFIX}900"
    xml_set $HDFS dfs.namenode.http-address.zgycluster.nn${i} "$s:${HADOOP_PORT_PREFIX}070"
    xml_set $HDFS dfs.namenode.https-address.zgycluster.nn${i} "$s:${HADOOP_PORT_PREFIX}470"
    let i++
  done
  xml_set $HDFS dfs.datanode.address "0.0.0.0:${HADOOP_PORT_PREFIX}010" 
  xml_set $HDFS dfs.datanode.ipc.address "0.0.0.0:${HADOOP_PORT_PREFIX}020"
  xml_set $HDFS dfs.datanode.http.address "0.0.0.0:${HADOOP_PORT_PREFIX}075"
  xml_set $HDFS dfs.namenode.secondary.http-address "0.0.0.0:${HADOOP_PORT_PREFIX}090"
  
  xml_set $HDFS dfs.ha.zkfc.port "${HADOOP_PORT_PREFIX}819"

  xml_set $HDFS dfs.namenode.shared.edits.dir "file://$HOME/hadoop_ha_edit/nn_edit"
  xml_set $HDFS dfs.ha.fencing.methods "sshfence($USER:$SSH_PORT)"
  xml_set $HDFS dfs.ha.fencing.ssh.private-key-files $HOME/.ssh/id_rsa
  xml_set $HDFS dfs.namenode.name.dir file://$HOME/hadoop_name
  xml_set $HDFS dfs.datanode.data.dir file://$HOME/hadoop_data
  xml_set $HDFS dfs.replication $DFS_REPLICATION
  xml_set $HDFS dfs.cluster.administrators $USER
  xml_set $HDFS dfs.permissions.superusergroup `groups`
  xml_set $HDFS dfs.hosts $HADOOP_CONF_DIR/dfs.include
  xml_set $HDFS dfs.hosts.exclude $HADOOP_CONF_DIR/dfs.exclude
  
  xml_set $HDFS dfs.block.size $DFS_BLOCK_SIZE 
  xml_set $HDFS dfs.balance.bandwidthPerSec $DFS_BALANCE_BANDWIDTHpERsEC

  # masters & slaves
  :>$HADOOP_CONF_DIR/slaves
  for dn in $DATA_NODES; do
    echo $dn >> $HADOOP_CONF_DIR/slaves;
  done;

  mkdir $HOME/hadoop_name
  mkdir $HOME/hadoop_ha_edit
}

main() 
{
  cd $DIR
  conf_hadoop; 
  cd $OLD_DIR
}

#==========
main $*;

