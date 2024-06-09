#!/bin/bash

####################################################
# monitor_docker.sh - Monitoring of Docker Containers
#
# This Script monitors docker containers and shows an 
# alert if a container ist stopped or CPU is over threshold
# with an datto RMM alert.
#
# created 2024 by Jasper Golze - ITcares
#
####################################################

# Get the threshold from the command line argument
#threshold=$1
threshold=40

# Check if the threshold is a positive number
if ! [[ $threshold =~ ^[+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$ ]]; then
    echo "Threshold must be a positive number."
    exit 1
fi

echo "Threshold: $threshold"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Exiting."
    exit 1
fi

# Get docker stats
dStats=$(docker stats --no-stream --format "table {{.MemPerc}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.Name}}\t{{.ID}}" | sed -n '1!p')

# Get stopped Containers
dCStopped=$(docker ps -f "status=exited")

# Get the average CPU load
avg_cpu_load=$(awk '{print $1}' <(uptime | grep -o 'load average: .*' | cut -d ':' -f 2) | cut -d ',' -f 1)
echo "Average CPU Load: $avg_cpu_load"

# Get overall CPU usage
overall_cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')
echo "Overall CPU Usage: $overall_cpu_usage"

# Check if the average CPU load is greater than the threshold
if [ $(echo "$avg_cpu_load >= $threshold" | bc) -eq 1 ]; then
    echo "CPU load is above the threshold"

    # Get the top 5 containers contributing to the load
    top_containers=$(docker stats --no-stream --format "{{.Container}} {{.Name}} {{.CPUPerc}}" | sort -rnk 3 | head -n 5)
    echo "Top 5 containers:"
    echo "$top_containers"

    # Timestamp for output filename
    timestamp=$(date +"%Y%m%d-%H%M%S")
    output_file="cpu_load_report_${timestamp}.txt"

    # Write the overall CPU usage, top 5 containers, and top 50 processes to the output file
    echo "Overall CPU Usage: $overall_cpu_usage" > $output_file
    echo "" >> $output_file
    echo "Top 5 containers contributing to high CPU load ($avg_cpu_load%):" >> $output_file
    echo "$top_containers" >> $output_file
    echo "" >> $output_file
    echo "Top 50 processes on the host with file paths, sorted by CPU usage:" >> $output_file
    ps -eo pid,pcpu,pmem,comm,args --sort=-pcpu | head -n 51 | tail -n 50 >> $output_file

    # Send the report to Slack as an attachment if the webhook URL is provided
    
EOF
)
    fi
else
    echo "CPU load is below the threshold"
fi
