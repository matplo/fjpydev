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

npdfs_link="http://lhapdfsets.web.cern.ch/lhapdfsets/current/EPPS16nlo_CT14nlo_Pb208.tar.gz"

version=6.2.3
fname=LHAPDF-${version}
dirsrc=${SCRIPTPATH}/LHAPDF-${version}
dirinst=${SCRIPTPATH}/fjpydev/LHAPDF-${version}

if [ ! -z ${1} ]; then
	dirinst=${1}
fi

if [ ! -e ${SCRIPTPATH}/${fname}.tar.gz ]; then
	cd ${SCRIPTPATH}
	wget https://lhapdf.hepforge.org/downloads/?f=${fname}.tar.gz -O ${fname}.tar.gz
fi

if [ ! -d ${dirsrc} ]; then
	tar zxvf ${fname}.tar.gz
fi

if [ ! -d ${dirinst} ]; then
	if [ -d ${dirsrc} ]; then
		cd ${dirsrc}
	    # echo "unsetting PYTHONPATH"
	    # unset PYTHONPATH
	    # python_inc_dir=$(python3-config --includes | cut -d' ' -f 1 | cut -dI -f 2)
	    # python_exec=$(which python3)
	    # python_bin_dir=$(dirname ${python_exec})
	    # # echo "python exec: ${python_exec}"
	    # # echo "python include: ${python_inc_dir}"
	    # # this is a nasty trick to force python3 bindings
	    # python_bin_dir="$PWD/tmppy"
	    # mkdir -p ${python_bin_dir}
	    # ln -sf ${python_exec} ${python_bin_dir}/python
		./configure --prefix=${dirinst}
		make -j $(n_cores) && make install
		cd - 2>&1 > /dev/null
	fi
fi

if [ -d ${dirinst} ]; then
	export LHAPDF_DIR=${dirinst}
	export LHAPDF_ROOT_DIR=${dirinst}
	export PATH=$PATH:${dirinst}/bin
	python_version=$(python3 --version | cut -f 2 -d' ' | cut -f 1-2 -d.)
	export PYTHONPATH=${PYTHONPATH}:${dirinst}/lib/python${python_version}/site-packages
	export LHAPATH=${dirinst}/share/LHAPDF
fi
