#!/usr/bin/env bash
# -- UTF-8 --
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

    set_xml \$HBASE hbase.zookeeper.quorum \$HBASE_ZOOKEEPER_QUORUM

    set_xml \$HBASE hbase.tmp.dir \$HOME/hbase_temp
    set_xml \$HBASE hbase.master.port \$HBASE_MASTER_PORT
    set_xml \$HBASE hbase.master.info.port \$HBASE_MASTER_INFO_PORT
    set_xml \$HBASE hbase.regionserver.port \$HBASE_RS_PORT
    set_xml \$HBASE hbase.regionserver.info.port \$HBASE_RS_INFO_PORT
    set_xml \$HBASE hbase.hregion.memstore.flush.size \$HBASE_HREGION_M_F_SIZE
    set_xml \$HBASE hbase.hregion.max.filesize \$HBASE_HREGION_M_FILESIZE
    set_xml \$HBASE hbase.hstore.blockingWaitTime \$HBASE_HSTORE.BLOCKINGWAITTIME
    set_xml \$HBASE zookeeper.znode.parent /hbase
    quorum=\`echo \$ZK_NODES|sed \"s/ /,/g\"\`;
    set_xml \$HBASE hbase.zookeeper.quorum \"\$quorum\"
    set_xml \$HBASE hbase.zookeeper.peerport \${ZK_PORT_PREFIX}288
    set_xml \$HBASE hbase.zookeeper.leaderport \${ZK_PORT_PREFIX}388
    set_xml \$HBASE hbase.zookeeper.property.clientPort \${ZK_PORT_PREFIX}181
    set_xml \$HBASE hbase.rest.port \$HBASE_REST_PORT

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

for s in $HBASE_HOSTS; do
  same_to $s $DIR
  [ -f "logs/install_hbase_ok_${s}" ] && continue 
  deploy $s; 
  touch "logs/install_hbase_ok_${s}"
done

. $HOME/.bash_profile

touch logs/install_hbase_ok

echo ">> OK"
cd $OLD_DIR

