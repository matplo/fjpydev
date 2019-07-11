#!/usr/bin/env python3
import sys
import fastjet as fj
import pythia8
from recursivetools import pyrecursivetools as rt
from lundplane import pylundplane as lund
from pythiafjtools import pypythiafjtools as pyfj
from mptools import pymptools as mp
from tqdm import tqdm


def deltas(jets, jets0):
    for i in range(len(jets)):
        yield jets0[i].perp() - jets[i].perp()


def create_and_init_pythia(config_strings=[]):
    pythia = pythia8.Pythia()
    for s in config_strings:
        pythia.readString(s)
    for extra_s in ["Next:numberShowEvent = 0", "Next:numberShowInfo = 0", "Next:numberShowProcess = 0"]:
        pythia.readString(extra_s)
    if pythia.init():
        return pythia
    return None

def main():
    nevents = 1000
    if 'gen' in sys.argv:
        sconfig_pythia = ["Beams:eCM = 8000.", "HardQCD:all = on", "PhaseSpace:pTHatMin = 100."]
        pythia = create_and_init_pythia(sconfig_pythia)
        all_jets = []
        for iEvent in tqdm(range(nevents), 'event'):
            if not pythia.next(): continue
        print("[i] done generating")

    if 'write' in sys.argv:
        sconfig_pythia = ["Beams:eCM = 8000.", "HardQCD:all = on", "PhaseSpace:pTHatMin = 100."]
        pythia = create_and_init_pythia(sconfig_pythia)
        pyhepmcwriter = mp.Pythia8HepMCWrapper("test_pythia8_hepmc.dat")
        all_jets = []
        for iEvent in tqdm(range(nevents), 'event'):
            if not pythia.next(): continue
            pyhepmcwriter.fillEvent(pythia)
        print("[i] done writing to test_pythia8_hepmc.dat")

    if 'read' in sys.argv:
        import pyhepmc_ng
        input = pyhepmc_ng.ReaderAsciiHepMC2("test_pythia8_hepmc.dat")
        if input.failed():
            print ("[error] unable to read from test_pythia8_hepmc.dat")
            return
        event = pyhepmc_ng.GenEvent()
        pbar = tqdm(range(nevents))
        while not input.failed():
            p = input.read_event(event)
            if input.failed():
                # print ("[i] reading done.")
                break
            pbar.update()
            # print(len(event.particles))

if __name__ == '__main__':
    main()
