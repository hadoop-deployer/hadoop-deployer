PASS=zgy
SSH_PORT=9922

NN="platform30"
SNN=
DN="
platform31
platform32
platform33
platform34
"

#######################
# please don't modify #
#######################

nodes()
{
  local TMP_F="tmp_uniq_nodes.txt.tmp";
  :>$TMP_F
  for s in $DN; do
    echo $s >> $TMP_F;
  done
  echo $NN >> $TMP_F; 
  [ "$SNN" != "" ] && echo $SNN >> $TMP_F
  export NODE_HOSTS=`sort $TMP_F | uniq`
  rm -f $TMP_F
}

nodes;

# $0 source target 
rsync_all()
{
  for s in $NODE_HOSTS; do
    [ `hostname` == "$s" ] && continue 
    echo ">> rsync to $s";
    rsync -a --exclude=.svn --exclude=.git --exclude=logs $1 -e "ssh -p $SSH_PORT" $s:$2;
  done
}

alias ssh="ssh -p $SSH_PORT"

