#!/usr/bin/env bash
# coding=utf-8
# zhaigy@ucweb.com
# 2012-09

DIR=`cd $(dirname $0);pwd`
. $DIR/PUB.sh

undeploy()
{
  echo ">> undeploy"
  [ -f ~/.hue_profile ] && . ~/.hue_profile
  . $DIR/deploy_env.sh
  # for safe
  if [ "$HUE_VERSION" != "" ]; then
    echo ">> delete $HUE_VERSION"
    rm -rf $HOME/$HUE_VERSION
  fi

  if [ "$HADOOP_HOME" != "" ]; then
    echo ">> delete $HADOOP_HOME/lib/hue-plugins-*.jar"
    rm -f $HADOOP_HOME/lib/hue-plugins-*.jar
  fi

  if [ "$HUE_HOME" != "" ]; then
    echo ">> delete $HUE_HOME"
    rm -rf $HUE_HOME
    rm -f logs/hue_make_ok
  fi

  if [ "$HOME" != "" -a -e $HOME/.hue_profile ]; then
    echo ">> delete $HOME/.hue_profile"
    rm -f $HOME/.hue_profile
  fi
}

#==========
# main
#==========
cd $DIR

undeploy;
rm -f logs/hue_make_ok
rm -f logs/hue_ok
echo ">> OK"

