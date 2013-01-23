# Set Hadoop-specific environment variables here.
shopt -s expand_aliases;
. $HOME/.bash_profile
export JAVA_HOME=$HOME/java/jdk
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/pkg/lzo/lib

#export JAVA_HOME=$HOME/java/jdk

# The jsvc implementation to use. Jsvc is required to run secure datanodes.
#export JSVC_HOME=

export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop"}

# Extra Java CLASSPATH elements. Automatically insert capacity-scheduler.
for f in $HADOOP_HOME/contrib/capacity-scheduler/*.jar; do
  if [ "$HADOOP_CLASSPATH" ]; then
    export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$f
  else
    export HADOOP_CLASSPATH=$f
  fi
done

# The maximum amount of heap to use, in MB. Default is 1000.
export HADOOP_HEAPSIZE=1024
export HADOOP_NAMENODE_INIT_HEAPSIZE=2048

# Extra Java runtime options. Empty by default.
export HADOOP_OPTS="-Djava.net.preferIPv4Stack=true $HADOOP_CLIENT_OPTS"

UC_HADOOP_SERVER="-XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:+CMSClassUnloadingEnabled"
UC_HADOOP_SERVER+=" -Dclient.encoding.override=UTF-8 -Dfile.encoding=UTF-8 -Duser.language=zh -Duser.region=CN"
if [ "$HADOOP_OPTS" == "" ]; then 
  HADOOP_OPTS="-server $UC_HADOOP_SERVER";
else 
  HADOOP_OPTS+=" -server $UC_HADOOP_SERVER";
fi
export HADOOP_OPTS;

# Command specific options appended to HADOOP_OPTS when specified
export HADOOP_NAMENODE_OPTS="-Dhadoop.security.logger=${HADOOP_SECURITY_LOGGER:-INFO,RFAS} -Dhdfs.audit.logger=${HDFS_AUDIT_LOGGER:-INFO,NullAppender} $HADOOP_NAMENODE_OPTS"
export HADOOP_DATANODE_OPTS="-Dhadoop.security.logger=ERROR,RFAS $HADOOP_DATANODE_OPTS"
export HADOOP_SECONDARYNAMENODE_OPTS="-Dhadoop.security.logger=${HADOOP_SECURITY_LOGGER:-INFO,RFAS} -Dhdfs.audit.logger=${HDFS_AUDIT_LOGGER:-INFO,NullAppender} $HADOOP_SECONDARYNAMENODE_OPTS"

# The ZKFC does not need a large heap, and keeping it small avoids
# any potential for long GC pauses
export HADOOP_ZKFC_OPTS="-Xmx256m $HADOOP_ZKFC_OPTS"

# The following applies to multiple commands (fs, dfs, fsck, distcp etc)
export HADOOP_CLIENT_OPTS="-Xmx128m $HADOOP_CLIENT_OPTS"
#HADOOP_JAVA_PLATFORM_OPTS="-XX:-UsePerfData $HADOOP_JAVA_PLATFORM_OPTS"

# On secure datanodes, user to run the datanode as after dropping privileges
export HADOOP_SECURE_DN_USER=

# Where log files are stored. $HADOOP_HOME/logs by default.
export HADOOP_LOG_DIR=$HOME/hadoop/logs/$USER

# Where log files are stored in the secure data environment.
export HADOOP_SECURE_DN_LOG_DIR=$HOME/hadoop/logs/hdfs

# The directory where pid files are stored. /tmp by default.
export HADOOP_PID_DIR=$HOME/hadoop/pids
export HADOOP_SECURE_DN_PID_DIR=$HOME/hadoop/pids

# A string representing this instance of hadoop. $USER by default.
export HADOOP_IDENT_STRING=$USER

export HADOOP_SLAVE_SLEEP=0.1
# export HADOOP_SSH_OPTS="-o ConnectTimeout=1 -o SendEnv=HADOOP_CONF_DIR"
# export HADOOP_SSH_OPTS="-p 22"

