#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy#ucweb.com
# Q Q: 3 0 4 4 2 8 7 6 8
# Data:   2013-01

. support/PUB.sh

for s in $NODES; do
  ssh $USER@$s " rm -f $HOME/.bash_profile.????????_??????; "
done
