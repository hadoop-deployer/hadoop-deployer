#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

# HBase的众多服务端口的前缀，最多2位数，建议2位数
HIVE_PORT_PREFIX=$PORT_PREFIX

# 把Hive安装到指定机器上
# 如果不配置，安装$NODES中的前3台
HIVE_NODES=""

# 非配置文件，不要修改
# -------------------------
if [ -z "$HIVE_NODES" ]; then
  N=3
  len=${#NODES[*]}
  if ((len <= N)); then
    HIVE_NODES=$NODES
  else
    NS=($NODES)
    HIVE_NODES=${NS[@]:0:$N}
    unset NS
  fi
fi
# -------------------------

