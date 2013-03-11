#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy#ucweb.com
# Q Q: 3 0 4 4 2 8 7 6 8
# Data:   2013-01

OLD_DIR=`pwd`
DIR=$(cd $(dirname $0); pwd)

export DP_HOME=$DIR
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
  ssh $USER@$1 "
    cd $D;
    DP_HOME=$DP_HOME;
    . support/PUB.sh;
    . support/deployer_profile.sh;
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
chmod +x bin/*;

if [ ! -e logs/autossh_ok ]; then
  source ./bin/autossh setup
  touch ./logs/autossh_ok;
fi

for s in ${NODES[*]}; do
  same_to $s $DIR
  [ -f "logs/install_deployer_ok_${s}" ] && continue 
  deploy $s; 
  touch "logs/install_deployer_ok_${s}"
  echo ">>"
done

touch logs/install_deployer_ok

echo ">> OK"
echo ">> !!!Please Run: source ~/.bash_profile"

cd $OLD_DIR
