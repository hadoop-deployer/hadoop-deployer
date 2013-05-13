#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

DIR=`cd $(dirname $0);pwd`

. $DIR/support/PUB.sh
    
undeploy()
{
  # for safe
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/hbase_deploy_env.sh;

    if [ \"\$HBASE_VERSION\" != \"\" ]; then
      echo \">> +-->delete \$HBASE_VERSION\";
      rm -rf $HOME/\$HBASE_VERSION;
    fi;

    echo \">> +-->delete $HOME/hbase\";
    rm -rf $HOME/hbase;

    . support/hbase_profile.sh;
    unprofile;
  "
}

#==========
cd $DIR

show_head;

for s in $HBASE_NODES; do
  [ -f "logs/install_hbase_ok_${s}" ] && continue
  same_to $s $DIR
  echo ">> undeploy $s"
  undeploy $s
  rm -f logs/install_hbase_ok_${s}
  echo ">>"
done

rm -f logs/install_hbase_ok

echo ">> OK"
