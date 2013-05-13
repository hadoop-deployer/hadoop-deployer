#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01

. support/PUB.sh

for s in $NODES; do
  ssh $USER@$s " rm -f $HOME/.bash_profile.????????_??????; "
done
