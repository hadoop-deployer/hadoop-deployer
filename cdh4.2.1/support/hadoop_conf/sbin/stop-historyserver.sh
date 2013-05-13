#!/usr/bin/env bash

bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`

"$bin"/mr-jobhistory-daemon.sh stop historyserver
