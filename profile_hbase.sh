#!/bin/bash

BAPF="$HOME/.bash_profile"
HBPF="$HOME/.hbase_profile"

if [ ! -e $BAPF ]; then
  touch $BAPF;
fi

if ! grep -q "hbase profile" $BAPF; then 
  echo "" >> $BAPF;
  echo "#" >> $BAPF;
  echo "# hbase profile" >> $BAPF;
  echo "#" >> $BAPF;
  echo "if [ -f $HBPF ]; then" >> $BAPF;
  echo "    . $HBPF" >> $BAPF;
  echo "fi" >> $BAPF;
  echo "#END#" >> $BAPF;
fi

echo "# HBase profile

export HBASE_HOME=\$HOME/hbase
export HBASE_BIN=\$HBASE_HOME/bin
export HBASE_CONF_DIR=\$HBASE_HOME/conf

export PATH=\$HBASE_BIN:\$PATH

" > $HBPF

. $BAPF
#. $HBPF
