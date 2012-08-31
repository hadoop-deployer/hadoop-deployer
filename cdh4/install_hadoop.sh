#!/usr/bin/env bash
# -- utf-8 --
DIR=$(cd $(dirname $0); pwd)
. $DIR/support/PUB.sh

# $0 host
deploy()
{
  echo ">> deploy $1";
  # 1. 解压安装
  ssh "$USER@$1" " 
    cd $D;
    . support/PUB.sh;
    . support/deploy_hadoop_env.sh;
    
    echo \">> deploy java\";
    var_die JAVA_TAR;
    mkdir -p $HOME/java;
    tar -xzf tars/\$JAVA_TAR -C $HOME/java;
    JAVA_VERSION=\`find $HOME/java -maxdepth 1 -name \"jdk*\"|sed \"s:.*/::;1q\"\`
    ln -sf \$JAVA_VERSION $HOME/java/jdk;

    if [ \"\$ANT_TAR\" != \"\" ]; then
      tar -xzf tars/\$ANT_TAR -C $HOME/java
      ANT_VERSION=\`find $HOME/java -maxdepth 1 -name \"apache-ant*\"|sed \"s:.*/::;1q\"\`
      ln -sf \$ANT_VERSION $HOME/java/ant;
    fi

    if [ \"\$MAVEN_TAR\" != \"\" ]; then
      tar -xzf tars/\$MAVEN_TAR -C $HOME/java ||:;
      MAVEN_VERSION=\`find $HOME/java -maxdepth 1 -name \"apache-maven*\"|sed \"s:.*/::;1q\"\`
      ln -sf \$MAVEN_VERSION $HOME/java/maven;
    fi
  
    echo \">> deploy hadoop\"
    var_die HADOOP_TAR
    tar -xzf tars/\$HADOOP_TAR -C $HOME
    ln -sf ./\$HADOOP_VERSION $HOME/hadoop

    if [ \"\$HADOOP_LZO_TAR\" != \"\" ]; then
      tar -xzf tars/\$HADOOP_LZO_TAR -C $HOME/hadoop;
    fi

    if [ \"\$LZO_TAR\" != \"\" ]; then
      mkdir -p $HOME/pkg;
      tar -xzf tars/\$LZO_TAR -C $HOME/pkg; 
    fi

    if [ \"\$FUSE_DFS_TAR\" != \"\" ]; then
      mkdir -p $HOME/pkg;
      tar -xzf tars/\$FUSE_DFS_TAR -C \$HOME/pkg;
    fi
  "

  # 2. profile文件
  ssh $USER@$1 "
    cd $D;
    . support/PUB.sh;
    . support/profile_hadoop.sh;
    profile;
  "
  # 3. 配置 xml文件 
  ssh $USER@$1 sh $DIR/support/xml_hadoop.sh; 
}

#==========
cd $DIR

show_head;

file_die logs/install_hadoop_ok "hadoop is installed"
notfile_die logs/install_deployer_ok "deployer is not installed"
if [ ! -e logs/install_zookeeper_ok ]; then 
  #先安装zk
  bash install_zookeeper.sh; 
fi

. ./config_hadoop.sh

download

for s in $HADOOP_NODES; do
  same_to $s $DIR
  [ -f "logs/install_hadoop_ok_${s}" ] && continue 
  deploy $s; 
  touch "logs/install_hadoop_ok_${s}"
done

. $HOME/.bash_profile

touch logs/install_hadoop_ok

echo ">> OK"
cd $OLD_DIR

