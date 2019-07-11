%module pythiafjtools

%include "std_string.i"
%include "std_vector.i"

// Add necessary symbols to generated header
%{
#include <fastjet/PseudoJet.hh>
#include <Pythia8/Pythia.h>
#include <mptools/aleph.hh>
#include <mptools/pythiahepmc.hh>
%}

// Process symbols in header

%include "mptools/aleph.hh"
%include "mptools/pythiahepmc.hh"

namespace std
{
  %template(AlephParticleVector) std::vector<Aleph::Particle>;
}

