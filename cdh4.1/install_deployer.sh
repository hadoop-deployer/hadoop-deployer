#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

DIR=$(cd $(dirname $0); pwd)
. $DIR/support/PUB.sh

#必要工具的检查
check_tools()
{
  check_tool bash 
  check_tool ssh 
  check_tool scp 
  check_tool expect
  check_tool rsync
}

# $0 host
deploy()
{
  echo ">> deploy $1";
  # 无实际的安装动作，这里只配置profile文件
  #ssh -p $SSH_PORT $USER@$1 "
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/profile_deployer.sh;
    profile;
  "
}

#==========
cd $DIR

show_head;

mkdir -p logs
mkdir -p tars

file_die "logs/install_deployer_ok" "deployer is installed"

check_tools;
. ./config_deployer.sh
chmod +x bin/*;

if [ ! -e logs/autossh_ok ]; then
  ./bin/autossh setup
  touch ./logs/autossh_ok;
fi

for s in $NODES; do
  same_to $s $DIR
  [ -f "logs/install_deployer_ok_${s}" ] && continue 
  deploy $s; 
  touch "logs/install_deployer_ok_${s}"
done

touch logs/install_deployer_ok

echo ">> OK"

cd $OLD_DIR
