with open('topol.top') as f:
    lista = f.readlines()

f.close()

str1 = '\n; Ligand position restraints\n#ifdef POSRES\n#include "posre_jz4.itp"\n#endif\n'

 

lista = lista[:24611] + [str1] + lista[24611:]

with open('topol.top', 'w') as f:
    for i in lista:
        f.write(i)

f.close()
    
