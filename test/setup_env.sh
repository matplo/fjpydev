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
# . ${SCRIPTPATH}/local_pythia_install.sh
# . ${SCRIPTPATH}/local_hepmc3_install.sh
# . ${SCRIPTPATH}/local_hepmc2_install.sh
. ${SCRIPTPATH}/local_hepmc2_install_cmake.sh
. ${SCRIPTPATH}/local_lhapdf_install.sh
. ${SCRIPTPATH}/local_pythia_install.sh
# . ${SCRIPTPATH}/local_pythia_install.sh reconfigure
. ${SCRIPTPATH}/local_fastjet_install.sh
# recursivetools="${SCRIPTPATH}/build/python/CMakeSwig/recursivetools"
# pyfastjet="${SCRIPTPATH}/build/python/CMakeSwig/fastjet"
# export PYTHONPATH=${PYTHONPATH}:${recursivetools}:${pyfastjet}

python_version=$(python3 --version | cut -f 2 -d' ' | cut -f 1-2 -d.)
export PYTHONPATH=${PYTHONPATH}:${FASTJET_DIR}/lib/python${python_version}/site-packages
export PYTHONPATH=${PYTHONPATH}:${HEPMC2_DIR}/lib
export PYTHONPATH=${PYTHONPATH}:${LHAPDF_DIR}/lib/python${python_version}/site-packages
export PYTHONPATH=${PYTHONPATH}:${PYTHIA_DIR}/lib
export PYTHONPATH=${PYTHONPATH}:${SCRIPTPATH}/build/python/fjpy

export PATH=${PATH}:${HEPMC_DIR}/bin:${LHAPDF_DIR}/bin:${PYTHIA8_DIR}/bin:${FASTJET_DIR}/bin
if [ -z ${LD_LIBRARY_PATH} ]; then
	export LD_LIBRARY_PATH=${HEPMC_DIR}/lib:${LHAPDF_DIR}/lib:${PYTHIA_DIR}/lib:${FASTJET_DIR}/lib
else
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HEPMC_DIR}/lib:${LHAPDF_DIR}/lib:${PYTHIA_DIR}/lib:${FASTJET_DIR}/lib
fi
if [ -z ${DYLD_LIBRARY_PATH} ]; then
	export DYLD_LIBRARY_PATH=${HEPMC_DIR}/lib:${LHAPDF_DIR}/lib:${PYTHIA_DIR}/lib:${FASTJET_DIR}/lib
else
	export DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${HEPMC_DIR}/lib:${LHAPDF_DIR}/lib:${PYTHIA_DIR}/lib:${FASTJET_DIR}/lib
fi
