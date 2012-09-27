#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

undeploy()
{
  # for safe
  echo ">> delete java"
  rm -rf $HOME/java

  if [ "$HADOOP_VERSION" != "" ]; then
    echo ">> delete $HADOOP_VERSION"
    rm -rf $HOME/$HADOOP_VERSION
  fi

  if [ "$HADOOP_HOME" != "" ]; then
    echo ">> delete $HADOOP_HOME"
    rm -rf $HADOOP_HOME
  fi

  if [ "$PKG_PATH" != "" ]; then
    echo ">> delete $PKG_PATH"
    rm -rf $PKG_PATH
  fi

  if [ "$HOME" != "" ]; then
    echo ">> delete $HOME/.hadoop_profile"
    rm -rf $HOME/.hadoop_profile
  fi

  if [ "$DIR" != "" ]; then
    echo ">> delete $DIR/logs/deploy_*_ok"
    rm -rf $DIR/logs/deploy_*_ok
  fi
}

main()
{
  DIR=`cd $(dirname $0);pwd`
  cd $DIR
  . PUB.sh
  . deploy_env.sh
  undeploy;
  cd $OLDDIR
}

#====
main
