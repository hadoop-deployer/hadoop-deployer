#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

heads=""
JH='#'

while read LINE; do
  char=${LINE:0:1}
  if [ "$char" != $JH ]
  then
    break;  
  fi
  if [ -z "$heads" ]; then
    heads="${LINE}"; 
  else
    heads="${heads}\n${LINE}"; 
  fi
done < $0

bn=`basename $0`
#echo $heads

function delete_head_annotation
{
  j=0
  while read LINE; do
    char=${LINE:0:1}
    #if [ "$char" != $JH -a "$char" != "{" ]
    if [ "$char" != $JH ]
    then
      break;
    fi
    j=$[j+1]
  done < $1
  sed -i "1,${j}d" $1
}

DIR=${1:-"."}
DIR=${DIR%/}

for f in `ls $DIR/*.sh|grep -v $bn`; do
  echo $f
  delete_head_annotation $f
  sed -i -e "1i\\${heads}" $f
done
