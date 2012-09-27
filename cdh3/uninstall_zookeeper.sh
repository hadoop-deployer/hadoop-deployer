#!/bin/env bash
# -- utf-8 --
DIR=`cd $(dirname $0);pwd`
. $DIR/PUB.sh

undeploy()
{
  echo ">> undeploy $1"
  echo "DIR=$DIR;" > tmp.sh;
  echo '
  #set -e;
  cd $DIR;
  . deploy_env.sh;
  [ -f ~/.bash_profile ] && . ~/.bash_profile;
  if [ "$HOME" != "" -a "$ZK_VERSION" != "" ]; then
    echo ">> delete $ZK_VERSION";
    rm -rf $HOME/$ZK_VERSION;
  fi;
  if [ "$ZK_HOME" != "" ]; then
    echo ">> delete $ZK_HOME";
    rm -rf $ZK_HOME;
  fi;
  if [ "$HOME" != "" -a -f $HOME/.zookeeper_profile ]; then
    echo ">> delete $HOME/.zookeeper_profile";
    rm -rf $HOME/.zookeeper_profile;
  fi
  ' >> tmp.sh;
  if [ "`hostname`" != "$1" ]; then
    scp -q -P $SSH_PORT tmp.sh $USER@$1:/$DIR/
    rm -f tmp.sh
  fi
  ssh -p $SSH_PORT $USER@$1 "sh $DIR/tmp.sh;rm -f $DIR/tmp.sh"
}

#==========
# main
#==========
cd $DIR

toDIR=`cd $DIR/..; pwd`
rsync_all $DIR $toDIR

for s in $ZK_NODES; do
  undeploy $s; 
  rm -f logs/deploy_zookeeper_${s}_ok
done
rm -f logs/zookeeper_ok

cd $OLD_DIR
