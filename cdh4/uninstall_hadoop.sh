#!/bin/env bash
# -- utf-8 --
DIR=`cd $(dirname $0);pwd`
. $DIR/support/PUB.sh
    
#ssh -p $SSH_PORT $USER@$s sh $DIR/undeploy.sh 
undeploy()
{
  # for safe
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/deploy_hadoop_env.sh;

    echo \">> delete java\";
    rm -rf $HOME/java;

    if [ \"\$HADOOP_VERSION\" != \"\" ]; then
      echo \">> delete \$HADOOP_VERSION\";
      rm -rf $HOME/\$HADOOP_VERSION;
    fi;

    echo \">> delete $HOME/hadoop\";
    rm -rf $HOME/hadoop;

    if [ \"\$PKG_PATH\" != \"\" ]; then
      echo \">> delete \$PKG_PATH\"
      rm -rf \$PKG_PATH
    fi;
    . support/profile_hadoop.sh;
    unprofile;
  "
}

main()
{
  cd $DIR
  
  show_head;

  for s in $HADOOP_NODES; do
    same_to $s $DIR
    #[ ! -f "logs/install_hadoop_ok_$s" ] && continue
    echo ">> undeploy $s"
    undeploy $s
    rm -f logs/install_hadoop_ok_${s}
  done

  rm -f logs/install_hadoop_ok

  echo ">> OK"
}

#==========
main
