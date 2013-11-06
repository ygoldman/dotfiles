#!/bin/bash
TOMCAT="$HOME/my/toolbox/tomcat-6.0.18"
echo "Starting Tomcat from $TOMCAT"
        
# start tomcat
$TOMCAT/bin/catalina.sh jpda start 
               
sleep 10s

ps aux|grep tomcat