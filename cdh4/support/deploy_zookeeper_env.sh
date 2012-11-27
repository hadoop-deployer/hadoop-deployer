#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

if [ -z $DEPLOYER_HOME ]; then
  die "deployer is not installed or install fail"
fi
. $DEPLOYER_HOME/support/PUB.sh

##### tar package #####
ZK_TAR=`find_tar "zookeeper.*-cdh4.*"`
ZK_VERSION=${ZK_TAR%.tar.gz}

