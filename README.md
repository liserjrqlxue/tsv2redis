# tsv2redis
tsv文件hash结构redis化



# 使用说明
## 安装依赖
1.	安装perl 5（参考官网，一般 Linux发行版已有）
2.	安装Redis::Client模块
`cpan install Redis::Client 或 cpanm Redis::Client`

## 下载部署源码
1.	从github下载
`git clone https://github.com/liserjrqlxue/tsv2redis.git `
2.	直接解压源码包
`tar avxf tsv2redis.tar.gz`

进入tsv2redis主目录`cd tsv2redis`

## 下载安装Redis服务器
1.	[从官方渠道](https://redis.io/download#installation)
```
wget http://download.redis.io/releases/redis-5.0.7.tar.gz 
tar xzf redis-5.0.7.tar.gz
ln -sf redis-5.0.7 Redis
cd redis
make
```
2.	从github直接下载release
```
wget https://github.com/antirez/redis/archive/5.0.7.tar.gz 
tar xzf 5.0.7.tar.gz
ln -sf redis-5.0.7 Redis
cd redis
make
```
3.	从github clone最新源码
```
git clone https://github.com/antirez/redis 
cd redis
make
```
返回tsv2redis主目录 `cd ..`

## 配置启动主从服务端
* 启动master Redis server  
`./redis/src/Redis-server master.conf`
* 启动slave Redis server  
`./redis/src/Redis-server slave6380.conf`

可直接运行脚本`sh init.sh`

## TSV数据库文件传入Redis服务器（覆盖更新）
`perl tsv2redis.pl <hashName> <db.tsv> <keyIndex>`  
* `hashName`是存入Redis服务器的hash结构的名称
* `db.tsv`是TSV格式的数据库文件
* `keyIndex`是构建唯一查询ID需要拼接的列的序号（从0开始）

示例如下：
1.	`all_native_snp20191206.gff`  
该数据库以第0列作为查询ID，运行命令如下：  
`perl tsv2redis.pl SEQ2000_all_native_snp all_native_snp20191206.gff 0`
2.	`all_native_indel20191206.gff`  
数据库以第0、1、2、3列拼接作为查询ID，运行命令如下：  
`perl tsv2redis.pl SEQ2000_all_native_indel all_native_indel20191206.gff 0,1,2,3`
 
示例可直接运行脚本 `sh update.sh`

## 查询测试
1.	redis-cli查询
    1.	`./redis/src/redis-cli` 登陆master服务器或者`./redis/src/redis-cli -p 6380`登陆salve服务器
    2.	通过`HLEN <hashName>`查询数据条目验证上传数据量是否一致  
`HLEN SEQ2000_all_native_snp`  
`HLEN SEQ2000_all_native_indel`  
    3.	通过`HGET <hashName> <keyID>`查询数据库内容  
`HGET SEQ2000_all_native_snp chr1_230846012_G_T`  
`HGET SEQ2000_all_native_indel chr7_100383282_delT_Het`  

    以上操作可以运行测试用例`./redis/src/redis-cli <test.redids.cli`  
    或者脚本`sh test.sh`

2.	构建API查询  
示例脚本`perl query.redis.pl <hashName>`，然后通过管道或者交互式输入`keyID`  
`cat query.indel.list |perl query.redis.pl SEQ2000_all_native_indel`  
`cat query.snp.list |perl query.redis.pl SEQ2000_all_native_snp`  
示例可以直接运行脚本sh query.sh

## 保存并关闭master服务器
因为Redis服务器是开放式，没有用户验证等操作，为避免数据库被污染，使用主从服务器模式，将主服务器（master）配置在安全受控的节点，只开启本地访问模式，从服务器（slave）去除配置命令，启动master服务器更新完数据后，等待slave服务器同步完成后关闭master服务器使得slave服务器变成只读模式。
备份master服务器：`echo save |./redis/src/redis-cli`
备份slave服务器：`echo save |./redis/src/redis-cli -p 6380`
关闭master服务器：`echo shutdown |./redis/src/redis-cli`

## 出错和恢复
1. 从服务器异常中断后重启即可
2. 如数据丢失，开启主服务器同步数据后关闭主服务器
3. 其他异常请提报[github issue](https://github.com/liserjrqlxue/tsv2redis/issues)

## 运行表与运行步骤
序号	|命令	|说明
-----|----|-----
1	|sh init.sh	|启动Redis服务器
2	|sh update.sh	|更新Redis数据库内容
3	|sh test.sh	|测试Redis数据库
4	|sh query.sh	|查询Redis数据库内容
5	|sh shutdown.sh	|关闭Redis master服务器

