#!/bin/env bash
DIR=`cd $(dirname $0);pwd`

deploy_java()
{
  echo ">> deploy java"
  mkdir -p $HOME/java
  tar -xzf tar/$JAVA_TAR -C $HOME/java
  tar -xzf tar/$ANT_TAR -C $HOME/java
  tar -xzf tar/$MAVEN_TAR -C $HOME/java
  cd $HOME/java; 
  ln -sf ./$JAVA_VERSION jdk;
  ln -sf ./$ANT_VERSION ant;
  ln -sf ./$MAVEN_VERSION maven;
  cd $DIR;
}

deploy_hadoop()
{
  echo ">> deploy hadoop"
  tar -xzf tar/$HADOOP_TAR -C $HOME
  ln -sf ./$HADOOP_VERSION $HADOOP_HOME
  
  [ "$HADOOP_LZO_TAR" != "" ] && tar -xzf tar/$HADOOP_LZO_TAR -C $HADOOP_HOME ||:;
  
  mkdir -p $PKG_PATH;
  [ "$LZO_TAR" != "" ] && tar -xzf tar/$LZO_TAR -C $PKG_PATH ||:; 
  [ "$FUSE_DFS_TAR" != "" ] && tar -xzf tar/$FUSE_DFS_TAR -C $PKG_PATH ||:;
}

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
  for dn in $DN; do
    echo $dn >> $HADOOP_CONF_DIR/slaves;
  done;

  echo "rsync hadoop configuration";
  myrsyncall "$HADOOP_CONF_DIR $HADOOP_BIN" $HADOOP_HOME/;
}

conf_setup()
{
  ENVSH="$HADOOP_CONF_DIR/hadoop-env.sh"
  CORE="$HADOOP_CONF_DIR/core-site.xml"
  HDFS="$HADOOP_CONF_DIR/hdfs-site.xml"
  MAPRED="$HADOOP_CONF_DIR/mapred-site.xml"

  cp bin/* $HADOOP_BIN;
  cp conf/* $HADOOP_CONF_DIR;

  sed -r "s/9922/$PORT/" -i $HADOOP_BIN/*;

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
  echo $SNN > $HADOOP_CONF_DIR/masters;
  for dn in $DN; do
    echo $dn >> $HADOOP_CONF_DIR/slaves;
  done;

  echo "rsync hadoop configuration";
  myrsyncall "$HADOOP_CONF_DIR $HADOOP_BIN" $HADOOP_HOME/;
}

main()
{
  cd $DIR
  . profile.sh
  . PUB.sh
  . deploy_env.sh
  deploy_java;
  deploy_hadoop;
  cd $OLDDIR
}

#====
main;

