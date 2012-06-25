#!/bin/env bash
# -- utf-8 --
DIR=$(cd $(dirname $0); pwd)
. $DIR/PUB.sh

#必要工具的检查和安装,需要root或者sodu,考虑单独脚本
check_tools()
{
  #yum -y install lrzsz gcc gcc-c++ libstdc++-devel
  check_tool ssh 
  check_tool scp 
  check_tool expect
}

# $0 host
deploy()
{
  echo ">> deploy $1";
  . deploy_env.sh
  var_die ZK_HOME; 
  ssh "$USER@$1" cd $HOME \; tar -xzf $DEPLOYER_HOME/tars/$ZK_TAR -C $HOME \; ln -sf ./$ZK_VERSION $ZK_HOME ;
}

profile()
{
  echo ">> profile $1";
  ssh "$USER@$1" cd $DEPLOYER_HOME\; sh ./profile_zookeeper.sh;
}

F1="s/<value"
F2="\/value>/<value"
F3="\/value>/"

config_it()
{
  echo ">> config it ..."
  
  CONF_TMP="./"
  ZOO_CFG_TMP="$CONF_TMP/zoo.cfg"

  :> $ZOO_CFG_TMP;
  echo "itickTime=2000" >> $ZOO_CFG_TMP;
  echo "dataDir=$ZK_HOME/data" >> $ZOO_CFG_TMP;
  echo "clientPort=41181" >> $ZOO_CFG_TMP;
  echo "initLimit=5" >> $ZOO_CFG_TMP;
  echo "syncLimit=2" >> $ZOO_CFG_TMP;
 
  local THIS=`hostname`
  if [ ! -z "$ZK_NODES" ]; then
    local i=0;
    for node in $ZK_NODES; do
      i=$[i+1]
      if [ "$THIS" == "$node" ]; then alias "have_this=true";else alias "have_this=false"; fi
      echo "server.${i}=$node:41288:41388" >> $ZOO_CFG_TMP;
    done
  fi

  echo ">> rsync configuration";
  if [ have_this ]; then cp $ZOO_CFG_TMP $ZK_CONF_DIR/; fi
  rsync_all "$ZOO_CFG_TMP" $ZK_CONF_DIR/;

  [ -e $ZOO_CFG_TMP ] && rm -f $ZOO_CFG_TMP ||:;
  unalias have_this;
}

main() 
{
  [ -f logs/zookeeper_ok ] && die "zookeeper is installed"
  show_head;
  check_tools;
  [ -e logs/autossh_ok ] || (./bin/autossh setup && touch ./logs/autossh_ok)
  download
  rsync_all $DIR $HOME
  for s in $NODE_HOSTS; do
    [ -f "logs/deploy_zookeeper_${s}_ok" ] && continue 
    deploy $s; 
    profile $s; 
    touch "logs/deploy_zookeeper_${s}_ok"
  done
  config_it; 
  touch logs/zookeeper_ok
  echo ">> OK"
}

#=================
main $*;

