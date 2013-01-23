#!/bin/sh
if [ "$DP_HOME" != "" ]; then
  . $DP_HOME/support/PUB.sh
else
  echo "must install deployer"
  exit 1
fi

for s in $ZK_NODES; do
  echo "start zookeeper at $s"
  echo "--------------------------"
  ssh $USER@$s "
  . ~/.bash_profile;
  cd \$HOME/zookeeper;
  bin/zkServer.sh start;
  "
done
