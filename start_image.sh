#!/bin/bash

docker run \
  -u $(cat /etc/passwd | grep "clang-jenkins" | cut -d":" -f3-4) \
  -d \
  --restart always \
  --privileged \
  -p 8080:8080 -p 50000:50000 \
  -p 8001:8001 -p 8002:8002 -p 8003:8003 -p 8004:8004 \
  -v /local/clang-jenkins/jenkins_home:/var/jenkins_home \
  --env JAVA_OPTS="-Dhudson.model.DirectoryBrowserSupport.CSP= -Dorg.jenkinsci.plugins.durabletask.BourneShellScript.HEARTBEAT_CHECK_INTERVAL=86400" \
  --env JENKINS_OPTS="--sessionTimeout=10080" \
  jenkins/clang 
