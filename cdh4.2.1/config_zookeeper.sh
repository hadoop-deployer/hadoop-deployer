#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

#
ZK_PORT_PREFIX=$PORT_PREFIX
# ZooKeeper服务器，新版本会配置成自动切换热备模式，ZK是必须的。
# 本脚本会根据此配置安装ZK
# 如果不配置，会使用$NODES中的最多5个
ZK_NODES=""

# 用于支持，不是配置项，不要修改
#-------------------------------------
if [ -z "$ZK_NODES" ]; then
  NS=($NODES)
  if ((${#NS[@]} <= 5)); then
    ZK_NODES=$NODES
  else
    ZK_NODES=${NS[@]:0:5}
  fi
  unset NS
fi
#-------------------------------------

