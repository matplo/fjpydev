# FJPYDEV

## Synopsis

- this is put together using the excellent https://github.com/Mizux/cmake-swig (a complete example of how to create a Modern [CMake](https://cmake.org/) C++ Project with the [SWIG](http://www.swig.org) code generator - wrappers for Python, .Net and Java.) - note, some doc left on purpose
- still needs work but main idea of having things in python is working (FastJet contribs with CMake + python (SWIG) bindings)
- tested with [FastJet ver. 3.3.2](http://www.fastjet.fr/)
- and parts of code from [FastJet Contrib ver. 1.041](https://fastjet.hepforge.org/contrib/) - work on the python bindings ongoing (RecursiveTools and LundPlane for the moment)
- patches RecursiveSymmetryCutBase.hh

## Building

- relies on `pythia8-config` and `fastjet-config` in $PATH
- tested with SWIG 4.0
- cmake 3.14.4
- CGAL 13.0.3 + BOOST 1.69.00 (also tested with cgal (and boost) installed with brew `brew install cgal`)
- ought to work with any 2.7> python - (see cmake/python.cmake) but the test (directory) fixed python ver. 3.
- this is in development so installation needs improvement - see below for a local install

## Handy quick start - python3

```bash
git clone git@github.com:matplo/fjpydev.git
cd fjcmake/test
./local_pythia_install.sh
./local_fastjet_install.sh
. ./setup_env.sh
./build_here.sh
python3 ./05-user-info.py
```

### Notes

- for a quick install of PYTHIA8 (http://home.thep.lu.se/~torbjorn/Pythia.html) - use `local_pythia_install.sh` 
- same for fastjet use `./local_fastjet_install.sh`
- before use (python, jupyter etc) source (fix of PYTHON_PATH) `. ./setup_env.sh` or use `sys.path.append(...)` in your python
