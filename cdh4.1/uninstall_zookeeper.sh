#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy#ucweb.com
# Q Q: 3 0 4 4 2 8 7 6 8
# Data:   2013-01

DIR=`cd $(dirname $0);pwd`
. $DIR/support/PUB.sh

undeploy()
{
  # 1. 应用目录删除
  # 2. profile文件删除
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/zookeeper_deploy_env.sh;
    if [ \"\$ZK_VERSION\" != \"\" ]; then
      echo \">> +-->delete \$ZK_VERSION\";
      rm -rf $HOME/\$ZK_VERSION;
    fi;

    echo \">> +-->delete $HOME/zookeeper\";
    rm -rf $HOME/zookeeper;

    . support/zookeeper_profile.sh;
    unprofile;
  "
}

main()
{
  cd $DIR
  
  show_head;

  for s in $ZK_NODES; do
    [ ! -f "logs/install_zookeeper_ok_$s" ] && continue
    same_to $s $DIR
    echo ">> undeploy $s"
    undeploy $s; 
    rm -f logs/install_zookeeper_ok_${s}
    echo ">>"
  done

  rm -f logs/install_zookeeper_ok

  echo ">> OK"
  cd $OLD_DIR
}

#==========
main
