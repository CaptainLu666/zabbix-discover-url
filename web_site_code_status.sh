#!/bin/bash
# function:monitor tcp connect status from zabbix

IFS=$'\n'
web_site_discovery () {
#shell array
WEB_SITE=($(cat  /opt/scripts/WEB.txt|grep -v "^#"))
        printf '{\n'
        printf '\t"data":[\n'
for((i=0;i<${#WEB_SITE[@]};++i))
{
num=$(echo $((${#WEB_SITE[@]}-1)))
        if [ "$i" != ${num} ];
        then
        arg1=$(echo ${WEB_SITE[$i]}|awk '{print $1}')
        arg2=$(echo ${WEB_SITE[$i]}|awk '{print $2}')
            printf "\t\t{ \n"
            printf "\t\t\t\"{#SITENAME}\":\"$arg1\",\"{#PROXYIP}\":\"$arg2\"},\n"
        else
        arg1=$(echo ${WEB_SITE[$num]}|awk '{print $1}')
        arg2=$(echo ${WEB_SITE[$num]}|awk '{print $2}')
            printf  "\t\t{ \n"
            #printf  "\t\t\t\"{#SITENAME}\":\"${WEB_SITE[$num]}\"}]}\n"
            printf  "\t\t\t\"{#SITENAME}\":\"$arg1\",\"{#PROXYIP}\":\"$arg2\"}]}\n"
        fi
}
}

web_site_code () {
if [ "$2" == "" ]
then
    /usr/bin/curl --connect-timeout 5 -m 10 -o /dev/null -s -w %{http_code} http://$1
else
    /usr/bin/curl --connect-timeout 5 -m 10 -o /dev/null -s -w %{http_code} http://$1 -x $2:80
fi
}

case "$1" in
web_site_discovery)
web_site_discovery
;;
web_site_code)
web_site_code $2 $3
;;
*)

echo "Usage:$0 {web_site_discovery|web_site_code [URL]}"
;;
esac
