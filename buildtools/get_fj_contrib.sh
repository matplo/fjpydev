#!/bin/bash

srcdir=${1}
wdir=${2}
if [ ! -z ${wdir} ]; then
	[ ! -d ${wdir} ] && mkdir -pv ${wdir}
fi

if [ -d ${srcdir} ]; then
	if [ -d ${wdir} ]; then
		mkdir -p ${srcdir}/recursivetools/src
		mkdir -p ${srcdir}/recursivetools/include/RecursiveTools

		mkdir -p ${srcdir}/lundplane/src
		mkdir -p ${srcdir}/lundplane/include/LundPlane

		cd ${wdir}
		[ ! -e fjcontrib-1.041.tar.gz ] && wget http://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.041.tar.gz
		if [ -e fjcontrib-1.041.tar.gz ]; then
			[ ! -d fjcontrib-1.041 ] && tar zxvf fjcontrib-1.041.tar.gz
			cp -rv ${wdir}/fjcontrib-1.041/RecursiveTools/*.hh ${srcdir}/recursivetools/include/RecursiveTools
			cp -rv ${wdir}/fjcontrib-1.041/RecursiveTools/*.cc ${srcdir}/recursivetools/src
			patch ${srcdir}/recursivetools/include/RecursiveTools/RecursiveSymmetryCutBase.hh -i ${srcdir}/recursivetools/RecursiveSymmetryCutBase.patch

			cp -rv ${wdir}/fjcontrib-1.041/LundPlane/*.hh ${srcdir}/lundplane/include/LundPlane
			cp -rv ${wdir}/fjcontrib-1.041/LundPlane/*.cc ${srcdir}/lundplane/src
			rm ${srcdir}/lundplane/src/example_*.cc

			patch ${srcdir}/lundplane/include/LundPlane/SecondaryLund.hh -i ${srcdir}/lundplane/SecondaryLund.patch
			patch ${srcdir}/lundplane/include/LundPlane/LundGenerator.hh -i ${srcdir}/lundplane/LundGenerator.patch
		fi
	fi
fi
