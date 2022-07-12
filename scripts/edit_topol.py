with open('topol.top') as f:
    lista = f.readlines()

f.close()

str1 = '; Include ligand parameters\n#include "jz4.prm"\n'
str2 = '; Include ligand topology\n#include "jz4.itp"\n'
str3 = 'JZ4 1\n'
 

lista = lista[:22] + [str1] + lista[22:24606] + [str2] + lista[24606:]+ [str3]

with open('topol.top', 'w') as f:
    for i in lista:
        f.write(i)

f.close()
    
