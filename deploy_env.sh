#!/bin/env echo "Warning: this file should be sourced"
cd $DIR
. PUB.sh
##############################################################################

##### Public #####

HADOOP_PORT_PREFIX=50

##############################################################################

##### tar package #####
# $0 prefix
find_tar()
{
  echo `ls tar/${1}*.tar.gz 2>/dev/null | sed "s:^.*tar/::;q"`
}
find_it()
{
  echo `ls tar/${1} 2>/dev/null | sed "s:^.*tar/::;q"`
}

if IS_32; then
  JAVA_TAR=`find_tar "jdk*i586"`
  [ "$JAVA_TAR" == "" ] && JAVA_TAR=`find_tar "jdk*32"` ||:;
else
  JAVA_TAR=`find_tar "jdk*64"`
fi
JAVA_VERSION=${JAVA_TAR%.tar.gz}

[ "$JAVA_VERSION" == "" ] && die "not find jdk tar file" ||:;

ANT_TAR=`find_tar apache-ant`
ANT_VERSION=${ANT_TAR%.tar.gz}

MAVEN_TAR=`find_tar apache-maven`
MAVEN_VERSION=${MAVEN_TAR%.tar.gz}

if IS_32; then
  LZO_TAR=`find_tar lzo-32` 
else
  LZO_TAR=`find_tar lzo-64`
fi

HADOOP_LZO_TAR=`find_tar hadoop-lzo`

IS_32 && FUSE_DFS_TAR=`find_tar fuse-dfs-32` || FUSE_DFS_TAR=`find_tar fuse-dfs-64`

HADOOP_TAR=`find_tar hadoop*cdh`
[ "$HADOOP_TAR" != "" ] && HADOOP_VERSION=${HADOOP_TAR%.tar.gz} ||:;

HIVE_TAR=`find_tar hive*cdh`
[ "$HIVE_TAR" != "" ] && HIVE_VERSION=${HIVE_TAR%.tar.gz} ||:;

MYSQL_JAR=`find_it "mysql-*.jar"`
if [ "$MYSQL_JAR" == "" ]; then
  MYSQL_TAR=`find_tar "mysql-connector-java-"`
  if [ "$MYSQL_TAR" != "" ]; then
    mkdir tmp
    tar -xzf tar/$MYSQL_TAR -C tmp
    MYSQL_JAR=`find ./tmp -name mysql-connector-java-*-bin.jar`
    if [ "$MYSQL_JAR" != "" ]; then
      cp $MYSQL_JAR tar/
      MYSQL_JAR=`basename $MYSQL_JAR`
    fi
    rm -rf ./tmp
  fi
fi

HUE_TAR=`find_tar hue*cdh`
[ "$HUE_TAR" != "" ] && HUE_VERSION=${HUE_TAR%.tar.gz} ||:;

HBASE_TAR=`find_tar hbase*cdh`
[ "$HBASE_TAR" != "" ] && HBASE_VERSION=${HBASE_TAR%.tar.gz} ||:;

##############################################################################
##### conf file #####

# core-site
HADOOP_TMP_DIR="$HOME/hadoop_data"
FS_DEFAULT_NAME="hdfs://$NN:${HADOOP_PORT_PREFIX}900"

# hdfs-site
DFS_SECONDARY_HTTP_ADDRESS="0.0.0.0:${HADOOP_PORT_PREFIX}090"
#DFS_DATANODE_HANDLER_COUNT="3"
DFS_DATANODE_HANDLER_COUNT=`[ ${#NN} -gt 10 ] && echo 10 || echo ${#NN}`
DFS_HTTP_ADDRESS="$NN:${HADOOP_PORT_PREFIX}070"
#DFS_REPLICATION="2"
DFS_REPLICATION=`[ ${#NN} -gt 8 ] && echo 3 || echo 2`
DFS_NAMENODE_HANDLER_COUNT="10"
DFS_DATANODE_ADDRESS="0.0.0.0:${HADOOP_PORT_PREFIX}010"
DFS_DATANODE_IPC_ADDRESS="0.0.0.0:${HADOOP_PORT_PREFIX}020"
DFS_DATANODE_HTTP_ADDRESS="0.0.0.0:${HADOOP_PORT_PREFIX}075"
DFS_HTTPS_ADDRESS="0.0.0.0:${HADOOP_PORT_PREFIX}470"
DFS_DATANODE_HTTPS_ADDRESS="0.0.0.0:${HADOOP_PORT_PREFIX}475"
DFS_THRIFT_PORT="${HADOOP_PORT_PREFIX}903"
DFS_THRIFT_ADDRESS="0.0.0.0:$DFS_THRIFT_PORT"
DFS_BLOCK_SIZE="134217728"
DFS_BALANCE_BANDWIDTHpERsEC="20000000"

