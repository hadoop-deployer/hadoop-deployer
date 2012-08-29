#!/usr/bin/env bash
# -- utf-8 --
DIR=$(cd $(dirname $0); pwd)
. $DIR/support/PUB.sh

conf_hadoop()
{
  echo ">> conf hadoop"

  ENVSH="$HADOOP_CONF_DIR/hadoop-env.sh"
  CORE="$HADOOP_CONF_DIR/core-site.xml"
  HDFS="$HADOOP_CONF_DIR/hdfs-site.xml"

  cp -f support/hadoop_conf/* $HADOOP_CONF_DIR;
  
  sed -r "/^# The java implementation to use\./i\\shopt -s expand_aliases" -i $ENVSH;

  # core-site.xml
  xml_set $CORE hadoop.tmp.dir $HADOOP_TMP_DIR
  #ha zk sed -r "/<name>hadoop.tmp.dir<\/name>/{ n; s/<value>.*<\/value>/<value>$HADOOP_TMP_DIR<\/value>/; }" -i $CORE;

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

  xml_set $HDFS dfs.namenode.shared.edits.dir "file://$HOME/hadoop_edit/nn_edit"
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
  for dn in $DATA_NODES; do
    echo $dn >> $HADOOP_CONF_DIR/slaves;
  done;

  echo ">> rsync hadoop configuration";
  #rsync_all "$HADOOP_CONF_DIR" $HADOOP_HOME/;
}

main() 
{
  cd $DIR
  conf_hadoop; 
  cd $OLD_DIR
}

#==========
main $*;

