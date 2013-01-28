#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09
#
# 依赖如下目录
# DP_HOME  #本程序根目录
# OLD_DIR  #启动脚本时的目录，可以不设置
# PREFIX   #安装Hadoop的目标目录

if [ "$PUB_HEAD_DEF" != "PUB_HEAD_DEF" ]; then
  #错误即时退出
  set -e #
  #运行脚本中使用别名
  shopt -s expand_aliases 
  [ -f $HOME/.bash_profile ] && . $HOME/.bash_profile

  if [ `uname -m | sed -e 's/i.86/32/'` == '32' ]; then
    alias IS_32='true';
  else
    alias IS_32='false'
  fi
  
  if [ $0 != "bash" ]; then 
    AP=`basename ${0%.sh}`; 
  fi

  already_show_head="false";
  show_head()
  {
    if [ "$already_show_head" == "true" ]; then
      return 0;
    fi
    echo "==========Hadoop Deployer 0.7=========="
    if [ ! -z "$AP" ]; then 
      echo "==$AP";
    fi
    already_show_head="true"
    export already_show_head
  }

  die() { [ $# -gt 0 ] && echo "$@"; if [ "X$OLD_DIR" != "X" ]; then cd $OLD_DIR; fi; exit -1; }
  var() { eval echo \$"$1"; }
  #变量不存在或者为空即退出
  var_die() { [ "`var $1`" == "" ] && die "var $1 is not definded" ||:; }
  file_die() { if [ -e "$1" ]; then msg=${2:-"file $1 is already exists"}; die "$msg"; fi }
  notfile_die() { if [ ! -e "$1" ]; then msg=${2:-"file $1 is not exists"}; die "$msg"; fi }
  #var_def() { [ "X$1" == "X" ] && true || false; } 

  [ "$DEPLOYER_HOME" == "" ] || DP_HOME=$DEPLOYER_HOME;
  var_die DP_HOME
  
  D=$DP_HOME
  ME=`hostname`
  NOW8_6=`date +"%Y%m%d_%H%M%S"`

  # load all config
  [ -f $D/config_deployer.sh ] && . $D/config_deployer.sh
  [ -f $D/config_zookeeper.sh ] && . $D/config_zookeeper.sh
  [ -f $D/config_hadoop.sh ] && . $D/config_hadoop.sh
  [ -f $D/config_hbase.sh ] && . $D/config_hbase.sh
  [ -f $D/config_mysql.sh ] && . $D/config_mysql.sh
  [ -f $D/config_hive.sh ] && . $D/config_hive.sh
  
  [ -z "$SSH_PORT" ] || { alias ssh="ssh -p $SSH_PORT"; alias scp="scp -P $SSH_PORT"; }

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
    if alias $1 > /dev/null 2>&1 || [ -f "`which $1`" ]; then echo "$1 is exists";
    else die "$1 is not exists";
    fi
  }

  # $0 host source target
  rsync_to()
  {
    # 如果rsync自己会报错
    [ "$ME" == "$1" ] && return
    rsync -a --exclude=.svn --exclude=.git --exclude=logs $2 -e "ssh -p $SSH_PORT" $1:$3;
  }
 
  # $0 host dir
  same_to() { [ ! -e $2 ] && return 1; dir=`cd $2/..;pwd`; rsync_to $1 $2 $dir; }

  # $0 hosts source target 
  rsync_to_all() { for s in $1; do rsync_to $s $2 $3; done; }


  # $0 xmlfile name value
  xml_set() { sed -r "/<name>$2<\/name>/{ n; s#<value>.*</value>#<value>$3</value>#; }" -i $1; }
  find_tar() { find $D/tars -regex ".*/$1\(\.tar\)?\.gz" -printf "%f\n"; }
 

  PUB_HEAD_DEF="PUB_HEAD_DEF"
fi

