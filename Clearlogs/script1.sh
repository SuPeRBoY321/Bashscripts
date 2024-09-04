#!/bin/bash
#Root rights are required for the script to work.

cd /var/log
cat /dev/null > messages
cat /dev/null > wtmp
echo "Log file clear."

