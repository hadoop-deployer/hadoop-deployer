#!/bin/env bash

deploy_java()
{
  echo ">> deploy java"
  mkdir -p $HOME/java
  tar -xzf tar/$JAVA_TAR -C $HOME/java
  [ "$ANT_TAR" != "" ] && tar -xzf tar/$ANT_TAR -C $HOME/java ||:;
  [ "$MAVEN_TAR" != "" ] && tar -xzf tar/$MAVEN_TAR -C $HOME/java ||:;
  cd $HOME/java; 
  ln -sf ./$JAVA_VERSION jdk;
  [ "$ANT_TAR" != "" ] && ln -sf ./$ANT_VERSION ant ||:;
  [ "$MAVEN_TAR" != "" ] && ln -sf ./$MAVEN_VERSION maven ||:;
  cd $DIR;
}

deploy_hadoop()
{
  echo ">> deploy hadoop"
  [ "$HADOOP_TAR" == "" ] && die "hadoop's tar file not found" ||:;
  tar -xzf tar/$HADOOP_TAR -C $HOME
  ln -sf ./$HADOOP_VERSION $HADOOP_HOME
  
  [ "$HADOOP_LZO_TAR" != "" ] && tar -xzf tar/$HADOOP_LZO_TAR -C $HADOOP_HOME ||:;
  
  mkdir -p $PKG_PATH;
  [ "$LZO_TAR" != "" ] && tar -xzf tar/$LZO_TAR -C $PKG_PATH ||:; 
  [ "$FUSE_DFS_TAR" != "" ] && tar -xzf tar/$FUSE_DFS_TAR -C $PKG_PATH ||:;
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

