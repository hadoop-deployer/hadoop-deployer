#!/usr/bin/env bash
# coding=utf-8
# zhaigy@ucweb.com
# 2012-09

deploy_java()
{
  echo ">> deploy java"
  mkdir -p $HOME/java
  tar -xzf tars/$JAVA_TAR -C $HOME/java
  JAVA_VERSION=`find $HOME/java -maxdepth 1 -name "jdk*"|sed "s:.*/::;1q"`
  ln -sf $JAVA_VERSION $HOME/java/jdk;

  if [ "$ANT_TAR" != "" ]; then
    tar -xzf tars/$ANT_TAR -C $HOME/java
    ANT_VERSION=`find $HOME/java -maxdepth 1 -name "apache-ant*"|sed "s:.*/::;1q"`
    ln -sf $ANT_VERSION $HOME/java/ant;
  fi

  if [ "$MAVEN_TAR" != "" ]; then
    tar -xzf tars/$MAVEN_TAR -C $HOME/java ||:;
    MAVEN_VERSION=`find $HOME/java -maxdepth 1 -name "apache-maven*"|sed "s:.*/::;1q"`
    ln -sf $MAVEN_VERSION $HOME/java/maven;
  fi
}

deploy_hadoop()
{
  echo ">> deploy hadoop"
  [ "$HADOOP_TAR" == "" ] && die "hadoop's tar file not found" ||:;
  tar -xzf tars/$HADOOP_TAR -C $HOME
  ln -sf ./$HADOOP_VERSION $HADOOP_HOME
  
  [ "$HADOOP_LZO_TAR" != "" ] && tar -xzf tars/$HADOOP_LZO_TAR -C $HADOOP_HOME ||:;
  
  mkdir -p $PKG_PATH;
  [ "$LZO_TAR" != "" ] && tar -xzf tars/$LZO_TAR -C $PKG_PATH ||:; 
  [ "$FUSE_DFS_TAR" != "" ] && tar -xzf tars/$FUSE_DFS_TAR -C $PKG_PATH ||:;
}

main()
{
  DIR=`cd $(dirname $0);pwd`
  cd $DIR
  . profile.sh
  . PUB.sh
  . deploy_env.sh
  deploy_java;
  deploy_hadoop;
  cd $OLDDIR
}

#====
main;

