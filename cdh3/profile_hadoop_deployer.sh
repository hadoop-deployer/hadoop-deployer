#!/usr/bin/env bash
# coding=utf-8
# zhaigy@ucweb.com
# 2012-09

BAPF="$HOME/.bash_profile"
HDPF="$HOME/.hadoop_deployer_profile"

[ ! -e $BAPF ] && touch $BAPF;

if ! grep -q "\# hadoop deployer profile - uc.cn" $BAPF; then 
  echo "#" >> $BAPF;
  echo "# hadoop depolyer profile - uc.cn" >> $BAPF;
  echo "#" >> $BAPF;
  echo "if [ -f $HDPF ]; then . $HDPF; fi" >> $BAPF;
  echo "#END#" >> $BAPF;
fi

echo "# Hadoop deployer profile - uc.cn

export DEPLOYER_HOME=$HOME/hadoop-deployer
export SSH_PORT=$SSH_PORT

export PKG_PATH=\$HOME/pkg
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PKG_PATH/lzo/lib

export JAVA_HOME=\$HOME/java/jdk
export JRE_HOME=\$JAVA_HOME/jre
export ANT_HOME=\$HOME/java/ant
export MAVEN_HOME=\$HOME/java/maven

export CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib:\$ANT_HOME/lib:\$MAVEN_HOME/lib

export PATH=\$DEPLOYER_HOME/bin:\$PATH
export PATH=\$JAVA_HOME/bin:\$JRE_HOME/bin:\$ANT_HOME/bin:\$MAVEN_HOME/bin:\$PATH
export PATH=.:\$PKG_PATH/lzop/bin:\$PKG_PATH/fuse-dfs:\$PATH

alias ssh='ssh -p \$SSH_PORT'
alias scp='scp -P \$SSH_PORT'
alias cchd='cd \$DEPLOYER_HOME'

" > $HDPF

. $HDPF
