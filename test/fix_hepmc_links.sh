#!/bin/bash

function fix_boost_in_dir()
{
	# sharedlibs=$(find ${JETTY_DIR}/lib -name *.dylib)
	sharedlibs="$(find ${1} -name "*.so") $(find ${1} -name "*.dylib")"
	for sharedlib in ${sharedlibs}
	do
		echo ""
		echo "[i] ${sharedlib} to change from:"
		otool -L ${sharedlib}
		# libs=$(otool -L ${sharedlib})
		#for l in ${libs}
		otool -L ${sharedlib} | sed 1d | \
		while read l
		do
			if [[ $l = *"libHepMC"* ]]; then
				slib=$(echo ${l} | cut -f 1 -d" ")
				if [ ! -z ${slib} ]; then
					echo "        line to change:" ${slib} "to:" ${HEPMC2_DIR}/lib/${slib}
					if [ -e ${slib} ]; then
						echo "     not changing"
					else
						install_name_tool -change ${slib} ${HEPMC2_DIR}/lib/${slib} ${sharedlib}
					fi
				else
					echo "no change:" $slib
				fi
			fi
		done
		echo "     -> changed to - check:"
		otool -L ${sharedlib} | sed 1d | \
		while read l
		do
			if [[ $l = "libHepMC"* ]]; then
				slib=$(echo ${l} | cut -f 1 -d" ")
				if [ ! -z ${slib} ]; then
					echo "        changed?:" $slib "to:" ${sharedlib}
				fi
			fi
		done
	done
}

function usage()
{
	echo "usage: $(basename ${BASH_SOURCE}) <directory>"
}

if [ -z ${1} ]; then
	usage
else
	if [ -d ${1} ]; then
		fix_boost_in_dir ${1}
	else
		echo "${1} is not a directory..."
		usage
	fi
fi
cd ${cpwd}
