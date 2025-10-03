#!/bin/bash

CONF_FILE="backup_conf.json"
#такая конструкция подходит чтобы проверять есть ли пакет в системе
if ! command -v jq &> /dev/bull; then
  echo "Error"
  exit 1
fi

BACKUP_COUNT=$(jq '.backups | length' "$CONFIG_FILE_JSON")

for (( i=0; i<BACKUP_COUNT; i++));  do
  BACKUP_NAME=$(jq -r ".backup[$i].backup_name" "$CONFIG_FILE_JSON")
  SOURCE_FOLDER=$(jq -r ".backup[$i].source_folder" "$CONFIG_FILE_JSON")
  TARGET_FOLDER=$(jq -r ".backup[$i].target_folder" "$CONFIG_FILE_JSON")

  echo "---Start backup: $BACKUP_NAME"
  
  if [ ! -d "$SOURCE_FOLDER" ]; then
    echo "---Skipping $BACKUP_NAME: Source folder $SOURCE_FOLDER dose not exist"
    continue #i=i+1
  fi
  TIMESTAMP=$(date +"%Y%m%d %H%M%S")
  BACKUP_FILE="$TARGET_FOLDER/$BACKUP_NAME-$TIMESTAMP.tar.gz"


  echo "Backing up $SOURCE FOLDER to SBACKUP FILE..."
  tar -czf "$BACKUP_FILE" C "$SOURCE_FOLDER"
  
  if [ $? -eq 0 ]; then
    echo "---Backup $BACKUP NAME completed successfully."  
  else
    echo "Backup SBACKUP NAME failed."
  fi
  
  echo "---Finish backup: SBACKUP NAME"
  
done