# mapred-site
HADOOP_JOB_HISTORY_LOCATION=""
HADOOP_JOB_HISTORY_USER_LOCATION=""
MAPRED_JOB_TRACKER="$NN:${HADOOP_PORT_PREFIX}901"
MAPRED_MAP_TASKS="2"
MAPRED_REDUCE_TASKS="1"
MAPRED_TASKTRACKER_MAP_TASKS_MAXIMUM="6"
MAPRED_TASKTRACKER_REDUCE_TASKS_MAXIMUM="2"
MAPRED_JOB_TRACKER_HTTP_ADDRESS="0.0.0.0:${HADOOP_PORT_PREFIX}030"
MAPRED_TASK_TRACKER_HTTP_ADDRESS="0.0.0.0:${HADOOP_PORT_PREFIX}060"
JOBTRACKER_THRIFT_PORT="${HADOOP_PORT_PREFIX}904"
JOBTRACKER_THRIFT_ADDRESS="0.0.0.0:$JOBTRACKER_THRIFT_PORT"

# hive-site
HIVE_METASTORE_LOCAL="true"
METASTORE="hive_metastore"
JAVAX_JDO_OPTION_CONNECTIONURL="jdbc:mysql://localhost:3306/$METASTORE?createDatabaseIfNotExist=true"
HIVE_METASTORE_WAREHOUSE_DIR="/warehouse"
MYSQL_USERNAME="root"
MYSQL_PASSWORD="root"
HIVE_EXEC_COMPRESS_INTERMEDIATE="true"
MAPRED_COMPRESS_MAP_OUTPUT="true"
MAPRED_OUTPUT_COMPRESSION_TYPE="BLOCK"
HIVE_INPUT_FORMAT="org.apache.hadoop.hive.ql.io.HiveInputFormat"

# hue.ini
WEBSERVER_HTTP_HOST="0.0.0.0"
WEBSERVER_HTTP_PORT="${HADOOP_PORT_PREFIX}088"
# do not include char "#" in SECRET_KEY
SECRET_KEY="jFE93j;2[290-eiw.KEiwN2s3['d;/.q[eIW^y3e=+Iei*@Mn<qW5o"
HUE_MYSQL_HOST="192.168.22.30"
HUE_MYSQL_PORT="3306"
HUE_MYSQL_USERNAME="root"
HUE_MYSQL_PASSWORD="root"
HUE_DB_NAME="hue_db"
DFS_PORT="${HADOOP_PORT_PREFIX}900"
DFS_HTTP_PORT="${HADOOP_PORT_PREFIX}070"

# hue-beeswax.ini
BEESWAX_META_SERVER_PORT="${HADOOP_PORT_PREFIX}083"
BEESWAX_SERVER_PORT="${HADOOP_PORT_PREFIX}082"

HBASE_ROOTDIR="$FS_DEFAULT_NAME/hbase"
HBASE_TMP_DIR="$HOME/hbase_data"
#HBASE_ZOOKEEPER_QUORUM="platform30,platform31,platform32,platform33,platform34"
quorum()
{
  local tmp=${NODE_HOSTS[@]::5}
  tmp=`echo $tmp`
  tmp=${tmp// /,}
  HBASE_ZOOKEEPER_QUORUM=$tmp
}
quorum

