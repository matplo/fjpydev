#!/bin/bash

function os_linux()
{
	_system=$(uname -a | cut -f 1 -d " ")
	if [ $_system == "Linux" ]; then
		echo "yes"
	else
		echo
	fi
}

function os_darwin()
{
	_system=$(uname -a | cut -f 1 -d " ")
	if [ $_system == "Darwin" ]; then
		echo "yes"
	else
		echo
	fi
}

function n_cores()
{
	local _ncores="1"
	[ $(os_darwin) ] && local _ncores=$(system_profiler SPHardwareDataType | grep "Number of Cores" | cut -f 2 -d ":" | sed 's| ||')
	[ $(os_linux) ] && local _ncores=$(lscpu | grep "CPU(s):" | head -n 1 | cut -f 2 -d ":" | sed 's| ||g')
	#[ ${_ncores} -gt "1" ] && retval=$(_ncores-1)
	echo ${_ncores}
}

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

function abspath()
{
  case "${1}" in
    [./]*)
    echo "$(cd ${1%/*}; pwd)/${1##*/}"
    ;;
    *)
    echo "${PWD}/${1}"
    ;;
  esac
}
export -f abspath

[ "x${1}" == "xunset" ] && unset PYTHONPATH	&& echo "unsetting PYTHONPATH"

cmake -Bbuild -DBUILD_PYTHON=ON -DCMAKE_INSTALL_PREFIX=${SCRIPTPATH}/install -DCMAKE_BUILD_TYPE=Release $(abspath ${SCRIPTPATH}/..) \
&& cmake --build build --target all -- -j $(n_cores) \
&& cmake --build build --target install


if [ $(os_darwin) ]; then
	${SCRIPTPATH}/fix_hepmc_links.sh ${SCRIPTPATH}/build/python/fjpy/pythiafjtools
	${SCRIPTPATH}/fix_hepmc_links.sh ${SCRIPTPATH}/build/python/fjpy/mptools
	${SCRIPTPATH}/fix_hepmc_links.sh ${SCRIPTPATH}/build/python/fjpy/.libs
fi
