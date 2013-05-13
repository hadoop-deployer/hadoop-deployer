#!/usr/bin/env bash

# Run this on master node.

bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`

DEFAULT_LIBEXEC_DIR="$bin"/../libexec
HADOOP_LIBEXEC_DIR=${HADOOP_LIBEXEC_DIR:-$DEFAULT_LIBEXEC_DIR}
. $HADOOP_LIBEXEC_DIR/hdfs-config.sh

NAMENODES=$($HADOOP_PREFIX/bin/hdfs getconf -namenodes)

# ZK Failover controllers, if auto-HA is enabled
AUTOHA_ENABLED=$($HADOOP_PREFIX/bin/hdfs getconf -confKey dfs.ha.automatic-failover.enabled)
if [ "$(echo "$AUTOHA_ENABLED" | tr A-Z a-z)" = "true" ]; then
  echo "Starting ZK Failover Controllers on NN hosts [$NAMENODES]"
  "$HADOOP_PREFIX/sbin/hadoop-daemons.sh" \
    --config "$HADOOP_CONF_DIR" \
    --hostnames "$NAMENODES" \
    --script "$bin/hdfs" stop zkfc
fi

# eof
