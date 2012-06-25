#!/bin/bash

BAPF="$HOME/.bash_profile"
ZKPF="$HOME/.zookeeper_profile"

if [ ! -e $BAPF ]; then
  touch $BAPF;
fi

if ! grep -q "zookeeper profile" $BAPF; then 
  echo "" >> $BAPF;
  echo "#" >> $BAPF;
  echo "# zookeeper profile" >> $BAPF;
  echo "#" >> $BAPF;
  echo "if [ -f $ZKPF ]; then" >> $BAPF;
  echo "  . $ZKPF" >> $BAPF;
  echo "fi" >> $BAPF;
  echo "#END#" >> $BAPF;
fi

echo "# HBase profile

export ZK_HOME=\$HOME/zookeeper
export ZK_BIN=\$ZK_HOME/bin
export ZK_CONF_DIR=\$ZK_HOME/conf

export PATH=\$ZK_BIN:\$PATH

" > $ZKPF

. $BAPF
