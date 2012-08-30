#!/usr/bin/env bash
# -- utf-8 --
DIR=`cd $(dirname $0);pwd`
. $DIR/support/PUB.sh

undeploy()
{
  # 1. 应用目录删除
  # 2. profile文件删除
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/deploy_zookeeper_env.sh;
    if [ \"\$ZK_VERSION\" != \"\" ]; then
      echo \">> delete \$ZK_VERSION\";
      rm -rf $HOME/\$ZK_VERSION;
    fi;

    echo \">> delete $HOME/zookeeper\";
    rm -rf $HOME/zookeeper;

    . support/profile_zookeeper.sh;
    unprofile;
  "
}

main()
{
  cd $DIR
  
  show_head;

  for s in $ZK_NODES; do
    same_to $s $DIR
    #[ ! -f "logs/install_zookeeper_ok_$s" ] && continue
    echo ">> undeploy $s"
    undeploy $s; 
    rm -f logs/install_zookeeper_ok_${s}
  done

  rm -f logs/install_zookeeper_ok

  echo ">> OK"
  cd $OLD_DIR
}

#==========
main
