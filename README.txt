本程序全部是shell脚本，可以快速安装部署Hadoop服务。
zhaigy@ucweb.com

说明:
1. 本程序可以安装Hadoop，Hive，HBase，HUE，并可安装配置
   LZO和Fuse-Dfs
2. 本程序必须在用户home目录下，安装后的程序也都是在用户
   的home目录下，即本安装是和用户紧密结合的，通常这个用
   户是hadoop
3. 本程序可以安装32位机，也可以安装64位机
4. 默认情况下，本程序会对集群做一些简单配置，安装机被配
   置成NN和JT，你可以在安装后修改配置文件
5. 本程序的目的是简化安装过程，相关的细节方面的配置，例
   如数据磁盘目录等，仍需要你配置 


必备条件:
1. 仅能用于linux系统
2. shell使用的是bash
3. 根据hadoop的要求，机器间通信时要使用host而不是ip，要
   求各个机器的host已经正确设置，请用hostname命令验证
4. 各个机器上，用于安装的用户名和密码必须一致
5. 必须有ssh，本程序会自动配置免密码登录
6. 安装的那台机器必须是集群中的一台，并且最好就是主节点
7. 安装时需要连接网络下载安装包，或者你手动下载好放到
   tar目录


安装hadoop:
1. 修改install_env.sh中配置，如果此文件不存在，会出提示要求
   逐个的输入，所以，你也可以把此文件删除，直接进行下一步
2. sh install_hadoop.sh


为了快速安装，最好先修改 install_env.sh ，然后运行上面的命令。
install_env.sh中内容是:
----------------------------------------------------
PASS=$USER #用户登录其它机器的密码
SSH_PORT=9922 #ssh服务端口

NN="platform30" #在哪台机器上安装NN，最好就是安装机
SNN=            #在哪台机器上安装SNN，空表示不安装
                #DN:在哪些机器上安装DN
DN="
platform31
platform32
platform33
platform34
"
----------------------------------------------------
默认启动后的端口是50***，你可以打开 deployer_env.sh 修改
HADOOP_PORT_PREFIX，也可以在安装后对个别的端口进行调整。


安装hive
sh install_hive.sh

默认是derby存储元数据
建议使用mysql，不过这个需要你自己安装mysql并对应的修改
hive-site.xml 中配置


安装hbase
sh install_hbase.sh


安装hue
sh install_hue.sh


安装全部
sh install_all.sh


非常重要
关于下载
download.test.list.txt文件中列举了全部要下载的tar文件，你可以修改成最快速的网址，
对于你不需要用的包也可以删除。
对于有一些不能直接下载的包，你需要手动下载并放到tar目录中，例如jdk包就是不能直接下载的
你可以从这里下载jdk：http://www.oracle.com/technetwork/java/javase/downloads/index.html
请注意要和操作系统匹配，如果你要安装的机器既有32位的，又有64位的，你需要两个版本都下载

