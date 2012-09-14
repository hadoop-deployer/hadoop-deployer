#!/bin/bash

BAPF="$HOME/.bash_profile"
HBPF="$HOME/.hbase_profile"

HBFLAG="# hbase profile - uc.cn"

profile()
{
  if ! grep -q "#HBFLAG" $BAPF; then 
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

  " > $HBPF
}

unprofile()
{
  rm -f $HBPF
  cp $BAPF "$BAPF.$NOW8_6"
  sed -i "/$HBFLAG/,/#END#/d" $BAPF
}
