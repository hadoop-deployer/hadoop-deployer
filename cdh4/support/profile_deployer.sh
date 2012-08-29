#!/usr/bin/env bash
BAPF="$HOME/.bash_profile"
DPPF="$HOME/.deployer_profile"

[ ! -e $BAPF ] && touch $BAPF;

DPFLAG="# hadoop deployer profile - uc.cn"

profile()
{
  if ! grep -q "$DPFLAG" $BAPF; then 
    echo "$DPFLAG" >> $BAPF;
    echo "if [ -f $DPPF ]; then . $DPPF; fi" >> $BAPF;
    echo "#END#" >> $BAPF;
  fi
  
  echo "$DPFLAG
  
  export DEPLOYER_HOME=/home/zgy/hadoop-deployer/cdh4
  export SSH_PORT=$SSH_PORT
  
  export PATH=\$DEPLOYER_HOME/bin:\$PATH
  
  alias ssh='ssh -p \$SSH_PORT'
  alias scp='scp -P \$SSH_PORT'
  alias ccdp='cd \$DEPLOYER_HOME'
  
  " > $DPPF
}

unprofile()
{
  rm -f $DPPF
  cp $BAPF "$BAPF.$NOW8_6"
  # DPFLAG="# hadoop deployer profile - uc.cn"
  sed -i "/$DPFLAG/,/#END#/d" $BAPF
}
