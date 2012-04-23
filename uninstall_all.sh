#!/bin/sh
main()
{
  . PUB.sh
  [ -f ./install_env.sh ] && : || die "install_env.sh file not exits";
  echo ">> uninstall hue"
  sh uninstall_hue.sh
  echo ">> uninstall hbase"
  sh uninstall_hbase.sh
  echo ">> uninstall hive"
  sh uninstall_hive.sh
  echo ">> uninstall hadoop"
  sh uninstall_hadoop.sh
}

#====
main
