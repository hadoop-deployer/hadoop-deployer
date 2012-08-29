#!/usr/bin/env echo "Warning: this file should be sourced"
# -- UTF-8 --

if [ -z $DEPLOYER_HOME ]; then
  die "deployer is not installed or install fail"
fi
. $DEPLOYER_HOME/support/PUB.sh

##### tar package #####
ZK_TAR=zookeeper-3.4.3-cdh4.0.0.tar.gz
ZK_VERSION=${ZK_TAR%.tar.gz}

##### conf file #####
#quorum()
#{
#  local OLD_IFS="$IFS" 
#  IFS="
#  "
#  local arr=($DN)
#  IFS=$OLD_IFS
#  local tmp=${arr[@]::5}
#  tmp=`echo $tmp`
#  tmp=${tmp// /,}
#  HBASE_ZOOKEEPER_QUORUM=$tmp
#}
#quorum

