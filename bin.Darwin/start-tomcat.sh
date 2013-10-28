#!/bin/bash

echo "Using JRE_HOME $JRE_HOME"
CORE_DIR="$HOME/src/better-core"
TOMCAT="$HOME/my/toolbox/tomcat-6.0.18"
GRADLE_HOME="/opt/boxen/homebrew/bin/"

# clean and compile
cd $CORE_DIR && $GRADLE_HOME/gradle clean war
        
# start tomcat
$TOMCAT/bin/catalina.sh jpda start 
               
sleep 10s
