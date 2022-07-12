#!/bin/bash

#this script will copy all the necessary files found in here
#and put them together in a folder of a selected forcefield
#then run the molecular dynamics calculations

mkdir charm
cp (*.pdb,ions.mdp,md.mdp,em.mdp,npt.mdp,nvt.mdp,ie.mdp) charm
cp (md_charm36.sh, charmm36-jul2021.ff.tgz, jz4.str, jz4.prm) charm
cp (edit_topol.py, edit_topol2.py, combine_pl.py, cgenff_charmm2gmx_py3_nx2.py) charm

cd charm

tar charmm36-jul2021.ff.tgz

md_charm36.sh

