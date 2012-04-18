#!/bin/sh
TAR=hadoop-deployer.tar.gz
rm -rf ./$TAR
tar -czvf $TAR ./ --exclude .git --exclude tar --exclude logs --exclude $TAR
