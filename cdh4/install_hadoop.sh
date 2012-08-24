#!/bin/env bash
# -- utf-8 --

#必要工具的检查
check_tools()
{
  #yum -y install lrzsz gcc gcc-c++ libstdc++-devel
  check_tool bash 
  check_tool ssh 
  check_tool scp 
  check_tool expect
}

chmod_for_run()
{
  chmod +x bin/*;
}

params()
{
  . ./install_env.sh
  sed -i "s:DEPLOYER_HOME=.*$:DEPLOYER_HOME=$DIR:" ./profile.sh
  sed -i "s:SSH_PORT=[0-9]\+:SSH_PORT=$SSH_PORT:" ./profile.sh
  nodes;
}

# $0 host
deploy()
{
  echo ">> deploy $1";
  ssh "$USER@$1" sh $DIR/deploy.sh
}

main() 
{
  DIR=$(cd $(dirname $0); pwd)
  . $DIR/PUB.sh
  cd $DIR

  [ -f logs/hadoop_ok ] && {cd $OLD_DIR; die "hadoop is installed"}

  show_head;
  check_tools;
  params;
  chmod_for_run;
  [ -e logs ] || mkdir logs
  [ -e logs/autossh_ok ] || (./bin/autossh setup && touch ./logs/autossh_ok)
  download
  rsync_all $DIR $HOME
  for s in $NODE_HOSTS; do
    [ -f "logs/deploy_${s}_ok" ] && continue 
    deploy $s; 
    touch "logs/deploy_${s}_ok"
  done
  . $DEPLOYER_HOME/profile.sh
  . $DEPLOYER_HOME/deploy_env.sh
  . config_hadoop.sh; 
  touch logs/hadoop_ok
  echo ">> OK"
  cd $OLD_DIR
}

#==========
main $*;

