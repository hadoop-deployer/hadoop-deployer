# UTF-8

# HBase的众多服务端口的前缀，最多2位数，建议2位数
HBASE_PORT_PREFIX=$PORT_PREFIX

# Active NN和Standby NN，最少一个，最多两个
# 这里及以下设定的所有host值，都必须是在config_deployer中指定的
MASTER_NODE="platform30"
BACKUP_NODES="platfrom31 platfrom32"

# 作为Region Server节点的机器
RS_NODES="
platform30
platform31
platform32
platform33
platform34
"

# 用于支持，不是配置项，不要修改
#------------------------------------------------------------------------------
if [ -z "$MASTER_NODES" ]; then
  MASTER_NODES="$MASTER_NODE $BACKUP_NODES"
fi
#------------------------------------------------------------------------------

