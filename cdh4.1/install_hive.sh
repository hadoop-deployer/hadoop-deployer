#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

DIR=$(cd $(dirname $0);pwd)
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
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/hive_deploy_env.sh;

    echo \">> +-->conf hive\";
    cp -f support/hive_conf/* \$HIVE_CONF_DIR;

    HIVE=\"\$HIVE_CONF_DIR/hive-site.xml\";

    xml_set \$HIVE fs.default.name 'hdfs://mycluster' 
    xml_set \$HIVE mapred.job.tracker \$MAPRED_JOB_TRACKER
    xml_set \$HIVE hive.metastore.local true
    xml_set \$HIVE javax.jdo.option.ConnectionURL \$JAVAX_JDO_OPTION_CONNECTIONURL
    xml_set \$HIVE hive.metastore.warehouse.dir \$HIVE_METASTORE_WAREHOUSE_DIR
    xml_set \$HIVE javax.jdo.option.ConnectionUserName \$MYSQL_USERNAME
    xml_set \$HIVE javax.jdo.option.ConnectionPassword \$MYSQL_PASSWORD
    xml_set \$HIVE hive.exec.compress.intermediate \$HIVE_EXEC_COMPRESS_INTERMEDIATE
    xml_set \$HIVE mapred.compress.map.output \$MAPRED_COMPRESS_MAP_OUTPUT
    xml_set \$HIVE mapred.output.compression.type \$MAPRED_OUTPUT_COMPRESSION_TYPE
    xml_set \$HIVE hive.input.format \$HIVE_INPUT_FORMAT

    xml_set \$HIVE hbase.zookeeper.quorum \"$quorum\"
    xml_set \$HIVE hbase.zookeeper.property.clientPort \${PORT_PREFIX}181
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

for s in $HIVE_NODES; do
  same_to $s $DIR
  [ -f "logs/install_hive_ok_${s}" ] && continue 
  deploy $s; 
  touch "logs/install_hive_ok_${s}"
  echo ">>"
done

touch logs/install_hive_ok

echo ">> OK"
echo ">> \!\!\!Please Run: source ~/.bash_profile"
cd $OLD_DIR

