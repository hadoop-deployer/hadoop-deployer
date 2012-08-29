# UTF-8

# Hadoop的众多服务端口的前缀，最多2位数，建议2位数
HADOOP_PORT_PREFIX=$PORT_PREFIX

# Active NN和Standby NN，最少一个，最多两个
# 这里及以下设定的所有host值，都必须是在config_deployer中指定的
NAME_NODES="platform30 platform31"

# 作为DFS数据节点的机器
DATA_NODES="
platform30
platform31
platform32
platform33
platform34
"

# YARN 
# 暂不支持YARN安装
RM=""

# MRv1
# 暂不支持MRv1安装
JT=""


# 用于支持，不是配置项，不要修改
#------------------------------------------------------------------------------
# 计算实际的Hadoop节点，排除重复
if [ -z "$HADOOP_NODES" ]; then
  local TMP_F="tmp_uniq_nodes.txt.tmp";
  :>$TMP_F
  for s in $DATA_NODES; do
    echo $s >> $TMP_F;
  done
  for s in $NAME_NODES; do
    echo $s >> $TMP_F;
  done
  export HADOOP_NODES=`sort $TMP_F | uniq`
  rm -f $TMP_F
fi
#------------------------------------------------------------------------------

