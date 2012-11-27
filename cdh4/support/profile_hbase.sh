#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

BAPF="$HOME/.bash_profile"
HBPF="$HOME/.hbase_profile"

HBFLAG="# hbase profile - uc.cn"

profile()
{
  if ! grep -q "$HBFLAG" $BAPF; then 
    echo "$HBFLAG" >> $BAPF;
    echo "if [ -f $HBPF ]; then" >> $BAPF;
    echo "  . $HBPF;" >> $BAPF;
    echo "fi" >> $BAPF;
    echo "#END#" >> $BAPF;
  fi

  echo "$HBFLAG
  export HBASE_HOME=\$HOME/hbase
  export HBASE_BIN=\$HBASE_HOME/bin
  export HBASE_CONF_DIR=\$HBASE_HOME/conf

  export PATH=\$HBASE_BIN:\$PATH

  alias cchb='cd \$HBASE_HOME'
  alias cchbf='cd \$HBASE_CONF_DIR'
  " > $HBPF
}

unprofile()
{
  rm -f $HBPF
  cp $BAPF "$BAPF.$NOW8_6"
  sed -i "/$HBFLAG/,/#END#/d" $BAPF
}
