1.将Template-Web-Monitor.xml导入zabbix

2.关联模板

3.将web_site_code_status.sh WEB.txt 放到客户端的/opt/scripts目录下，也可以根据需要修改目录

4.添加zabbix客户端配置文件，将web_site_discovery.conf 放到/etc/zabbix.d/目录

5.重启zabbix agent

若出现not supported：Timeout while executing a shell script 将zabbix agent的timeout时间加大
Timeout=30
