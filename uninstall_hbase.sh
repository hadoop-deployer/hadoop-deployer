#!/bin/env bash
# -- utf-8 --
DIR=`cd $(dirname $0);pwd`
cd $DIR
. PUB.sh
. install_env.sh

[ -f ~/.hbase_profile ] && . ~/.hbase_profile

show_head;

undeploy()
{
  echo ">> undeploy $1"
  echo "DIR=$DIR;" > tmp.sh;
  echo '
  set -e;
  cd $DIR;
  . deploy_env.sh;
  [ -f ~/.bash_profile ] && . ~/.bash_profile;
  if [ "$HOME" != "" -a "$HBASE_VERSION" != "" ]; then
    echo "delete $HBASE_VERSION";
    rm -rf $HOME/$HBASE_VERSION;
  fi;
  if [ "$HBASE_HOME" != "" ]; then
    echo "delete $HBASE_HOME";
    rm -rf $HBASE_HOME;
  fi;
  if [ "$HOME" != "" -a -f $HOME/.hbase_profile ]; then
    echo "delete $HOME/.hbase_profile";
    rm -rf $HOME/.hbase_profile;
  fi
  ' >> tmp.sh;
  if [ "`hostname`" != "$1" ]; then
    scp -q -P $SSH_PORT tmp.sh $USER@$1:/$DIR/
    rm -f tmp.sh
  fi
  ssh -p $SSH_PORT $USER@$1 "sh $DIR/tmp.sh;rm -f $DIR/tmp.sh"
}

for s in $NODE_HOSTS; do
  undeploy $s; 
  rm -f logs/deploy_hbase_${s}_ok
done
rm -f logs/hbase_ok

