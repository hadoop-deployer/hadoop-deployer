#!/bin/env bash
# -- utf-8 --

params()
{
  if [ -f ./install_env.sh ]; then
    . ./install_env.sh
    nodes;
  else
    die "no install_env.sh"
  fi
}

deploy_hive()
{
  echo ">> deploy hive"
  tar -xzf tars/$HIVE_TAR -C $HOME;
  cd $HOME;
  ln -sf ./$HIVE_VERSION $HIVE_HOME;
  cd $DIR
  cp tars/$MYSQL_JAR $HIVE_HOME/lib;

  HIVE="$HIVE_CONF_DIR/hive-site.xml";
  cp hiveconf/hive-site.xml $HIVE;
}

conf_hive()
{
  echo ">> conf hive"

  F1="s/<value"
  F2="\/value>/<value"
  F3="\/value>/"

  sed -r "s#<value>fs.default.name<\/value>#<value>$FS_DEFAULT_NAME<\/value>#" -i $HIVE;
  sed -r "$F1>mapred.job.tracker<$F2>$MAPRED_JOB_TRACKER<$F3" -i $HIVE;
  sed -r "$F1>hive.metastore.local<$F2>$HIVE_METASTORE_LOCAL<$F3" -i $HIVE;
  sed -r "s#<value>javax.jdo.option.ConnectionURL<\/value>#<value>$JAVAX_JDO_OPTION_CONNECTIONURL<\/value>#" -i $HIVE;
  sed -r "s#<value>hive.metastore.warehouse.dir<\/value>#<value>$HIVE_METASTORE_WAREHOUSE_DIR<\/value>#" -i $HIVE;
  sed -r "$F1>javax.jdo.option.ConnectionUserName<$F2>$MYSQL_USERNAME<$F3" -i $HIVE;
  sed -r "$F1>javax.jdo.option.ConnectionPassword<$F2>$MYSQL_PASSWORD<$F3" -i $HIVE;
  sed -r "$F1>hive.exec.compress.intermediate<$F2>$HIVE_EXEC_COMPRESS_INTERMEDIATE<$F3" -i $HIVE;
  sed -r "$F1>mapred.compress.map.output<$F2>$MAPRED_COMPRESS_MAP_OUTPUT<$F3" -i $HIVE;
  sed -r "$F1>mapred.output.compression.type<$F2>$MAPRED_OUTPUT_COMPRESSION_TYPE<$F3" -i $HIVE;
  sed -r "$F1>hive.input.format<$F2>$HIVE_INPUT_FORMAT<$F3" -i $HIVE;

  #chmod +x hive/database-init;
  #hive/database-init $MYSQL_USERNAME $MYSQL_PASSWORD $METASTORE;
}

main() 
{
  DIR=`cd $(dirname $0);pwd`
  . $DIR/PUB.sh
  cd $DIR
  [ -f logs/hadoop_ok ] || die "must install hadoop first"
  [ -f logs/hive_ok ] && die "hive is installed"
  show_head;
  params;
  download
  rsync_all $DIR $HOME
  . $DEPLOYER_HOME/profile_hive.sh;
  . $DEPLOYER_HOME/deploy_env.sh
  deploy_hive;
  conf_hive;
  touch logs/hive_ok
  echo ">> OK"
  cd $OLD_DIR
}

#====
main $*;

