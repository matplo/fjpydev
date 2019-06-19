#!/bin/bash

unset PYTHONPATH
. ./local_pythia_install.sh
. ./local_fastjet_install.sh
recursivetools="$PWD/build/python/CMakeSwig/recursivetools"
pyfastjet="$PWD/build/python/CMakeSwig/fastjet"
# export PYTHONPATH=${PYTHONPATH}:${recursivetools}:${pyfastjet}
export PYTHONPATH=${PYTHONPATH}:$PWD/build/python/fjpy
