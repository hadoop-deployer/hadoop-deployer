#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

. support/PUB.sh

for s in $NODES; do
  ssh $USER@$s " rm -f $HOME/.bash_profile.????????_??????; "
done
