#!/bin/bash
. PUB.sh

BAPF="$HOME/.bash_profile"
HDPF="$HOME/.hadoop_profile"

[ ! -e $BAPF ] && touch $BAPF;

if ! grep -q "\# hadoop profile - uc.cn" $BAPF; then 
  echo -e "\n#\n# hadoop profile - uc.cn\n#" >> $BAPF;
  echo "if [ -f $HDPF ]; then . $HDPF; fi" >> $BAPF;
  echo "#END#" >> $BAPF;
fi

echo "# Hadoop profile - uc.cn

export SSH_PORT=9922
export PKG_PATH=\$HOME/pkg
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PKG_PATH/lzo/lib

export JAVA_HOME=\$HOME/java/jdk
export JRE_HOME=\$JAVA_HOME/jre
export ANT_HOME=\$HOME/java/ant
export MAVEN_HOME=\$HOME/java/maven

export CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib:\$ANT_HOME/lib:\$MAVEN_HOME/lib

export HADOOP_HOME=\$HOME/hadoop
export HADOOP_BIN=\$HADOOP_HOME/bin
export HADOOP_CONF_DIR=\$HADOOP_HOME/conf

export PATH=$DIR/bin:\$PATH
export PATH=\$JAVA_HOME/bin:\$JRE_HOME/bin:\$ANT_HOME/bin:\$MAVEN_HOME/bin:\$PATH
export PATH=.:\$PKG_PATH/lzop/bin:\$PKG_PATH/fuse-dfs:\$PATH
export PATH=.:\$HADOOP_BIN:\$PATH

alias ssh='ssh -p $SSH_PORT'
alias ccd='cd \$HADOOP_HOME'
alias ccb='cd \$HADOOP_BIN'
alias ccf='cd \$HADOOP_CONF_DIR'
alias cdh='cd $DIR'

" > $HDPF

. $HDPF
