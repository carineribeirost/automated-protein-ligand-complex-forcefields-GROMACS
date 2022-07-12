# Automated Protein-ligand Complex tutorial in different force fields
Script developed to run the commands of the "Protein-Ligand Complex" tutorial in GROMACS in different force fields at once.
More information on how to execute this tutorial is found in [Protein-Ligand Tutorial](http://www.mdtutorials.com/gmx/complex/index.html)

## How to run the script 

* Make sure you have GROMACS installed
* Download the code and unzip it on the desirable directory
* Install networkx running the following in the terminal
```
pip install networkx==2.3
``` 
* Download the python script ["cgenff_charmm2gmx_py3_nx2.py"](https://www.charmm.org/archive/charmm/resources/charmm-force-fields/download.php?filename=CHARMM_ff_params_files/cgenff_charmm2gmx_py3_nx2.py) and add to the "files" folder

To run the script: open the linux terminal, go to your working directory and use the command

```
molDynamics.sh
``` 


## Implemented force fields

* Implemented on the root directory

(#) CHARMM36

* To be Implemented soon 

(1) AMBER03
(5) AMBER99SB
(6) AMBER99SB-ILDN
(8) CHARMM27
(15) OPLS-AA/L

## Water models used in this tutorial 

* Used in this tutorial

(tip3p) CHARMM36 

* To be Implemented soon

(tip3p) to AMBER99SB, AMBER99SB-ILDN and CHARMM27 

(tip4p) or spce to OPLS-AA/L

## Observations

This script is a simple way to execute GROMACS “Protein-Ligand Complex” tutorial after building the topology of the ligand with external automated tools. The parameters used in the molecular dynamics simulation can be found at [Gromacs page](http://www.gromacs.org/).

Changes in parameters are necessary as the objective of the molecular dynamics changes.


## Authorship

* Author:([Carine Ribeiro](https://github.com/carineribeirost))
* Co-author:([Raiane Pimentel](https://https://www.linkedin.com/in/raiane-pimentel-b2485853/))
