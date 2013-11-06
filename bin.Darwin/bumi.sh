#!/bin/bash
BUMI="/Library/CloudBackup/DS-User"
echo "Starting BUMI DS-User from $BUMI"
        
# start
nohup $BUMI/DS-User.command
               
