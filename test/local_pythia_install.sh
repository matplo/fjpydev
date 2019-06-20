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

version=8235
pydirsrc=pythia${version}
pydirinst=${SCRIPTPATH}/fjpydev/pythia${version}
if [ ! -z ${1} ]; then
	pydirinst=${1}
fi

if [ ! -e ${pydirsrc}.tgz ]; then
	wget http://home.thep.lu.se/~torbjorn/pythia8/${pydirsrc}.tgz
fi
if [ ! -d ${pydirsrc} ]; then
	tar zxvf ${pydirsrc}.tgz
fi

if [ ! -d ${pydirinst} ]; then
	if [ -d ${pydirsrc} ]; then
		cd ${pydirsrc}
	    echo "unsetting PYTHONPATH"
	    unset PYTHONPATH
	    python_inc_dir=$(python3-config --includes | cut -d' ' -f 1 | cut -dI -f 2)
	    python_exec=$(which python3)
	    python_bin_dir=$(dirname ${python_exec})
	    echo "python exec: ${python_exec}"
	    echo "python include: ${python_inc_dir}"
	    # this is a nasty trick to force python3 bindings
	    python_bin_dir="$PWD/tmppy"
	    mkdir -p ${python_bin_dir}
	    ln -s ${python_exec} ${python_bin_dir}/python
	    echo "python bin dir: ${python_bin_dir}"
		./configure --prefix=${pydirinst} \
			--with-python-include=${python_inc_dir} \
			--with-python-bin=${python_bin_dir}
		make -j $(n_cores) && make install
		cd -
	fi
fi

if [ -d ${pydirinst} ]; then
	export PYTHIA_DIR=${pydirinst}
	export PATH=$PATH:${pydirinst}/bin
	export PYTHONPATH=${PYTHONPATH}:${pydirinst}/lib
fi
