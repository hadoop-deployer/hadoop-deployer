#!/usr/bin/env bash
# coding=utf-8
# zhaigy@ucweb.com
# 2012-09

PASS=$USER #user's login password
SSH_PORT=22
HADOOP_PORT_PREFIX=50

NN="host1"  #namenode's host,just one
SNN="host2" #second namenode's host,can be blank
DN="
host1
host2
host3
host4
host5
"

ZK_NODES="
host1
host2
host3
"
