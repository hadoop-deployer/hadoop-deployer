#!/bin/env bash
# -- utf-8 --

F1="s/<value"
F2="\/value>/<value"
F3="\/value>/"

conf_hadoop()
{
  echo ">> conf hadoop"
  ENVSH="$HADOOP_CONF_DIR/hadoop-env.sh"
  CORE="$HADOOP_CONF_DIR/core-site.xml"
  HDFS="$HADOOP_CONF_DIR/hdfs-site.xml"
  MAPRED="$HADOOP_CONF_DIR/mapred-site.xml"

  cp hadoopconf/* $HADOOP_CONF_DIR;
  
  sed -r "s#^export HADOOP_SSH_OPTS.*#export HADOOP_SSH_OPTS=\"-p $SSH_PORT\"#" -i $ENVSH;

  # core-site.xml
  sed -r "s#<value>hadoop.tmp.dir<\/value>#<value>$HADOOP_TMP_DIR<\/value>#" -i $CORE;
  sed -r "s#<value>fs.default.name<\/value>#<value>$FS_DEFAULT_NAME<\/value>#" -i $CORE;

  # hdfs-site.xml
  sed -r "$F1>dfs.secondary.http.address<$F2>$DFS_SECONDARY_HTTP_ADDRESS<$F3" -i $HDFS;
  sed -r "$F1>dfs.datanode.handler.count<$F2>$DFS_DATANODE_HANDLER_COUNT<$F3" -i $HDFS;
  sed -r "$F1>dfs.http.address<$F2>$DFS_HTTP_ADDRESS<$F3" -i $HDFS;
  sed -r "$F1>dfs.replication<$F2>$DFS_REPLICATION<$F3" -i $HDFS;
  sed -r "$F1>dfs.namenode.handler.count<$F2>$DFS_NAMENODE_HANDLER_COUNT<$F3" -i $HDFS;
  sed -r "$F1>dfs.datanode.address<$F2>$DFS_DATANODE_ADDRESS<$F3" -i $HDFS;
  sed -r "$F1>dfs.datanode.ipc.address<$F2>$DFS_DATANODE_IPC_ADDRESS<$F3" -i $HDFS;
  sed -r "$F1>dfs.datanode.http.address<$F2>$DFS_DATANODE_HTTP_ADDRESS<$F3" -i $HDFS;
  sed -r "$F1>dfs.https.address<$F2>$DFS_HTTPS_ADDRESS<$F3" -i $HDFS;
  sed -r "$F1>dfs.datanode.https.address<$F2>$DFS_DATANODE_HTTPS_ADDRESS<$F3" -i $HDFS;
  sed -r "$F1>dfs.thrift.address<$F2>$DFS_THRIFT_ADDRESS<$F3" -i $HDFS;
  sed -r "$F1>dfs.block.size<$F2>$DFS_BLOCK_SIZE<$F3" -i $HDFS;
  sed -r "$F1>dfs.balance.bandwidthPerSec<$F2>$DFS_BALANCE_BANDWIDTHpERsEC<$F3" -i $HDFS;

  # mapred-site.xml
  sed -r "$F1>hadoop.job.history.location<$F2>$HADOOP_JOB_HISTORY_LOCATION<$F3" -i $MAPRED;
  sed -r "$F1>hadoop.job.history.user.location<$F2>$HADOOP_JOB_HISTORY_USER_LOCATION<$F3" -i $MAPRED;
  sed -r "$F1>mapred.job.tracker<$F2>$MAPRED_JOB_TRACKER<$F3" -i $MAPRED;
  sed -r "$F1>mapred.map.tasks<$F2>$MAPRED_MAP_TASKS<$F3" -i $MAPRED;
  sed -r "$F1>mapred.reduce.tasks<$F2>$MAPRED_REDUCE_TASKS<$F3" -i $MAPRED;
  sed -r "$F1>mapred.tasktracker.map.tasks.maximum<$F2>$MAPRED_TASKTRACKER_MAP_TASKS_MAXIMUM<$F3" -i $MAPRED;
  sed -r "$F1>mapred.tasktracker.reduce.tasks.maximum<$F2>$MAPRED_TASKTRACKER_REDUCE_TASKS_MAXIMUM<$F3" -i $MAPRED;
  sed -r "$F1>mapred.job.tracker.http.address<$F2>$MAPRED_JOB_TRACKER_HTTP_ADDRESS<$F3" -i $MAPRED;
  sed -r "$F1>mapred.task.tracker.http.address<$F2>$MAPRED_TASK_TRACKER_HTTP_ADDRESS<$F3" -i $MAPRED;
  sed -r "$F1>jobtracker.thrift.address<$F2>$JOBTRACKER_THRIFT_ADDRESS<$F3" -i $MAPRED;

  # masters & slaves
  echo $SNN > $HADOOP_CONF_DIR/masters
  for dn in $DN; do
    echo $dn >> $HADOOP_CONF_DIR/slaves;
  done;

  echo ">> rsync hadoop configuration";
  rsync_all "$HADOOP_CONF_DIR" $HADOOP_HOME/;
}

main() 
{
  DIR=$(cd $(dirname $0); pwd)
  . $DIR/PUB.sh
  cd $DIR

  [ -f logs/hadoop_ok ] && die "hadoop is installed"

  show_head;
  conf_hadoop; 
  touch logs/hadoop_ok
  echo ">> OK"
  cd $OLD_DIR
}

#==========
main $*;

