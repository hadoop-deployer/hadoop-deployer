#!/bin/env echo "Warning: this file should be sourced"
# zhaigy@ucweb.com
if [ "$PUB_HEAD_DEF" != "PUB_HEAD_DEF" ]; then
  set -e #错误即时退出
  shopt -s expand_aliases
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
    echo "V0.6 by uc.cn 2012-08"
    echo ""
    echo "========================================================================================="
  }

  die() { [ $# -gt 0 ] && echo $@; exit -1; }
  var() { eval echo \$"$1"; }
  var_die() { [ "`var $1`" == "" ] && die "var $1 is not definded" ||:; }
  file_die() { [ ! -e "$1" ] && die "file $1 is not exists" ||:; }
 
  # $0 var_name 
  var_def() { [ "X$1" == "X" ] && true || false; } 

  if [ "$DEPLOYER_HOME" == "" ]; then
    file_die support/anchor.sh
    DEPLOYER_HOME=$DIR
    #DEPLOYER_HOME=`sh anchor.sh`;
  fi
  
  D=$DEPLOYER_HOME
  ME=`hostname`
  NOW8_6=`date +"%Y%m%d_%H%M%S"`

  # load all config
  [ -f $D/config_deployer.sh ] && . $D/config_deployer.sh

  # $0 url.list.file
  download()
  {
    local dls=`cat $D/download.list.txt`
    mkdir -p $D/tars
    cd $D/tars
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
    if alias $1 > /dev/null 2>&1 || [ -f "`which $1`" ]; then
      echo "$1 is exists";
    else 
      die "$1 is not exists"
    fi
  }

#  [ -f $D/install_env.sh ] && . $D/install_env.sh 
  
#  nodes()
#  {
#    if [ -z "$DN" ]; then
#      return true; #return true for not stop
#    fi
#    if [ -z "$NODE_HOSTS" ]; then
#      local TMP_F="tmp_uniq_nodes.txt.tmp";
#      :>$TMP_F
#      for s in $DN; do
#        echo $s >> $TMP_F;
#      done
#      echo $NN >> $TMP_F; 
#      [ "$SNN" != "" ] && echo $SNN >> $TMP_F
#      export NODE_HOSTS=`sort $TMP_F | uniq`
#      rm -f $TMP_F
#    fi
#  }
#  nodes;

  # $0 source target 
#  rsync_all()
#  {
#    #for s in $NODE_HOSTS; do
#    for s in $NODES; do
#      [ `hostname` == "$s" ] && continue 
#      echo ">> rsync to $s";
#      rsync -a --exclude=.svn --exclude=.git --exclude=logs $1 -e "ssh -p $SSH_PORT" $s:$2;
#    done
#  }

  # $0 host source target
  rsync_to()
  {
    # 如果rsync自己会报错
    [ "$ME" == "$1" ] && return
    echo ">> rsync to $1";
    rsync -a --exclude=.svn --exclude=.git --exclude=logs $2 -e "ssh -p $SSH_PORT" $1:$3;
  }
 
  # $0 host dir
  same_to()
  {
    [ ! -e $2 ] && return 1
    dir=`cd $2/..;pwd`
    rsync_to $1 $dir 
  }

  # $0 hosts source target 
  rsync_to_all()
  {
    for s in $1; do
      rsync_to $s $2 $3
    done
  }

  [ -z "$SSH_PORT" ] || { alias ssh="ssh -p $SSH_PORT"; alias scp="scp -P $SSH_PORT"; }

  PUB_HEAD_DEF="PUB_HEAD_DEF"
fi

