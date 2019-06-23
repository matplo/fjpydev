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
# . ${SCRIPTPATH}/local_hepmc3_install.sh
. ${SCRIPTPATH}/local_hepmc2_install.sh
. ${SCRIPTPATH}/local_pythia_install.sh reconfigure
. ${SCRIPTPATH}/local_fastjet_install.sh
# recursivetools="${SCRIPTPATH}/build/python/CMakeSwig/recursivetools"
# pyfastjet="${SCRIPTPATH}/build/python/CMakeSwig/fastjet"
# export PYTHONPATH=${PYTHONPATH}:${recursivetools}:${pyfastjet}

unset PYTHONPATH
python_version=$(python3 --version | cut -f 2 -d' ' | cut -f 1-2 -d.)
export PYTHONPATH=${PYTHONPATH}:${fjdirinst}/lib/python${python_version}/site-packages
export PYTHONPATH=${PYTHONPATH}:${HEPMC2_DIR}/lib
export PYTHONPATH=${PYTHONPATH}:${PYTHIA_DIR}/lib
export PYTHONPATH=${PYTHONPATH}:${SCRIPTPATH}/build/python/fjpy
