#!/bin/bash

version=3.3.2
fjdirsrc=fastjet-${version}
fjdirinst=$PWD/fastjet-${version}-inst

if [ ! -d ${fjdirsrc} ]; then
	wget http://fastjet.fr/repo/${fjdirsrc}.tar.gz
	tar zxvf ${fjdirsrc}.tgz
fi

if [ ! -d ${fjdirinst} ]; then
	if [ -d ${fjdirsrc} ]; then
		cd ${fjdirsrc}
	    python_includes=$(python3-config --includes)
	    python_inc_dir=$(python3-config --includes | cut -d' ' -f 1 | cut -dI -f 2)
	    python_exec=$(which python3)
	    python_bin_dir=$(dirname ${python_exec})
	    echo "python exec: ${python_exec}"
	    echo "python includes: ${python_includes}"
	    echo "python include: ${python_inc_dir}"
	    echo "unsetting PYTHONPATH"
	    unset PYTHONPATH
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
		    --enable-pyext \
		    LDFLAGS=-Wl,-rpath,${BOOST_DIR}/lib CXXFLAGS=-I${BOOST_DIR}/include CPPFLAGS=-I${BOOST_DIR}/include
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

