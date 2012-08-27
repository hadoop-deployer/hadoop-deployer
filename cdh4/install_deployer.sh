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
  . ./config_deployer.sh
  sed -i "s:DEPLOYER_HOME=.*$:DEPLOYER_HOME=$DIR:" ./deployer_profile.sh
  sed -i "s:SSH_PORT=[0-9]\+:SSH_PORT=$SSH_PORT:" ./deployer_profile.sh
}

# $0 host
deploy()
{
  echo ">> deploy $1";
  #ssh "$USER@$1" sh $DIR/deploy.sh
}

main() 
{
  DIR=$(cd $(dirname $0); pwd)
  . $DIR/PUB.sh
  cd $DIR

  [ -f logs/install_deployer_ok ] && {cd $OLD_DIR; die "deployer is installed"}

  show_head;
  check_tools;
  params;
  chmod_for_run;
  [ -e logs ] || mkdir logs
  [ -e logs/autossh_ok ] || (./bin/autossh setup && touch ./logs/autossh_ok)
  rsync_all $DIR $HOME
  for s in $NODES; do
    [ -f "logs/install_deployer_ok_${s}" ] && continue 
    deploy $s; 
    touch "logs/install_deployer_ok_${s}"
  done
  . $HOME/.bash_profile.sh
  touch logs/install_deployer_ok
  echo ">> OK"
  cd $OLD_DIR
}

#==========
main $*;

