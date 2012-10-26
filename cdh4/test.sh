#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

sed -r "/# The java implementation to use./i\\shopt -s expand_aliases" -i ttt.txt
cat ttt.txt
rm -f ttt.txt
