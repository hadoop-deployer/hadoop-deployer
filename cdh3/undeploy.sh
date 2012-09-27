#!/usr/bin/env bash
# coding=utf-8
# zhaigy@ucweb.com
# 2012-09

DIR=`cd $(dirname $0);pwd`
. $DIR/PUB.sh
cd $DIR
. $DIR/deploy_env.sh

#==========
# main
#==========
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
cd $OLDDIR
