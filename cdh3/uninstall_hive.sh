#!/bin/env bash
# -- utf-8 --
DIR=`cd $(dirname $0);pwd`
. $DIR/PUB.sh

undeploy()
{
  echo ">> undeploy"
  . $DIR/deploy_env.sh
  # for safe
  if [ "$HIVE_VERSION" != "" ]; then
    echo ">> delete $HIVE_VERSION"
    rm -rf $HOME/$HIVE_VERSION
  fi

  if [ "$HIVE_HOME" != "" ]; then
    echo ">> delete $HIVE_HOME"
    rm -rf $HIVE_HOME
  fi

  if [ "$HOME" != "" -a -e $HOME/.hive_profile ]; then
    echo ">> delete $HOME/.hive_profile"
    rm -f $HOME/.hive_profile
  fi
}

#==========
# main
#==========
cd $DIR
undeploy;
rm -rf logs/hive_ok
echo ">> OK"

