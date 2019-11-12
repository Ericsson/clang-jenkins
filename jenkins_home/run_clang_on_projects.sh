#!/bin/bash

#--- Parameters
script_path=$1
codechecker_home=$2
BUILD_TYPE=$3
CSA_CONFIG=$4
THREADS=$5
shift
shift
shift
shift
shift
REST=$@

export ASAN_OPTIONS=detect_leaks=0
export ASAN_SYMBOLIZER_PATH=/usr/lib/llvm-4.0/bin/llvm-symbolizer
codechecker=$codechecker_home/build/CodeChecker
. $codechecker_home/venv/bin/activate
export PATH=$codechecker/bin:$WORKSPACE/build/$BUILD_TYPE/bin/:$WORKSPACE/clang/utils/analyzer/:$PATH
# Needed for run_experiments.py
pip install enum enum34 plotly
python $script_path/ctu_pipeline_aux/csa-testbench/run_experiments.py --config $CSA_CONFIG --jobs $THREADS $REST
