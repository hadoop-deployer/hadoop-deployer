#!/usr/bin/env bash
# coding=utf-8
# zhaigy@ucweb.com
# 2012-09

. PUB.sh
[ -f ./install_env.sh ] && : || die "install_env.sh file not exits";
echo ">> install hadoop"
sh install_hadoop.sh
echo ">> install hive"
sh install_hive.sh
echo ">> install hbase"
sh install_hbase.sh
echo ">> install zookeeper"
sh install_zookeeper.sh
echo ">> install hue"
sh install_hue.sh

