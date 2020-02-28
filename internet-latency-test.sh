#!/bin/bash

# webservco/internet-latency-test
# Test internet latency using the ping command and write the results in a CSV file.

p_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/" # program path

# Check external command
command -v ping >/dev/null 2>&1 || {
    echo >&2 "speedtest-cli not installed. Aborting.";
    return 1;
}

# Check if configuration file is present
if [ ! -f "${p_path}config.sh" ]; then
    echo "Configuration file is missing"
    return 1
fi

. "${p_path}config.sh" # load custom configuration

log_date=$(date '+%Y-%m-%d') # log file date format
log_file="${log_path}${log_name}-$log_date.csv" # log file name

mkdir -p $(dirname $log_file) # create log dir if not exists

result=$(LC_ALL=C ping $ping_host -w $ping_time)

# Parse result

r_message=''
r_transmitted=$( echo "$result" | grep -oP '\d+(?= packets transmitted)' )
[[ -z "$r_transmitted" ]] && { r_message=$(echo "$result"); }
r_received=$( echo "$result" | grep -oP '\d+(?= received)' )
r_errors=$( echo "$result" | grep -oP '\d+(?= errors)' )
[[ -z "$r_errors" ]] && { r_errors=0; }
r_loss=$( echo "$result" | grep -oP '\d+(?=% packet loss)' )
r_time=$( echo "$result" | grep -oP ".*time \K\d+" )
r_min=$(echo "$result" | grep 'rtt ' | awk '{print $4}' | awk -F "/" '{print $1}')
r_avg=$(echo "$result" | grep 'rtt ' | awk '{print $4}' | awk -F "/" '{print $2}')
r_max=$(echo "$result" | grep 'rtt ' | awk '{print $4}' | awk -F "/" '{print $3}')
r_mdev=$(echo "$result" | grep 'rtt ' | awk '{print $4}' | awk -F "/" '{print $4}')

# If log file doesn't exist yet, write the header line
if [ ! -f $log_file ]; then
    echo "Date,Transmitted,Received,Errors,Loss,Time,Min,Avg,Max,Mdev,Message" >> $log_file
fi

log_time=$(date '+%Y-%m-%dT%H:%M:%S') # log time format

#  Write result in log file
echo "$log_time,$r_transmitted,$r_received,$r_errors,$r_loss,$r_time,$r_min,$r_avg,$r_max,$r_mdev,\"$r_message\"" >> $log_file
