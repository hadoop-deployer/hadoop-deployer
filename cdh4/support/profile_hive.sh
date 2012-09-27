#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

BAPF="$HOME/.bash_profile"
HIPF="$HOME/.hive_profile"

if [ ! -e $BAPF ]; then
  touch $BAPF;
fi

if ! grep -q "hive profile" $BAPF; then 
  echo "" >> $BAPF;
  echo "#" >> $BAPF;
  echo "# hive profile" >> $BAPF;
  echo "#" >> $BAPF;
  echo "if [ -f $HIPF ]; then" >> $BAPF;
  echo "  . $HIPF" >> $BAPF;
  echo "fi" >> $BAPF;
  echo "#END#" >> $BAPF;
fi

echo "# Hive profile

export HIVE_HOME=\$HOME/hive
export HIVE_BIN=\$HIVE_HOME/bin
export HIVE_CONF_DIR=\$HIVE_HOME/conf

export PATH=\$HIVE_BIN:\$PATH

alias cch='cd \$HIVE_HOME'
alias cchf='cd \$HIVE_CONF'
" > $HIPF

. $HIPF
