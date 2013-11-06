#!/bin/bash
TOMCAT="$HOME/my/toolbox/tomcat-6.0.18"
echo "Stopping Tomcat from $TOMCAT"
        
# start tomcat
$TOMCAT/bin/catalina.sh stop 
               
sleep 10s

ps aux|grep tomcat
