#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy#ucweb.com
# Q Q: 3 0 4 4 2 8 7 6 8
# Data:   2013-01

. $DP_HOME/support/PUB.sh

undeploy()
{
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;

    echo \">> undeploy $1\";
    . support/hive_deploy_env.sh;
    
    rm -rf $HOME/hive;
  
    if [ \"\$HIVE_VERSION\" != \"\" ]; then
      echo \">> +-->delete \$HIVE_VERSION\";
      rm -rf $HOME/\$HIVE_VERSION;
    fi;

    . support/hive_profile.sh;
    unprofile;
  "
}

#============================
cd $DP_HOME

show_head;

for s in $HIVE_NODES; do
  [ ! -f "logs/install_hive_ok_${s}" ] && continue
  same_to $s $D
  undeploy $s; 
  rm -f "logs/install_hive_ok_${s}"
  echo ">>"
done

rm -f logs/install_hive_ok

echo ">> OK"
