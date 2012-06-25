#!/bin/bash
# Author: lishan@ucweb.com
#########################################################
# 1. Required Dependencies of Hue on Redhat:
#    gcc
#    libxml2-devel
#    libxslt-devel
#    cyrus-sasl-devel
#    mysql-devel
#    python-devel
#    python-setuptools
#    python-simplejson
#    Note: yum installs python 2.4.3 by default, if you
#    have already installed python 2.6 in your machine, 
#    you are required to install "easy_install" 2.6,then
#    run "easy_install setuptools;easy_install simplejson"
# 2. Please check whether your hadoop cluster is running
#    before you start your Hue.
#########################################################


check_tools()
{
  check_tool ssh 
  check_tool easy_install
  check_tool gcc 
  check_tool g++ 
}


hue_deploy()
{
  tar -xzf tars/$HUE_TAR -C $HOME;

  HUE="$HOME/$HUE_VERSION/desktop/conf/hue.ini";
  cp hueconf/hue.ini $HUE;

  ln -f -s $HUE_HOME/desktop/libs/hadoop/java-lib/hue-plugins-*.jar $HADOOP_HOME/lib;

  # hue.ini
  sed -r "s#secret_key_value#$SECRET_KEY#" -i $HUE;
  sed -r "s/hue_http_host_value/$WEBSERVER_HTTP_HOST/" -i $HUE;
  sed -r "s/hue_http_port_value/$WEBSERVER_HTTP_PORT/" -i $HUE;
  sed -r "s/mysql_host_value/$HUE_MYSQL_HOST/" -i $HUE;
  sed -r "s/mysql_port_value/$HUE_MYSQL_PORT/" -i $HUE;
  sed -r "s/mysql_user_value/$HUE_MYSQL_USERNAME/" -i $HUE;
  sed -r "s/mysql_password_value/$HUE_MYSQL_PASSWORD/" -i $HUE;
  sed -r "s/mysql_name_value/$HUE_DB_NAME/" -i $HUE;
  sed -r "s#hadoop_home_value#$HADOOP_HOME#" -i $HUE;
  sed -r "s#hadoop_conf_value#$HADOOP_CONF_DIR#" -i $HUE;
  sed -r "s/namenode_host_value/$NN/" -i $HUE;
  sed -r "s/hdfs_port_value/$DFS_PORT/" -i $HUE;
  sed -r "s/hdfs_http_port_value/$DFS_HTTP_PORT/" -i $HUE;
  sed -r "s/jobtracker_host_value/$JT/" -i $HUE;
  sed -r "s/hdfs_thrift_port_value/$DFS_THRIFT_PORT/" -i $HUE;
  sed -r "s/jobtracker_thrift_port_value/$JOBTRACKER_THRIFT_PORT/" -i $HUE;

  # hue-beeswax.ini
  BEESWAX="$HOME/$HUE_VERSION/apps/beeswax/conf/hue-beeswax.ini";
  cp hueconf/hue-beeswax.ini $BEESWAX;
  sed -r "s/beeswax_meta_server_port_value/$BEESWAX_META_SERVER_PORT/" -i $BEESWAX;
  sed -r "s/beeswax_server_port_value/$BEESWAX_SERVER_PORT/" -i $BEESWAX;
  sed -r "s#hive_home_dir_value#$HOME/hive#" -i $BEESWAX;
  sed -r "s#hive_conf_dir_value#$HOME/hive/conf#" -i $BEESWAX;

  #chmod +x $DEPLOY_HOME/hue/database-init;
  #$DEPLOY_HOME/hue/database-init $HUE_MYSQL_USERNAME $HUE_MYSQL_PASSWORD $HUE_MYSQL_HOST $HUE_DB_NAME;

  cd $HOME/$HUE_VERSION;
  if [ -f $DIR/logs/hue_make_ok ]; then
    continue;
  else
    rm -rf $HOME/hue
    HADOOP_HOME=$HADOOP_HOME PREFIX=$HOME make install;
    touch $DIR/logs/hue_make_ok
  fi
  cd $DIR

  #chmod +x $DEPLOY_HOME/hue/database-user-permissions;
  #$DEPLOY_HOME/hue/database-user-permissions $HUE_MYSQL_USERNAME $HUE_MYSQL_PASSWORD $HUE_MYSQL_HOST $HUE_DB_NAME;

  cp hueconf/hue.sh $HUE_HOME;
  chmod +x $HUE_HOME/hue.sh;
}

main()
{
  [ -f logs/hue_ok ] && die "hue is already installed"
  . PUB.sh;
  show_head;
  . deploy_env.sh
  check_tools;
  . $DIR/profile_hue.sh;
  hue_deploy;
  touch logs/hue_ok
  echo ">> OK"
}

#====
main $*;
