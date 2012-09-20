#!/usr/bin/env bash
BAPF="$HOME/.bash_profile"
HDPF="$HOME/.hadoop_profile"

HDFLAG="# hadoop profile - uc.cn"

profile()
{
  if ! grep -q "$HDFLAG" $BAPF; then 
    echo "$HDFLAG" >> $BAPF;
    echo "if [ -f $HDPF ]; then" >> $BAPF;
    echo "  . $HDPF;" >> $BAPF;
    echo "fi" >> $BAPF;
    echo "#END#" >> $BAPF;
  fi

  echo "$HDFLAG
  
  export PKG_PATH=\$HOME/pkg
  export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PKG_PATH/lzo/lib

  export JAVA_HOME=\$HOME/java/jdk
  # export JRE_HOME=\$JAVA_HOME/jre
  # ddexport ANT_HOME=\$HOME/java/ant
  # export MAVEN_HOME=\$HOME/java/maven

  # export CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib:\$ANT_HOME/lib:\$MAVEN_HOME/lib
  export CLASSPATH=.:\$JAVA_HOME/lib/tools.jar

  export HADOOP_HOME=\$HOME/hadoop
  export HADOOP_BIN=\$HADOOP_HOME/bin
  export HADOOP_SBIN=\$HADOOP_HOME/sbin
  export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop

  export PATH=\$DEPLOYER_HOME/bin:\$PATH
  #export PATH=\$JAVA_HOME/bin:\$JRE_HOME/bin:\$ANT_HOME/bin:\$MAVEN_HOME/bin:\$PATH
  export PATH=\$JAVA_HOME/bin:\$PATH
  #export PATH=\$PKG_PATH/lzop/bin:\$PKG_PATH/fuse-dfs:\$PATH
  export PATH=.:\$HADOOP_BIN:\$HADOOP_SBIN:\$PATH

  alias ccd='cd \$HADOOP_HOME'
  alias ccb='cd \$HADOOP_BIN'
  alias ccsb='cd \$HADOOP_SBIN'
  alias ccf='cd \$HADOOP_CONF_DIR'

  " > $HDPF
}

unprofile()
{
  rm -f $HDPF
  cp $BAPF "$BAPF.$NOW8_6"
  sed -i "/$HDFLAG/,/#END#/d" $BAPF
}
