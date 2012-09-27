#!/usr/bin/env bash
# coding=utf-8
# zhaigy@ucweb.com
# 2012-09

TAR=hadoop-deployer.tar.gz
rm -f ./$TAR
tar -czvf $TAR ./ --exclude .git --exclude logs --exclude $TAR
