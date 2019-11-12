#!/bin/bash

cd $WORKSPACE/codechecker
make clean
rm -fr venv
rm -fr build

# Create a Python virtualenv and set it as your environment.
make venv
source $PWD/venv/bin/activate

# Build and install a CodeChecker package.
make package
