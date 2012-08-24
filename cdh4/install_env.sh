# UTF-8
# 用户密码，用于远程登录其它机器
PASS=$USER #user's login password
SSH_PORT=22
# Hadoop的众多服务端口的前缀，最多2位数，建议2位数
HADOOP_PORT_PREFIX=50

# Active NN和Standby NN，最少一个，最多两个
NN="host1 host2"

# 作为DFS数据节点的机器
DN="
host3
host4
host5
host6
"

# ZooKeeper服务器，新版本会配置成自动切换热备模式，ZK是必须的。
# 本脚本会根据此配置安装ZK
ZK_NODES="
host3
host4
host5
"

# YARN 
# 暂不支持YARN安装
RM=""

# MRv1
# 暂不支持MRv1安装
JT=""

