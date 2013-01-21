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
    . support/deploy_hive_env.sh;
    echo \">>deploy hive\";
    var_die HIVE_TAR
    tar -xzf tars/\$HIVE_TAR -C $HOME;
    ln -sf ./\$HIVE_VERSION \$HOME/hive;
  "

  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/profile_hive.sh;
    profile;
  "

  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/deploy_hive_env.sh;

    echo \">> conf hive\";
    cp -f support/hive_conf/* \$HIVE_CONF_DIR;

    HIVESITE=\"\$HIVE_CONF_DIR/hive-site.xml\";
    xml_set \$HIVESITE fs.default.name 'hdfs://zgycluster' 
    xml_set \$HIVESITE mapred.job.tracker \$MAPRED_JOB_TRACKER
    xml_set \$HIVESITE hive.metastore.local \$HIVE_METASTORE_LOCAL
    xml_set \$HIVESITE javax.jdo.option.ConnectionURL \$JAVAX_JDO_OPTION_CONNECTIONURL
    xml_set \$HIVESITE hive.metastore.warehouse.dir \$HIVE_METASTORE_WAREHOUSE_DIR
    xml_set \$HIVESITE javax.jdo.option.ConnectionUserName \$MYSQL_USERNAME
    xml_set \$HIVESITE javax.jdo.option.ConnectionPassword \$MYSQL_PASSWORD
    xml_set \$HIVESITE hive.exec.compress.intermediate \$HIVE_EXEC_COMPRESS_INTERMEDIATE
    xml_set \$HIVESITE mapred.compress.map.output \$MAPRED_COMPRESS_MAP_OUTPUT
    xml_set \$HIVESITE mapred.output.compression.type \$MAPRED_OUTPUT_COMPRESSION_TYPE
    xml_set \$HIVESITE hive.input.format \$HIVE_INPUT_FORMAT

    quorum=\`echo \$ZK_NODES|sed \"s/ /,/g\"\`;
    xml_set \$HIVESITE hbase.zookeeper.quorum \"\$quorum\"
    xml_set \$HIVESITE hbase.zookeeper.property.clientPort \${PORT_PREFIX}181
  "
}

# main
#==========
cd $DIR

show_head;

file_die logs/install_hive_ok "hive is installed"
if [ ! -e logs/install_hadoop_ok ]; then
  ./install_hadoop.sh
fi
notfile_die logs/install_hadoop_ok "must install hadoop first"

s=$HIVE_NODE
same_to $s $DIR
[ -f "logs/install_hive_ok_${s}" ] && continue 
deploy $s; 
touch "logs/install_hive_ok_${s}"

touch logs/install_hive_ok

echo ">> OK"
cd $OLD_DIR

