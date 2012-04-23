#!/bin/env bash
# -- utf-8 --

main()
{
  . ./PUB.sh
  cd $DIR

  nodes;
  rsync_all $DIR $HOME

  for s in $NODE_HOSTS; do
    echo ">> undeploy $s"
    ssh -p $SSH_PORT $USER@$s sh $DIR/undeploy.sh 
  done

  rm -f logs/hadoop_ok

  ./bin/autossh clean
  rm -f logs/autossh_ok

  echo ">> OK"
}

#====
main
