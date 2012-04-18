#!/bin/env bash
# -- utf-8 --
DIR=`cd $(dirname $0);pwd`
cd $DIR
. PUB.sh
. install_env.sh

[ -f ~/.hue_profile ] && . ~/.hue_profile

undeploy()
{
  # for safe
  if [ "$HUE_VERSION" != "" ]; then
    echo "delete $HUE_VERSION"
    rm -rf $HOME/$HUE_VERSION
  fi

  if [ "$HADOOP_HOME" != "" ]; then
    echo "delete $HADOOP_HOME/lib/hue-plugins-*.jar"
    rm -f $HADOOP_HOME/lib/hue-plugins-*.jar
  fi

  if [ "$HUE_HOME" != "" ]; then
    echo "delete $HUE_HOME"
    rm -rf $HUE_HOME
  fi

  if [ "$HOME" != "" -a -e $HOME/.hue_profile ]; then
    echo "delete $HOME/.hue_profile"
    rm -rf $HOME/.hue_profile
  fi
}

. deploy_env.sh
undeploy;
rm -f logs/hue_ok

