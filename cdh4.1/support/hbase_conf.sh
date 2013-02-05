#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

if [ -z "$DP_HOME" ]; then
  echo ">> deployer is not installed or install fail"
  exit -1
fi
. $DP_HOME/support/PUB.sh

#配置文件
quorum=`echo $ZK_NODES|sed "s/ /,/g"`;

echo ">> +-->conf hbase";
cp -f support/hbase_conf/* $HBASE_CONF_DIR;

HBASE="$HBASE_CONF_DIR/hbase-site.xml";
REGIONSERVERS="$HBASE_CONF_DIR/regionservers";
BACKUP_MASTERS="$HBASE_CONF_DIR/backup-masters";

PP=${HBASE_PORT_PREFIX};
#xml_set $HBASE hbase.tmp.dir $HOME/hbase_temp
xml_set $HBASE hbase.master.port ${PP}600
xml_set $HBASE hbase.master.info.port ${PP}610
xml_set $HBASE hbase.regionserver.port ${PP}620
xml_set $HBASE hbase.regionserver.info.port ${PP}630
xml_set $HBASE hbase.hregion.memstore.flush.size $((128*1024*1024)) 
xml_set $HBASE hbase.hregion.max.filesize $((512*1024*1024)) 
xml_set $HBASE hbase.hstore.blockingWaitTime 90000 
xml_set $HBASE zookeeper.znode.parent /hbase
xml_set $HBASE hbase.zookeeper.quorum "$quorum"
xml_set $HBASE hbase.zookeeper.peerport ${PP}288
xml_set $HBASE hbase.zookeeper.leaderport ${PP}388
xml_set $HBASE hbase.zookeeper.property.clientPort ${PP}181
xml_set $HBASE hbase.rest.port ${PP}880

echo "$RS_NODES" > $REGIONSERVERS;
echo ${BACKUP_NODES} > $BACKUP_MASTERS;

mkdir -p $HOME/hbase_temp

