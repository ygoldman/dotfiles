#!/bin/bash
export JRE_HOME="/Library/Java/Home"
echo "Using JRE_HOME=$JRE_HOME"
echo "Using Tomcat from $TOMCAT_HOME"
APP_NAME=$1
APP_VERSION=$2

CORE_DIR="$HOME/src/$APP_NAME"
TOMCAT="$HOME/my/toolbox/tomcat-6.0.18"
GRADLE_HOME="/opt/boxen/homebrew/bin/"

# clean and compile
cd $CORE_DIR && $GRADLE_HOME/gradle clean war -PcurrentVersion=$APP_VERSION
        
# start tomcat
$TOMCAT/bin/catalina.sh jpda start 
               
sleep 10s
