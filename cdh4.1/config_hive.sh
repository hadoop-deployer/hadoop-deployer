#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy#ucweb.com
# Q Q: 3 0 4 4 2 8 7 6 8
# Data:   2013-01

# HBase的众多服务端口的前缀，最多2位数，建议2位数
HIVE_PORT_PREFIX=$PORT_PREFIX

# 把Hive安装到指定机器上
# 如果不配置，安装$NODES中的前3台
HIVE_NODES=""

# 非配置文件，不要修改
# -------------------------
if [ -z "$HIVE_NODES" ]; then
  NS=($NODES)
  if ((${#NS[*]}<=3)); then
    HIVE_NODES=$NODES
  else
    HIVE_NODES=${NS[@]:0:3}
  fi
  unset NS
fi
# -------------------------

