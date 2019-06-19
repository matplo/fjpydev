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

version=3.3.2
fjdirsrc=fastjet-${version}
fjdirinst=$PWD/fjpydev/fastjet-${version}
if [ ! -z ${1} ]; then
	fjdirinst=${1}
fi

if [ ! -e ${fjdirsrc}.tar.gz ]; then
	wget http://fastjet.fr/repo/${fjdirsrc}.tar.gz
fi
if [ ! -d ${fjdirsrc} ]; then
	tar zxvf ${fjdirsrc}.tar.gz
fi

if [ ! -d ${fjdirinst} ]; then
	if [ -d ${fjdirsrc} ]; then
		cd ${fjdirsrc}
		echo "current dir: $PWD"
	    echo "unsetting PYTHONPATH"
	    unset PYTHONPATH
	    python_includes=$(python3-config --includes)
	    python_inc_dir=$(python3-config --includes | cut -d' ' -f 1 | cut -dI -f 2)
	    python_exec=$(which python3)
	    python_bin_dir=$(dirname ${python_exec})
	    echo "python exec: ${python_exec}"
	    echo "python includes: ${python_includes}"
	    echo "python include: ${python_inc_dir}"
		if [ "x${CGAL_DIR}" == "x" ]; then
		    ./configure --prefix=${fjdirinst} --enable-allcxxplugins \
		    PYTHON=${python_exec} \
		    PYTHON_INCLUDE="${python_includes}" \
		else
			echo "[i] building using cgal at ${CGAL_DIR}"
		    ./configure --prefix=${fjdirinst} --enable-allcxxplugins \
		    PYTHON=${python_exec} \
		    PYTHON_INCLUDE="${python_includes}" \
		    --enable-cgal --with-cgaldir=${CGAL_DIR} \
		    --enable-pyext
		    # \ LDFLAGS=-Wl,-rpath,${BOOST_DIR}/lib CXXFLAGS=-I${BOOST_DIR}/include CPPFLAGS=-I${BOOST_DIR}/include
		fi
		make -j $(n_cores) && make install
		cd -
	fi
fi

if [ -d ${fjdirinst} ]; then
	export FASTJET_DIR=${fjdirinst}
	export PATH=$PATH:${fjdirinst}/bin
	python_version=$(python3 --version | cut -f 2 -d' ' | cut -f 1-2 -d.)
	export PYTHONPATH=${PYTHONPATH}:${fjdirinst}/lib/python${python_version}/site-packages
fi

