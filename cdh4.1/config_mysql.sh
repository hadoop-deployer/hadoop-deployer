#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

#预设的Mysql Root密码
MYSQL_ROOT_PASS=root

#待安装节点
#如果不指定，默认是$NODES的前2个
MYSQL_NODES=""

#服务端口前缀
MYSQL_PORT_PREFIX=$PORT_PREFIX


#以下非配置项，不要修改
#---------------------------------
NS=($NODES)
if [ -z "$MYSQL_NODES" ]; then
  MYSQL_NODES=${NS[@]:0:2}
fi
unset NS
#---------------------------------
