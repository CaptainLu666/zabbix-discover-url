#!/bin/bash

UrlFile="/opt/scripts/WEB.txt"
IFS=$'\n'

web_site_discovery () {
    WEB_SITE=($(cat $UrlFile|grep -v "^#"))
    printf '{\n'
    printf '\t"data":[\n'
    num=${#WEB_SITE[@]}
    for site in ${WEB_SITE[@]}
    do
        num=$(( $num - 1 ))
        url=$(echo $site|awk '{print $1}')
        ip=$(echo $site|awk '{print $2}')
        if [ $num -ne 0 ] ; then
            printf "\t\t{\"{#SITENAME}\":\""%s"\",\"{#PROXYIP}\":\""${ip}"\"},\n" ${url}
        else
            printf "\t\t{\"{#SITENAME}\":\""%s"\",\"{#PROXYIP}\":\""${ip}"\"}\n" ${url}
            printf '\t]\n'
            printf '}\n'
        fi
    done
}

web_site_code () {
    if [ "$2" == "" ]; then
        curl -s --connect-timeout 2 -m 4 -o /dev/null -w %{http_code} "$1"
    elif echo $2 |grep ':' &>/dev/null ; then
        curl -s --connect-timeout 2 -m 4 -o /dev/null -w %{http_code} "$1" -x $2
    else
        curl -s --connect-timeout 2 -m 4 -o /dev/null -w %{http_code} "$1" -x $2:80
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
