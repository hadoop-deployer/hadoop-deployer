mysql -u root -p${MYSQL_ROOT_PASS} <<EOS
CREATE DATABASE if not exists hive_metastore;
GRANT ALL PRIVILEGES ON hive_metastore.* TO 'hive'@'%' IDENTIFIED BY 'hive' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON hive_metastore.* TO 'hive'@'localhost' IDENTIFIED BY 'hive' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON hive_metastore.* TO 'hive'@'127.0.0.1' IDENTIFIED BY 'hive' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOS
