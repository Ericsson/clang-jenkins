#!/bin/bash
codechecker_home=$1
PORT=$2
codechecker_package=$codechecker_home/build/CodeChecker

if [ ! -d "$codechecker_home/venv" ]; then
  virtualenv $codechecker_home/venv
fi
. $codechecker_home/venv/bin/activate
#pip install -r $codechecker_home/analyzer/requirements_py/dev/requirements.txt

function start() {
    echo CodeChecker server not running, starting ...
    #rm -fr $JENKINS_HOME/.codechecker.instances.json
    #rm -fr $JENKINS_HOME/.codechecker*.json
    #rm -fr $JENKINS_HOME/.codechecker*
    rm -fr $WORKSPACE/.codechecker*
    # # Jenkins kills every process at the end of a job, however we want to keep alive the server.
    #BUILD_ID=dontKillMe JENKINS_NODE_COOKIE=dontKillMe $codechecker_package/bin/CodeChecker server --port $PORT --workspace $WORKSPACE &
    BUILD_ID=dontKillMe JENKINS_NODE_COOKIE=dontKillMe $codechecker_package/bin/CodeChecker server --port $PORT --workspace $WORKSPACE --not-host-only &
}

$codechecker_package/bin/CodeChecker server --list | grep $PORT
if [ $? -eq 0 ]; then
    echo 'According to "CodeChecker server --list" the server is already running.'
    # Double check
    netstat -plnt | grep ":$PORT.*LISTEN"
    if [ $? -eq 0 ]; then
        echo 'According to "netstat" the server is already running.'
    else
        start
    fi
else
    start
fi

