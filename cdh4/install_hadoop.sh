#!/usr/bin/env bash
# -- utf-8 --
DIR=$(cd $(dirname $0); pwd)
. $DIR/support/PUB.sh

#必要工具的检查
check_tools()
{
}

config()
{
  . ./config_hadoop.sh
}

# $0 host
deploy()
{
  echo ">> deploy $1";
  # 1. 分发安装
  ssh "$USER@$1" sh $DIR/support/deploy.sh
  # 2. profile文件
  . $DEPLOYER_HOME/profile.sh
  # 3. 配置 xml文件 
  . config_hadoop.sh; 
}

main() 
{
  cd $DIR
  
  show_head;

  [ -f logs/install_hadoop_ok ] && { cd $OLD_DIR; die "hadoop is installed"; }

  check_tools;
  config;
  
  download

  for s in $HADOOP_NODES; do
    same_to $s $DIR
    [ -f "logs/install_hadoop_ok_${s}" ] && continue 
    deploy $s; 
    touch "logs/install_hadoop_ok_${s}"
  done

  . $HOME/.bash_profile

  touch logs/install_hadoop_ok

  echo ">> OK"
  cd $OLD_DIR
}

#==========
main $*;

