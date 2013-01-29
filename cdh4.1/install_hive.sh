#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

DIR=$(cd $(dirname $0);pwd)
if [ -z "$DP_HOME" ]; then export DP_HOME=$DIR; fi
. $DIR/support/PUB.sh

# $0 host
deploy()
{
  echo ">> deploy $1";
  ssh $USER@$1 " 
    cd $D;
    . support/PUB.sh;
    . support/hive_deploy_env.sh;
    echo \">> +-->deploy hive\";
    var_die HIVE_TAR
    tar -xzf tars/\$HIVE_TAR -C $HOME;
    ln -sf ./\$HIVE_VERSION \$HOME/hive;
  "

  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/hive_profile.sh;
    profile;
  "

  quorum=`echo $ZK_NODES|sed "s/ /,/g"`;
  quorum_hive="";
  for s in $ZK_NODES; do
    if [ "$quorum_hive" == "" ]; then
      quorum_hive="$s:${ZK_PORT_PREFIX}"
    else
      quorum_hive="$quorum_hive,$s:${ZK_PORT_PREFIX}181"
    fi
  done

  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/hive_deploy_env.sh;

    echo \">> +-->conf hive\";
    cp -f support/hive_conf/* \$HIVE_CONF_DIR;

    HIVE=\"\$HIVE_CONF_DIR/hive-site.xml\";

    xml_set \$HIVE javax.jdo.option.ConnectionURL \"jdbc:mysql://${MYSQL_FIRST_NODE}:${MYSQL_PORT_PREFIX}336/hive_metastore?createDatabaseIfNotExist=true\&amp;useUnicode=true\&amp;characterEncoding=latin1\"
    xml_set \$HIVE hive.zookeeper.quorum $quorum_hive 
    xml_set \$HIVE hive.zookeeper.client.port ${ZK_PORT_PREFIX}181
    xml_set \$HIVE hbase.zookeeper.quorum \"$quorum\"
    xml_set \$HIVE hbase.zookeeper.property.clientPort ${ZK_PORT_PREFIX}181
    xml_set \$HIVE hive.server2.thrift.port ${HIVE_PORT_PREFIX}200
  "
}

# main
#==========
cd $DIR

file_die logs/install_hive_ok "hive is installed"
if [ ! -e logs/install_hadoop_ok ]; then
  ./install_hadoop.sh
  source ~/.bash_profile
fi
notfile_die logs/install_hadoop_ok "must install hadoop first"

show_head;

cd $DP_HOME
same_to $s $DP_HOME

ssh $USER@$MYSQL_FIRST_NODE "
  cd $D;
  . support/PUB.sh;
  if [ ! -f $HOME/local/mysql/data/\${ME}.pid ]; then
    cd $HOME/local/mysql;
    sh start_mysql.sh;
    sleep 10;
    if [ ! -f $HOME/local/mysql/data/\${ME}.pid ]; then
      echo \"mysql is not started!\";
      exit -1;
    fi;
    cd $D;
  fi;
  . support/hive_init_mysql.sh;
"

for s in $HIVE_NODES; do
  same_to $s $DIR
  [ -f "logs/install_hive_ok_${s}" ] && continue 
  deploy $s; 
  touch "logs/install_hive_ok_${s}"
  echo ">>"
done

if hdfs dfs -test -e /warehouse;then
  :;
else
  hdfs dfs -mkdir /warehouse
fi

touch logs/install_hive_ok

echo ">> OK"
echo ">> !!!Please Run: source ~/.bash_profile"
cd $OLD_DIR

