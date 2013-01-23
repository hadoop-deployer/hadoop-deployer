#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-11

BAPF="$HOME/.bash_profile"
HIPF="$HOME/.hive_profile"

HIFLAG="# hive profile - uc.cn"

profile()
{
  if ! grep -q "$HIFLAG" $BAPF; then 
    echo "" >> $BAPF;
    echo "$HIFLAG" >> $BAPF;
    echo "if [ -f $HIPF ]; then" >> $BAPF;
    echo "  . $HIPF;" >> $BAPF;
    echo "fi" >> $BAPF;
    echo "#END#" >> $BAPF;
  fi
  
  echo "$HIFLAG
export HIVE_HOME=\$HOME/hive
export HIVE_BIN=\$HIVE_HOME/bin
export HIVE_CONF_DIR=\$HIVE_HOME/conf
 
export PATH=\$HIVE_BIN:\$PATH
 
alias cchi='cd \$HIVE_HOME'
alias cchif='cd \$HIVE_CONF_DIR'
" > $HIPF
}

unprofile()
{
  rm -f $HIPF
  cp $BAPF "$BAPF.$NOW8_6"
  sed -i "/$HIFLAG/,/#END#/d" $BAPF
}
