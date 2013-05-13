#!/usr/bin/env bash

# Start hadoop journalnode daemons.
# Run this on master node.

usage="Usage: start-dfs.sh"

bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`

DEFAULT_LIBEXEC_DIR="$bin"/../libexec
HADOOP_LIBEXEC_DIR=${HADOOP_LIBEXEC_DIR:-$DEFAULT_LIBEXEC_DIR}
. $HADOOP_LIBEXEC_DIR/hdfs-config.sh

edits_dir=$(hdfs getconf -confKey dfs.namenode.shared.edits.dir)
#qjournal://platform30:44485;platform31:44485;platform32:44485;platform33:44485;platform34:44485/mycluster
journal_nodes=$(echo ${edits_dir##*://} | sed -e "s:/.*$::" -e "s/:[0-9]\+;\?/ /g")

"$HADOOP_PREFIX/sbin/hadoop-daemons.sh" \
  --config "$HADOOP_CONF_DIR" \
  --hostnames "$journal_nodes" \
  --script "$bin/hdfs" stop journalnode
