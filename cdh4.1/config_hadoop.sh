#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

# Hadoop的众多服务端口的前缀，最多2位数，建议2位数
HADOOP_PORT_PREFIX=$PORT_PREFIX

# Active NN和Standby NN，两个
# 这里及以下设定的所有host值，都必须是在config_deployer中指定的
# 如果不指定，会选择$NODES的前两个
NAME_NODES=""

# 作为DFS数据节点的机器
DATA_NODES=$NODES

# YARN
# 一个，
# 如果不指定，会选择$NODES的第一个
RM="" 

# MRv1
# 不支持MRv1安装

# 用于支持，不是配置项，不要修改
#------------------------------------------------------------------------------
if [ -z "$NAME_NODES" ]; then
  NAME_NODES=${NODES[@]:0:2} 
fi

if [ -z "$RM" ]; then
  RM=${NODES[@]:0:1} 
fi

# 计算实际的Hadoop节点，排除重复
#if [ -z "$HADOOP_NODES" ]; then
#  TMP_F="tmp_uniq_nodes.txt.tmp";
#  :>$TMP_F
#  for s in $DATA_NODES; do
#    echo $s >> $TMP_F;
#  done
#  for s in $NAME_NODES; do
#    echo $s >> $TMP_F;
#  done
#  export HADOOP_NODES=`sort $TMP_F | uniq`
#  rm -f $TMP_F
#  unset TMP_F
#fi
#------------------------------------------------------------------------------

