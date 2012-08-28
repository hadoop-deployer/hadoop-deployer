#!/bin/env bash
# -- utf-8 --
DIR=`cd $(dirname $0);pwd`
. $DIR/support/PUB.sh

# $0
config()
{
  . config_deployer.sh
}

# $0 host
undeploy()
{
  ssh $USER@$1 "
  cd $D;
  source support/PUB.sh;
  source support/deployer_profile.sh;
  unprofile;
  if [\"$ME\" != \"\`hostname\`\"]; then
    cd ..
    # rm -rf \$D
    touch "rm.txt"
  fi
  "
}

main()
{
  cd $DIR

  show_head;

  config;

  for s in $NODES; do
    rsync_to $s $DIR $DIR/..
    [ ! -f "logs/install_deployer_ok_$s" ] && continue
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
