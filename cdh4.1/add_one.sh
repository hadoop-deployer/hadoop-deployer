HOST=$1
if [ "$HOST" == "" ]; then
  echo "ERROR!"
  exit 1
fi
myscp hadoop-deployer $HOST
#myscp zookeeper-3.4.3-cdh4.1.1 $HOST
ssh -p 9922 $HOST "cd $HOME; ln -sf zookeeper-3.4.3-cdh4.1.1 zookeeper"
#myscp hadoop-2.0.0-cdh4.1.1 $HOST
ssh -p 9922 $HOST "cd $HOME; ln -sf hadoop-2.0.0-cdh4.1.1 hadoop"
ssh -p 9922 $HOST "mkdir -p $HOME/hadoop_tmp"
ssh -p 9922 $HOST "mkdir -p $HOME/hadoop_name/name"
#myscp hbase-0.92.1-cdh4.1.1 $HOST
ssh -p 9922 $HOST "cd $HOME; ln -sf hbase-0.92.1-cdh4.1.1 hbase"
#myscp hive-0.9.0-cdh4.1.1 $HOST
ssh -p 9922 $HOST "cd $HOME; ln -sf hive-0.9.0-cdh4.1.1 hive"
ssh -p 9922 $HOST "mkdir -p $HOME/hadoop_journal/edits"
#myscp java $HOST
#myscp pkg $HOST
ssh -p 9922 $HOST "mkdir -p $HOME/yarn_nm"
#cd local; myscp local/python $HOST; cd ..
ssh -p 9922 $HOST "cd $HOME; mkdir -p local; mv python local/"
#myscp .bash_profile $HOST
#myscp .deployer_profile $HOST
#myscp .zookeeper_profile $HOST
#myscp .hadoop_profile $HOST
#myscp .hive_profile $HOST
#myscp .hbase_profile $HOST
