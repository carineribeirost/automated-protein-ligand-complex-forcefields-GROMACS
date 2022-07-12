#!/bin/bash

#this script will copy all the necessary files found in here
#and put them together in a folder of a selected forcefield
#then run the molecular dynamics calculations

mkdir charmm
cp (md_charmm36.sh) charmm
cd files
cp (*.pdb,ions.mdp,md.mdp,em.mdp,npt.mdp,nvt.mdp,ie.mdp,charmm36-jul2021.ff.tgz, jz4.str, jz4.prm) $(pwd)/../charmm
cd ..
cd scripts
cp (edit_topol.py, edit_topol2.py, combine_pl.py, cgenff_charmm2gmx_py3_nx2.py) $(pwd)/../charmm
cd ..

cd charmm

tar charmm36-jul2021.ff.tgz

md_charmm36.sh

