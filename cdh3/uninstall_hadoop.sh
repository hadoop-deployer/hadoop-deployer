#!/bin/env bash
# -- utf-8 --
DIR=`cd $(dirname $0);pwd`
. $DIR/PUB.sh

#==========
# main
#==========
cd $DIR

toDIR=`cd $DIR/..; pwd`
rsync_all $DIR $toDIR

for s in $NODE_HOSTS; do
  echo ">> undeploy $s"
  ssh -p $SSH_PORT $USER@$s "
    sh $DIR/undeploy.sh;
    "
done

rm -f logs/hadoop_ok

echo ">> OK"

