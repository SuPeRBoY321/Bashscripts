#This file is intended for the basic configuration of the created workstation.
#!/bin/bash

if [ "$EUID" -ne 0]; then 
  echo "ERROR: This script must be run as root"
  exit 1
fi
