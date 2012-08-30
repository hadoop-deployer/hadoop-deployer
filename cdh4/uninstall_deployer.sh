#!/usr/bin/env bash
# -- utf-8 --
DIR=`cd $(dirname $0);pwd`
. $DIR/support/PUB.sh

# $0 host
undeploy()
{
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    if [ \"$ME\" != \"\`hostname\`\" ]; then
      cd ..;
      rm -rf $D;
      #touch "rm.txt";
    fi;
    . support/profile_deployer.sh;
    unprofile;
  "
}

main()
{
  cd $DIR

  show_head;

  for s in $NODES; do
    same_to $s $DIR
    #[ ! -f "logs/install_deployer_ok_$s" ] && continue
    echo ">> undeploy $s"
    undeploy $s
    rm -f "logs/install_deployer_ok_$s"
  done

  rm -f logs/install_deployer_ok

  echo ">> OK"
  cd $OLD_DIR
}

#==========
main
