#!/bin/bash

srcdir=${1}
if [ ! -z ${srcdir} ]; then
	cd ${srcdir}
	mkdir -p ${srcdir}/recursivetools/src
	mkdir -p ${srcdir}/recursivetools/include/RecursiveTools
	[ ! -e fjcontrib-1.041.tar.gz ] && wget http://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.041.tar.gz
	if [ -e fjcontrib-1.041.tar.gz ]; then
		[ ! -d fjcontrib-1.041 ] && tar zxvf fjcontrib-1.041.tar.gz
		cp -rv fjcontrib-1.041/RecursiveTools/*.hh ${srcdir}/recursivetools/include/RecursiveTools
		cp -rv fjcontrib-1.041/RecursiveTools/*.cc ${srcdir}/recursivetools/src
		patch ${srcdir}/recursivetools/include/RecursiveTools/RecursiveSymmetryCutBase.hh -i ${srcdir}/recursivetools/RecursiveSymmetryCutBase.patch
	fi
fi
