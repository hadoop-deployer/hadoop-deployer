#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

BAPF="$HOME/.bash_profile"
HUPF="$HOME/.hue_profile"

if [ ! -e $BAPF ]; then
    touch $BAPF;
fi

if ! grep -q "hue profile" $BAPF; then 
    echo "" >> $BAPF;
    echo "#" >> $BAPF;
    echo "# hue profile" >> $BAPF;
    echo "#" >> $BAPF;
    echo "if [ -f $HUPF ]; then" >> $BAPF;
    echo "    . $HUPF" >> $BAPF;
    echo "fi" >> $BAPF;
fi

echo "# Hue profile

export HUE_HOME=\$HOME/hue
export HUE_CONF_DIR=\$HUE_HOME/desktop/conf

export PATH=\$HUE_HOME:\$PATH

alias ccu='cd \$HUE_HOME'

" > $HUPF

. $HUPF
