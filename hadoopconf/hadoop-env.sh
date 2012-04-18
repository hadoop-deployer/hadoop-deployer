# Set Hadoop-specific environment variables here.

JAVA_HOME=$HOME/java/jdk
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/pkg/lzo/lib
export HADOOP_HEAPSIZE=1024

if [ "$HADOOP_OPTS" == "" ]; then export HADOOP_OPTS=-server; else HADOOP_OPTS+=" -server"; fi

#UC_HADOOP_MEM_NN="-Xss128k -Xmn256m -Xms5102m -Xmx5102m"
UC_HADOOP_MEM_NN="-Xss128k -Xmn256m -Xmx2048m"
UC_HADOOP_MEM_JT="-Xss128k -Xmn256m -Xmx2048m"
UC_HADOOP_MEM_DN="-Xss128k -Xmn256m -Xmx1024m"
UC_HADOOP_MEM_TT="-Xss128k -Xmn256m -Xmx1024m"

UC_HADOOP_SERVER="-XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:+CMSClassUnloadingEnabled"
UC_HADOOP_SERVER+=" -Dclient.encoding.override=UTF-8 -Dfile.encoding=UTF-8 -Duser.language=zh -Duser.region=CN"

# Command specific options appended to HADOOP_OPTS when specified
export HADOOP_NAMENODE_OPTS="$UC_HADOOP_SERVER $UC_HADOOP_MEM_NN -Dcom.sun.management.jmxremote $HADOOP_NAMENODE_OPTS"
export HADOOP_SECONDARYNAMENODE_OPTS="$UC_HADOOP_SERVER $UC_HADOOP_MEM_NN -Dcom.sun.management.jmxremote $HADOOP_SECONDARYNAMENODE_OPTS"
export HADOOP_DATANODE_OPTS="$UC_HADOOP_SERVER $UC_HADOOP_MEM_DN -Dcom.sun.management.jmxremote $HADOOP_DATANODE_OPTS"
export HADOOP_BALANCER_OPTS="-Dcom.sun.management.jmxremote $HADOOP_BALANCER_OPTS"
export HADOOP_JOBTRACKER_OPTS="$UC_HADOOP_SERVER $UC_HADOOP_MEM_JT -Dcom.sun.management.jmxremote $HADOOP_JOBTRACKER_OPTS"
export HADOOP_TASKTRACKER_OPTS="$UC_HADOOP_SERVER $UC_HADOOP_MEM_TT -Dcom.sun.management.jmxremote $HADOOP_TASKTRACKER_OPTS"

# export HADOOP_SSH_OPTS="-o ConnectTimeout=1 -o SendEnv=HADOOP_CONF_DIR"

# host:path where hadoop code should be rsync'd from.  Unset by default.
# export HADOOP_MASTER=master:/home/$USER/src/hadoop

export HADOOP_SLAVE_SLEEP=0.1

# The directory where pid files are stored. /tmp by default.
# export HADOOP_PID_DIR=/var/hadoop/pids

