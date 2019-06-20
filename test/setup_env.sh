#!/bin/bash

function thisdir()
{
	SOURCE="${BASH_SOURCE[0]}"
	while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
	  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
	  SOURCE="$(readlink "$SOURCE")"
	  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
	done
	DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
	echo ${DIR}
}

SCRIPTPATH=$(thisdir)

unset PYTHONPATH
. ${SCRIPTPATH}/local_pythia_install.sh
. ${SCRIPTPATH}/local_fastjet_install.sh
# recursivetools="${SCRIPTPATH}/build/python/CMakeSwig/recursivetools"
# pyfastjet="${SCRIPTPATH}/build/python/CMakeSwig/fastjet"
# export PYTHONPATH=${PYTHONPATH}:${recursivetools}:${pyfastjet}
export PYTHONPATH=${PYTHONPATH}:${SCRIPTPATH}/build/python/fjpy
