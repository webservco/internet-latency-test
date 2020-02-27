#!/bin/bash

# webservco/internet-latency-test
# Test internet latency using the ping command and write the results in a CSV file.

P_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/" # program path

# Check external command
command -v ping >/dev/null 2>&1 || {
    echo >&2 "speedtest-cli not installed. Aborting.";
    return 1;
}

# Check if configuration file is present
if [ ! -f "${P_PATH}config.sh" ]; then
    echo "Configuration file is missing"
    return 1
fi

. "${P_PATH}config.sh" # load custom configuration

LOG_DATE=$(date '+%Y-%m-%d') # log file date format
LOG_FILE="${LOG_PATH}${LOG_NAME}-$LOG_DATE.csv" # log file name

mkdir -p $(dirname $LOG_FILE) # create log dir if not exists

# Default data
r_transmitted=0
r_received=0
r_loss=0
r_time=0
r_min=0
r_avg=0
r_max=0
r_mdev=0

RESULT=$(LC_ALL=C ping $PING_HOST -w $PING_TIME)

# Parse result

r_transmitted=$(echo "$RESULT" | grep 'transmitted' | awk '{print $1}')
r_received=$(echo "$RESULT" | grep 'transmitted' | awk '{print $4}')
r_loss=$(echo "$RESULT" | grep 'transmitted' | awk '{print $6}' | sed 's/%//')
r_time=$(echo "$RESULT" | grep 'transmitted' | awk '{print $10}' | sed 's/ms//')
r_min=$(echo "$RESULT" | grep 'rtt ' | awk '{print $4}' | awk -F "/" '{print $1}')
r_avg=$(echo "$RESULT" | grep 'rtt ' | awk '{print $4}' | awk -F "/" '{print $2}')
r_max=$(echo "$RESULT" | grep 'rtt ' | awk '{print $4}' | awk -F "/" '{print $3}')
r_mdev=$(echo "$RESULT" | grep 'rtt ' | awk '{print $4}' | awk -F "/" '{print $4}')

# If log file doesn't exist yet, write the header line
if [ ! -f $LOG_FILE ]; then
    echo "Date,Transmitted,Received,Loss,Time,Min,Avg,Max,Mdev" >> $LOG_FILE
fi

LOG_TIME=$(date '+%Y-%m-%dT%H:%M:%S') # log time format

#  Write result in log file
echo "$LOG_TIME,$r_transmitted,$r_received,$r_loss,$r_time,$r_min,$r_avg,$r_max,$r_mdev" >> $LOG_FILE
