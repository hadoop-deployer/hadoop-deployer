#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

# HBase的众多服务端口的前缀，最多2位数，建议2位数
HBASE_PORT_PREFIX=$PORT_PREFIX

# 这里及以下设定的所有host值，都必须是在config_deployer中指定的
# 如果不指定，默认选第一个节点
MASTER_NODE=""
# 如果不指定，默认选第二个，第三个节点
BACKUP_NODES=""

# 作为Region Server节点的机器
RS_NODES=$NODES

# 用于支持，不是配置项，不要修改
#------------------------------------------------------------------------------
NS=($NODES)
if [ -z "$MASTER_NODE" ]; then
  MASTER_NODE=${NS[@]:0:1} 
fi
if [ -z "BACKUP_NODES" ]; then
  BACKUP_NODES=${NS[@]:1:2}
fi
if [ -z "$MASTER_NODES" ]; then
  MASTER_NODES="$MASTER_NODE $BACKUP_NODES"
fi
unset NS
if [ -z "$HBASE_NODES" ]; then
  TMP_F="tmp_uniq_nodes.txt.tmp";
  :>$TMP_F
  for s in $RS_NODES; do
    echo $s >> $TMP_F;
  done
  for s in $MASTER_NODES; do
    echo $s >> $TMP_F;
  done
  export HBASE_NODES=`sort $TMP_F | uniq`
  rm -f $TMP_F
  unset TMP_F
fi
#------------------------------------------------------------------------------

