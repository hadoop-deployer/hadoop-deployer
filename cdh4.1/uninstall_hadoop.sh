#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy#ucweb.com
# Q Q: 3 0 4 4 2 8 7 6 8
# Data:   2013-01

DIR=`cd $(dirname $0);pwd`
. $DIR/support/PUB.sh
    
undeploy()
{
  # for safe
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/hadoop_deploy_env.sh;

    echo \">> +-->delete $HOME/java\";
    rm -rf $HOME/java;
    
    echo \">> +-->delete $HOME/hadoop\";
    rm -rf $HOME/hadoop;

    if [ \"\$HADOOP_VERSION\" != \"\" ]; then
      echo \">> +-->delete \$HADOOP_VERSION\";
      rm -rf $HOME/\$HADOOP_VERSION;
    fi;

    rm -rf $HOME/hadoop_data
    rm -rf $HOME/hadoop_name
    rm -rf $HOME/hadoop_nfs
    rm -rf $HOME/hadoop_temp
    rm -rf $HOME/yarn_nm
    rm -rf $HOME/hadoop_journal

    if [ \"\$PKG_PATH\" != \"\" ]; then
      echo \">> +-->delete \$PKG_PATH\"
      rm -rf \$PKG_PATH
    fi;
    . support/hadoop_profile.sh;
    unprofile;
  "
}

main()
{
  cd $DIR
  
  show_head;

  for s in $NODES; do
    [ ! -f "logs/install_hadoop_ok_${s}" ] && continue
    same_to $s $DIR
    echo ">> undeploy $s"
    undeploy $s
    rm -f logs/install_hadoop_ok_${s}
    echo ">>"
  done

  rm -f logs/install_hadoop_ok

  echo ">> OK"
}

#==========
main
