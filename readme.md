# Docker Stats & CPU Load Monitor

This script monitors Status & CPU load on a system running Docker and generates an alert for datto RMM if container is stopped or the load exceeds a specified threshold. It displays the top 5 containers contributing to high CPU load, overall CPU usage, and top 50 processes on the host.

## Requirements

- Docker must be installed on the system.
- Should be used as a datto RMM component.

## Usage

1. Set up the script as a datto component with a policy for the docker host.
2. Provide the threshold as a mandatory argument when running the component.

## License

This project is licensed under the MIT License.

## Disclaimer

Use this script at your own risk. The author and contributors are not responsible for any damages or issues caused by the use of this script.
