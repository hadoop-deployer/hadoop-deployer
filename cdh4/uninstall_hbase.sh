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
    . support/deploy_hbase_env.sh;

    if [ \"\$HBASE_VERSION\" != \"\" ]; then
      echo \">> delete \$HBASE_VERSION\";
      rm -rf $HOME/\$HBASE_VERSION;
    fi;

    echo \">> delete $HOME/hbase\";
    rm -rf $HOME/hbase;

    . support/profile_hbase.sh;
    unprofile;
  "
}

#==========
#main
cd $DIR

show_head;

for s in $HBASE_NODES; do
  same_to $s $DIR
  #[ ! -f "logs/install_hbase_ok_$s" ] && continue
  echo ">> undeploy $s"
  undeploy $s
  rm -f logs/install_hbase_ok_${s}
done

rm -f logs/install_hbase_ok

echo ">> OK"
