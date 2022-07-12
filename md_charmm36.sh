#!/bin/bash

## Charm

#put you molecule file in the working directory
#clean HOH from pdb
grep -v HOH 3htb.pdb > 3HTB_clean.pdb
#create a new file containg only the Ligand
grep JZ4 3HTB_clean.pdb > jz4.pdb

#remove HETATM lines from protein file
grep -v HETATM 3HTB_clean.pdb > 3HTB_processed.pdb

echo "1" | gmx pdb2gmx -f 3HTB_processed.pdb -o 3HTB_processed.gro -water spce

#create complex file to unite protein and ligand info
cp 3HTB_processed.gro complex.gro

#convert str file to ini file
python cgenff_charmm2gmx_py3_nx2.py JZ4 jz4_fix.mol2 jz4.str charmm36-jul2021.ff

#conver ini file to gro format
gmx editconf -f jz4_ini.pdb -o jz4.gro

#combine protein and ligand gro files
python combine_pl.py

python edit_topol.py

# solvate
gmx editconf -f complex.gro -o newbox.gro -bt dodecahedron -d 1.0

gmx solvate -cp newbox.gro -cs spc216.gro -p topol.top -o solv.gro

#add ions
#create tpr ion file
gmx grompp -f ions.mdp -c solv.gro -p topol.top -o ions.tpr

#pass tpr file to genion
#selec SOL option

echo "15" | gmx genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CLA -neutral

#Energy Minimization
#create tpr file
gmx grompp -f em.mdp -c solv_ions.gro -p topol.top -o em.tpr

gmx mdrun -v -deffnm em

#equilibration
{
 echo "0 & ! a H*"
 echo "q"
} | gmx make_ndx -f jz4.gro -o index_jz4.ndx

echo "3" | gmx genrestr -f jz4.gro -n index_jz4.ndx -o posre_jz4.itp -fc 1000 1000 1000

python edit_topol2.py

#group jz4
{
echo "1 | 13"
echo "14 | 15"
echo "q"
} | gmx make_ndx -f em.gro -o index.ndx

##nvt calculation

## reminder: tc-grp in mdp files must be changed to actual group names Protein_JZ4 CLA_Water
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -n index.ndx -o nvt.tpr

gmx mdrun -deffnm nvt

#npt calculation
gmx grompp -f npt.mdp -c nvt.gro -t nvt.cpt -r nvt.gro -p topol.top -n index.ndx -o npt.tpr

gmx mdrun -deffnm npt

#md calculation
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -n index.ndx -o md_0_10.tpr

gmx mdrun -deffnm md_0_10

#Recenterin and rewraping
#choose protein and system
{
echo "1"
echo "0"
}|gmx trjconv -s md_0_10.tpr -f md_0_10.xtc -o md_0_10_center.xtc -center -pbc mol -ur compact

#first frame
gmx trjconv -s md_0_10.tpr -f md_0_10_center.xtc -o start.pdb -dump 0

#smoother visualization
#choose backbone and system
{
echo "1"
echo "0"
}|gmx trjconv -s md_0_10.tpr -f md_0_10_center.xtc -o md_0_10_fit.xtc -fit rot+trans

#distance between hidroxyl group
gmx distance -s md_0_10.tpr -f md_0_10_center.xtc -select 'resname "JZ4" and name OAB plus resid 102 and name OE1' -oall

#angle - create group for angles
{
echo "13 & a OAB | a H12"
echo "1 & r 102 & a OE1"
echo "23 | 24"
echo q
} | gmx make_ndx -f em.gro -o index.ndx

#calculate angle
gmx angle -f md_0_10_center.xtc -n index.ndx -ov angle.xvg

#RMSD
#create a new group

{
echo ! 13 & ! a H*
echo "name 26 JZ4_Heavy"
echo "q"
}|gmx make_ndx -f em.gro -n index.ndx

#rmsd calculation
gmx rms -s em.tpr -f md_0_10_center.xtc -n index.ndx -tu ns -o rmsd_jz4.xvg

#energy groups
#protein ligand energy
gmx grompp -f ie.mdp -c npt.gro -t npt.cpt -p topol.top -n index.ndx -o ie.tpr

gmx mdrun -deffnm ie -rerun md_0_10.xtc -nb cpu

gmx energy -f ie.edr -o interaction_energy.xvg