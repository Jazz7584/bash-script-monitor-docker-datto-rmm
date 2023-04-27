# CPU Load Monitor

This script monitors the average CPU load on a system with Docker installed. If the load exceeds a specified threshold, it will generate a report containing the top 5 containers contributing to the high CPU load and the top 50 processes on the host, sorted by CPU usage. The report can be sent to a Slack channel as an attachment using a Slack webhook URL.

## Requirements

- Docker must be installed on the system.
- Slack webhook URL (optional) for sending reports to a Slack channel.

## Usage

1. Set up the script to run periodically using cron or another scheduling tool.
2. Provide the threshold as a mandatory argument when running the script.
3. Optionally, provide a Slack webhook URL as a second argument to send reports to a Slack channel.

```bash
./monitor_cpu_load.sh <threshold> [slack_webhook]
```

Example:

```bash
./monitor_cpu_load.sh 40 "https://hooks.slack.com/services/your-webhook-url"
```

Example cron job:

```bash
*/5 * * * * /bin/bash /path/to/monitor_cpu_load.sh 40 "https://hooks.slack.com/services/your-webhook-url"
```:

## License

This project is licensed under the MIT License.

## Disclaimer

Use this script at your own risk. The author and contributors are not responsible for any damages or issues caused by the use of this script.
