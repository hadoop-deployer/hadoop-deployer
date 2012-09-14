#!/usr/bin/env bash
# -- utf-8 --
DIR=$(cd $(dirname $0); pwd)
. $DIR/support/PUB.sh

#必要工具的检查
check_tools()
{
  check_tool bash 
  check_tool ssh 
  check_tool scp 
  check_tool expect
}

chmod_for_run()
{
  chmod +x bin/*;
}

#params()
config()
{
  . ./config_deployer.sh
  sed -i "s:DEPLOYER_HOME=.*$:DEPLOYER_HOME=$DIR:" support/profile_deployer.sh
  sed -i "s:SSH_PORT=[0-9]\+:SSH_PORT=$SSH_PORT:" support/profile_deployer.sh
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

[ -e logs ] || mkdir logs
[ -e tars ] || mkdir tars

[ -f logs/install_deployer_ok ] && { cd $OLD_DIR; die "deployer is installed"; }

check_tools;
config;
chmod_for_run;

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

#安装后加载环境
. $HOME/.bash_profile

touch logs/install_deployer_ok

echo ">> OK"
cd $OLD_DIR

