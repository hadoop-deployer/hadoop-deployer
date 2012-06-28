#!/bin/env bash
# -- utf-8 --

main()
{
  DIR=`cd $(dirname $0);pwd`
  . $DIR/PUB.sh
  cd $DIR

  rsync_all $DIR $HOME

  for s in $NODE_HOSTS; do
    echo ">> undeploy $s"
    ssh -p $SSH_PORT $USER@$s sh $DIR/undeploy.sh 
  done

  rm -f logs/hadoop_ok

  echo ">> OK"
}

#==========
main
