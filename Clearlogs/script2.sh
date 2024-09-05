#!/bin/bash
# cleanup, version 2
# Root rights are required for the script to work.

LOG_DIR=/var/log
ROOT_UID=0     # Only the user with $UID 0 has root privileges.
LINES=20       # The default number of rows to save.
E_XCD=66       # Is it impossible to change the directory?
E_NOTROOT=67   # A sign of the absence of root privileges.


if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Root rights are required for the script to work."
  exit $E_NOTROOT
fi

if [ -n "$1" ]
# Checking for the presence of a command line argument.
then
  lines=$1
else
  lines=$LINES # The default value if the number is not specified on the command line
fi

cd $LOG_DIR

if [ `pwd` != "$LOG_DIR" ]  # or   if [ "$PWD" != "$LOG_DIR" ]
                            # not in /var/log?
then
  echo "It is impossible to go to the catalog $LOG_DIR."
  exit $E_XCD
fi  # Checking the directory before clearing the log files.

tail -$lines messages > mesg.temp # Save the last lines in a log file.
mv mesg.temp messages


# cat /dev/null > messages
#* This command is no longer necessary, since the cleanup is performed above.

cat /dev/null > wtmp  #  the commands ': > wtmp' and '> wtmp' have the same effect.
echo "Лог-файлы очищены."

exit 0
#  Return 0
