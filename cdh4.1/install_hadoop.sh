#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

DIR=$(cd $(dirname $0); pwd)
if [ -z "$DP_HOME" ]; then export DP_HOME=$DIR; fi
. $DIR/support/PUB.sh

# $0 host
deploy()
{
  echo ">> deploy $1";
  # 1. 解压安装
  ssh "$USER@$1" " 
    cd $D;
    . support/PUB.sh;
    . support/hadoop_deploy_env.sh;
    
    echo \">> +-->deploy java\";
    var_die JAVA_TAR;
    mkdir -p $HOME/java;
    tar -xzf tars/\$JAVA_TAR -C $HOME/java;
    JAVA_VERSION=\`find $HOME/java -maxdepth 1 -name \"jdk*\"|sed \"s:.*/::;1q\"\`;
    ln -sf \$JAVA_VERSION $HOME/java/jdk;

    if [ \"\$ANT_TAR\" != \"\" ]; then
      tar -xzf tars/\$ANT_TAR -C $HOME/java;
      ANT_VERSION=\`find $HOME/java -maxdepth 1 -name \"apache-ant*\"|sed \"s:.*/::;1q\"\`;
      ln -sf \$ANT_VERSION $HOME/java/ant;
    fi;

    if [ \"\$MAVEN_TAR\" != \"\" ]; then
      tar -xzf tars/\$MAVEN_TAR -C $HOME/java ||:;
      MAVEN_VERSION=\`find $HOME/java -maxdepth 1 -name \"apache-maven*\"|sed \"s:.*/::;1q\"\`;
      ln -sf \$MAVEN_VERSION $HOME/java/maven;
    fi;
  
    echo \">> +-->deploy hadoop\";
    var_die HADOOP_TAR;
    tar -xzf tars/\$HADOOP_TAR -C $HOME;
    ln -sf ./\$HADOOP_VERSION $HOME/hadoop;

    if [ \"\$FUSE_DFS_TAR\" != \"\" ]; then
      mkdir -p $HOME/pkg;
      tar -xzf tars/\$FUSE_DFS_TAR -C \$HOME/pkg;
    fi;
  "

  # 2. profile文件
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/hadoop_profile.sh;
    profile;
  "

  # 3. 配置文件 
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    sh $DIR/support/hadoop_conf.sh; 
  "
}

# main
#==========
cd $DIR

file_die logs/install_hadoop_ok "hadoop is installed"
if [ ! -e logs/install_zookeeper_ok ]; then
  ./install_zookeeper.sh
  source ~/.bash_profile
fi
notfile_die logs/install_zookeeper_ok "need pre install zookeeper"

show_head;

for s in $NODES; do
  same_to $s $DIR
  [ -f "logs/install_hadoop_ok_${s}" ] && continue 
  deploy $s; 
  touch "logs/install_hadoop_ok_${s}"
  echo ">>"
done

touch logs/install_hadoop_ok

echo ">> OK"
echo ">> \!\!\!Please Run: source ~/.bash_profile"
cd $OLD_DIR
