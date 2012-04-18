#!/bin/env bash
# -- utf-8 --
DIR=`cd $(dirname $0);pwd`
cd $DIR
. PUB.sh
. install_env.sh

[ -f ~/.hive_profile ] && . ~/.hive_profile

undeploy()
{
  # for safe
  if [ "$HIVE_VERSION" != "" ]; then
    echo "delete $HIVE_VERSION"
    rm -rf $HOME/$HIVE_VERSION
  fi

  if [ "$HIVE_HOME" != "" ]; then
    echo "delete $HIVE_HOME"
    rm -rf $HIVE_HOME
  fi

  if [ "$HOME" != "" -a -e $HOME/.hive_profile ]; then
    echo "delete $HOME/.hive_profile"
    rm -rf $HOME/.hive_profile
  fi
}

. deploy_env.sh
undeploy;
rm -rf logs/hive_ok

