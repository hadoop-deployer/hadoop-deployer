#!/bin/sh
TAR=hadoop-deployer.tar.gz
rm -rf ./$TAR
tar -czvf $TAR ./ --exclude .git --exclude tars --exclude logs --exclude $TAR
