#!/bin/env echo "Warning: this file should be sourced"
# zhaigy@ucweb.com
if [ "$PUB_HEAD_DEF" != "PUB_HEAD_DEF" ]; then
  #set -e
  shopt -s expand_aliases
  /bin/env
  #[ -f $HOME/.hadoop_profile ] && . $HOME/.hadoop_profile
  [ -f $HOME/.bash_profile ] && . $HOME/.bash_profile
  
  [ "$OLDDIR" == "" ] && OLDDIR=`pwd` ||:;
  [ "$DIR" == "" ] && DIR=`cd $(dirname $0);pwd` ||:;
  
  if [ `uname -m | sed -e 's/i.86/32/'` == '32' ]; then
    alias IS_32='true';
  else
    alias IS_32='false'
  fi

  show_head()
  {
    echo "========================================================================================="
    echo ""
    echo "@   @  @@@  @@@@   @@@   @@@  @@@@        @@@@  @@@@@ @@@@  @      @@@  @   @ @@@@@ @@@@"
    echo "@   @ @   @ @   @ @   @ @   @ @   @       @   @ @     @   @ @     @   @ @   @ @     @   @"
    echo "@   @ @   @ @   @ @   @ @   @ @   @       @   @ @     @   @ @     @   @  @ @  @     @   @"
    echo "@@@@@ @@@@@ @   @ @   @ @   @ @@@@        @   @ @@@@  @@@@  @     @   @   @   @@@@  @@@@"
    echo "@   @ @   @ @   @ @   @ @   @ @           @   @ @     @     @     @   @   @   @     @ @"
    echo "@   @ @   @ @   @ @   @ @   @ @           @   @ @     @     @     @   @   @   @     @  @"
    echo "@   @ @   @ @@@@   @@@   @@@  @           @@@@  @@@@@ @     @@@@@  @@@    @   @@@@@ @   @"
    echo ""
    echo "V0.2 by uc.cn 2012-06"
    echo ""
    echo "========================================================================================="
  }

  die() { [ $# -gt 0 ] && echo $@; exit -1; }
  var() { eval echo \$"$1"; }
  var_die() { [ "`var $1`" == "" ] && die "var $1 is not definded" ||:; }
  
  if [ "$DEPLOYER_HOME" == "" ]; then
    #DEPLOYER_HOME="$HOME/hadoop-deployer";
    DEPLOYER_HOME=`sh anchor.sh`;
  fi
  #var_die DEPLOYER_HOME;
  D=$DEPLOYER_HOME
  
  # $0 url.list.file
  download()
  {
    local dls=`cat $D/download.list.txt`
    mkdir -p $D/tar
    cd $D/tar
    for dl in $dls; do
      dl=`echo $dl|sed "s:\\s\\+::"`
      [ "${dl::1}" == "#" ] && continue ||:;
      wget --no-check-certificate -c $dl; 
    done
    cd $OLDDIR 
  }

  # $0 cmd
  check_tool()
  {
    [ -f "`which $1`" ] && echo "$1 is exists" || die "$1 is not exists"
  }

  [ -f $D/install_env.sh ] && . $D/install_env.sh 
  [ -f $D/install_zookeeper_env.sh ] && . $D/install_zookeeper_env.sh 
  
  nodes()
  {
    if [ -z "$DN" ]; then
      return true; #return true for not stop
    fi
    if [ -z "$NODE_HOSTS" ]; then
      local TMP_F="tmp_uniq_nodes.txt.tmp";
      :>$TMP_F
      for s in $DN; do
        echo $s >> $TMP_F;
      done
      echo $NN >> $TMP_F; 
      [ "$SNN" != "" ] && echo $SNN >> $TMP_F
      export NODE_HOSTS=`sort $TMP_F | uniq`
      rm -f $TMP_F
    fi
  }
  nodes;

  # $0 source target 
  rsync_all()
  {
    for s in $NODE_HOSTS; do
      [ `hostname` == "$s" ] && continue 
      echo ">> rsync to $s";
      rsync -a --exclude=.svn --exclude=.git --exclude=logs $1 -e "ssh -p $SSH_PORT" $s:$2;
    done
  }

  alias ssh="ssh -p $SSH_PORT"
  alias scp="scp -P $SSH_PORT"
  
  [ -e logs ] || mkdir logs
  [ -e tar ] || mkdir tar
  
  PUB_HEAD_DEF="PUB_HEAD_DEF"
fi

