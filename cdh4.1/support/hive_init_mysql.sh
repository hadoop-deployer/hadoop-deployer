mysql -u root -p${MYSQL_ROOT_PASS} <<EOS
CREATE DATABASE if not exists hive_metastore;
use hive_metastore;
SOURCE $HOME/hive/scripts/metastore/upgrade/mysql/hive-schema-0.9.0.mysql.sql;
GRANT ALL PRIVILEGES ON hive_metastore.* TO 'hive'@'%' IDENTIFIED BY 'hive' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON hive_metastore.* TO 'hive'@'localhost' IDENTIFIED BY 'hive' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON hive_metastore.* TO 'hive'@'127.0.0.1' IDENTIFIED BY 'hive' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON hive_metastore.* TO 'hive'@'$ME' IDENTIFIED BY 'hive' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOS
