#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09
TAR=hadoop-deployer.tar.gz
rm -rf ./$TAR
tar -czvf $TAR ../ --exclude .git --exclude tars --exclude logs --exclude $TAR
