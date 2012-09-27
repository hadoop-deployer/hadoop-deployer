#!/usr/bin/env bash
# coding=utf-8
# zhaigy@ucweb.com
# 2012-09

. PUB.sh
[ -f ./install_env.sh ] && : || die "install_env.sh file not exits";
echo ">> uninstall zookeeper"
sh uninstall_zookeeper.sh
echo ">> uninstall hue"
sh uninstall_hue.sh
echo ">> uninstall hbase"
sh uninstall_hbase.sh
echo ">> uninstall hive"
sh uninstall_hive.sh
echo ">> uninstall hadoop"
sh uninstall_hadoop.sh

