#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy#ucweb.com
# Q Q: 3 0 4 4 2 8 7 6 8
# Data:   2013-01

sed -r "/# The java implementation to use./i\\shopt -s expand_aliases" -i ttt.txt
cat ttt.txt
rm -f ttt.txt
