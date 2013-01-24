#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

DIR=`cd $(dirname $0);pwd`
. $DIR/support/PUB.sh

# $0 host
undeploy()
{
  ssh $USER@$1 "rm -rf $HOME/local/python"
}

#==========
cd $DP_HOME

show_head;

for s in $NODES; do
  [ ! -f "logs/install_python_ok_$s" ] && continue
  same_to $s $DP_HOME
  echo ">> undeploy $s"
  undeploy $s
  rm -f "logs/install_python_ok_$s"
  echo ">>"
done

rm -f logs/install_python_ok

echo ">> OK"
cd $OLD_DIR
