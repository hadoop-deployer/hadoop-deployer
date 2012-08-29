#!/usr/bin/env bash
BAPF="$HOME/.bash_profile"
ZKPF="$HOME/.zookeeper_profile"

ZKFLAG="# zookeeper profile - uc.cn"

profile()
{
  if ! grep -q "$ZKFLAG" $BAPF; then 
    echo "$ZKFLAG" >> $BAPF;
    echo "if [ -f $ZKPF ]; then" >> $BAPF;
    echo "  . $ZKPF;" >> $BAPF;
    echo "fi" >> $BAPF;
    echo "#END#" >> $BAPF;
  fi

  echo "$ZKFLAG

  export ZK_HOME=\$HOME/zookeeper
  export ZK_BIN=\$ZK_HOME/bin
  export ZK_CONF_DIR=\$ZK_HOME/conf

  export PATH=\$ZK_BIN:\$PATH

  alias \"cczk=cd \$ZK_HOME\"

  " > $ZKPF

  . $BAPF
}

unprofile()
{
  rm -f $ZKPF
  cp $BAPF "$BAPF.$NOW8_6"
  sed -i "/$ZKFLAG/,/#END#/d $BAPF
}
