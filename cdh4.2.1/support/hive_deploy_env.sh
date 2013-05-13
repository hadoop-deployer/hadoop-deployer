#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

if [ -z $DP_HOME ]; then
  echo "deployer is not installed or install fail"
  exit -1
fi
. $DP_HOME/support/PUB.sh

#hive-0.9.0-cdh4.1.1.tar.gz
HIVE_TAR=`find_tar "hive-.*-cdh4.*"`;
HIVE_VERSION=${HIVE_TAR%.tar.gz} ||:;

##### conf file #####
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

