#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

DIR=$(cd $(dirname $0);pwd)
. $DIR/support/PUB.sh

# $0 host
deploy()
{
  echo ">> deploy $1";
  ssh $USER@$1 " 
    cd $D;
    . support/PUB.sh;
    . support/deploy_hbase_env.sh;
    echo \">>deploy hbase\";
    tar -xzf tars/\$HBASE_TAR -C $HOME;
    ln -sf ./\$HBASE_VERSION \$HOME/hbase;
  "

  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/profile_hbase.sh;
    profile;
  "

  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/deploy_hbase_env.sh;

    echo \">> conf hbase\";
    cp -f support/hbase_conf/* \$HBASE_CONF_DIR;

    HBASE=\"\$HBASE_CONF_DIR/hbase-site.xml\";
    REGIONSERVERS=\"\$HBASE_CONF_DIR/regionservers\";
    BACKUP_MASTERS=\"\$HBASE_CONF_DIR/backup-masters\";

    xml_set \$HBASE hbase.tmp.dir \$HOME/hbase_temp
    xml_set \$HBASE hbase.master.port \$HBASE_MASTER_PORT
    xml_set \$HBASE hbase.master.info.port \$HBASE_MASTER_INFO_PORT
    xml_set \$HBASE hbase.regionserver.port \$HBASE_RS_PORT
    xml_set \$HBASE hbase.regionserver.info.port \$HBASE_RS_INFO_PORT
    xml_set \$HBASE hbase.hregion.memstore.flush.size \$HBASE_HREGION_M_F_SIZE
    xml_set \$HBASE hbase.hregion.max.filesize \$HBASE_HREGION_M_FILESIZE
    xml_set \$HBASE hbase.hstore.blockingWaitTime \$HBASE_HSTORE_BLOCKINGWAITTIME
    xml_set \$HBASE zookeeper.znode.parent /hbase
    quorum=\`echo \$ZK_NODES|sed \"s/ /,/g\"\`;
    xml_set \$HBASE hbase.zookeeper.quorum \"\$quorum\"
    xml_set \$HBASE hbase.zookeeper.peerport \${ZK_PORT_PREFIX}288
    xml_set \$HBASE hbase.zookeeper.leaderport \${ZK_PORT_PREFIX}388
    xml_set \$HBASE hbase.zookeeper.property.clientPort \${ZK_PORT_PREFIX}181
    xml_set \$HBASE hbase.rest.port \$HBASE_REST_PORT

    echo \"\$RS_NODES\" > \$REGIONSERVERS;
    echo \${BACKUP_NODES} > \$BACKUP_MASTERS;
  "
}

# main
#==========
cd $DIR

show_head;

file_die logs/install_hbase_ok "hbase is installed"
notfile_die logs/install_hadoop_ok "must install hadoop first"

. ./config_hbase.sh

download

for s in $HBASE_NODES; do
  same_to $s $DIR
  [ -f "logs/install_hbase_ok_${s}" ] && continue 
  deploy $s; 
  touch "logs/install_hbase_ok_${s}"
done

. $HOME/.bash_profile

touch logs/install_hbase_ok

echo ">> OK"
cd $OLD_DIR

