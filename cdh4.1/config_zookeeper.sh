#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

# ZooKeeper服务器，新版本会配置成自动切换热备模式，ZK是必须的。
# 本脚本会根据此配置安装ZK
# 如果不配置，会使用$NODES中的最多5个
ZK_NODES=""

# 用于支持，不是配置项，不要修改
#-------------------------------------
if [ -z "$ZK_NODES" ]; then
  if ((${#NODES[@]} <= 5)); then
    ZK_NODES=$NODES
  else
    NS=($NODES)
    ZK_NODES=${NS[@]:0:5}
    unset NS
  fi
fi
#-------------------------------------

