#!/bin/bash
# Pass columns and lines, so terminal will not be fcked up
docker exec -ti $(docker ps -q) /bin/bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
