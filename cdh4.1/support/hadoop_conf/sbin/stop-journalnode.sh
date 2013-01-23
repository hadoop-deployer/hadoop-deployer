#!/usr/bin/env bash

# Start hadoop journalnode daemons.
# Run this on master node.

usage="Usage: start-dfs.sh"

bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`

DEFAULT_LIBEXEC_DIR="$bin"/../libexec
HADOOP_LIBEXEC_DIR=${HADOOP_LIBEXEC_DIR:-$DEFAULT_LIBEXEC_DIR}
. $HADOOP_LIBEXEC_DIR/hdfs-config.sh

# namenodes

"$HADOOP_PREFIX/sbin/hadoop-daemons.sh" \
  --config "$HADOOP_CONF_DIR" \
  --script "$bin/hdfs" stop journalnode
  #--hostnames "$NAMENODES" \
