#!/bin/env echo "Warning: this file should be sourced"
if [ "$PUB_HEAD_DEF" != "PUB_HEAD_DEF" ]; then
  set -e
  DIR=`cd $(dirname $0);pwd`
  if [ `uname -m | sed -e 's/i.86/32/'` == '32' ]; then
    alias IS_32='true';
  else
    alias IS_32='false'
  fi
  PUB_HEAD_DEF="PUB_HEAD_DEF"

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
    echo "V0.1 by uc.cn 2012-04"
    echo ""
    echo "========================================================================================="
  }

  die() { [ "$#" -gt 0 ] && echo $@; exit; }
 
  # $0 url.list.file
  download()
  {
    #local dls=`cat ./download.list.txt`
    local dls=`cat $1`
    mkdir -p ./tar
    cd ./tar
    for dl in $dls; do wget -nv -c $dl; done
    cd .. 
  }

  # $0 cmd
  check_tool()
  {
    [ -f "`which $1`" ] && echo "$1 is exists" || die "$1 is not exists"
  }
fi

