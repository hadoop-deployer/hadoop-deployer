#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

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

main()
{
  DIR=`cd $(dirname $0);pwd`
  . $DIR/PUB.sh
  cd $DIR

  undeploy;
  rm -rf logs/hive_ok
  echo ">> OK"
}
#====
main
