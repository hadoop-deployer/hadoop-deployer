#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09
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

  already_show_head="false";
  show_head()
  {
    if [ "$already_show_head" == "true" ]; then
      return 0;
    fi
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
    echo "V0.7 by uc.cn 2013-01"
    echo ""
    echo "========================================================================================="
    already_show_head="true"
  }
  show_head()
  {
    echo "HEAD========="
  }

  die() { [ $# -gt 0 ] && echo $@; exit -1; }
  var() { eval echo \$"$1"; }
  var_die() { [ "`var $1`" == "" ] && die "var $1 is not definded" ||:; }
  file_die() { if [ -e "$1" ]; then cd $OLD_DIR; msg=${2:-"file $1 is already exists"}; die $msg; fi }
  notfile_die() { if [ ! -e "$1" ]; then cd $OLD_DIR; msg=${2:-"file $1 is not exists"}; die $msg; fi }
 
  # $0 var_name 
  var_def() { [ "X$1" == "X" ] && true || false; } 

  if [ "$DEPLOYER_HOME" == "" ]; then
    DEPLOYER_HOME=$DIR
  fi
  
  D=$DEPLOYER_HOME
  ME=`hostname`
  NOW8_6=`date +"%Y%m%d_%H%M%S"`

  # load all config
  [ -f $D/config_deployer.sh ] && . $D/config_deployer.sh
  [ -f $D/config_zookeeper.sh ] && . $D/config_zookeeper.sh
  [ -f $D/config_hadoop.sh ] && . $D/config_hadoop.sh
  [ -f $D/config_hbase.sh ] && . $D/config_hbase.sh
  [ -f $D/config_hive.sh ] && . $D/config_hive.sh

  # $0 url.list.file
  download()
  {
    local dls=`cat $D/download.list.txt`
    cd tars
    for dl in $dls; do
      #删除空格
      dl=`echo $dl|sed "s:\\s\\+::"`
      #跳过注释
      [ "${dl::1}" == "#" ] && continue ||:;
      wget --no-check-certificate -c $dl; 
    done
    cd ..
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
    rsync_to $1 $2 $dir 
  }

  # $0 hosts source target 
  rsync_to_all()
  {
    for s in $1; do
      rsync_to $s $2 $3
    done
  }

  [ -z "$SSH_PORT" ] || { alias ssh="ssh -p $SSH_PORT"; alias scp="scp -P $SSH_PORT"; }

  # $0 xmlfile name value
  xml_set()
  {
    sed -r "/<name>$2<\/name>/{ n; s#<value>.*</value>#<value>$3</value>#; }" -i $1;
  }
  
  find_tar()
  {
    #find $D/tars -regex ".*/$1-.*(\.tar)\.gz" -printf "%f\n" 
    find $D/tars -regex ".*/$1\(\.tar\)?\.gz" -printf "%f\n" 
  }

  PUB_HEAD_DEF="PUB_HEAD_DEF"
fi

