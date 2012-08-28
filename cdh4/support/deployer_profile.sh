#!/bin/bash
BAPF="$HOME/.bash_profile"
HDPF="$HOME/.deployer_profile"

[ ! -e $BAPF ] && touch $BAPF;

DPFLAG="# hadoop deployer profile - uc.cn"

profile()
{
  if ! grep -q "$DPFLAG" $BAPF; then 
    echo "$DPFLAG" >> $BAPF;
    echo "if [ -f $HDPF ]; then . $HDPF; fi" >> $BAPF;
    echo "#END#" >> $BAPF;
  fi
  
  echo "$DPFLAG
  
  export DEPLOYER_HOME=/home/zgy/hadoop-deployer/cdh4
  export SSH_PORT=$SSH_PORT
  
  export PATH=\$DEPLOYER_HOME/bin:\$PATH
  
  alias ssh='ssh -p \$SSH_PORT'
  alias scp='scp -P \$SSH_PORT'
  alias cchd='cd \$DEPLOYER_HOME'
  
  " > $HDPF
  
  . $HDPF
}

unprofile()
{
  rm -f $HDPF
  cp $BAPF "$BAPF.$NOW8_6"
  # DPFLAG="# hadoop deployer profile - uc.cn"
  sed -i "/$DPFLAG/,/#END#/d" $BAPF
}
