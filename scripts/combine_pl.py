with open('jz4.gro') as f:
    jz4_gro = f.readlines()

f.close()

with open('complex.gro') as f:
    complex_gro = f.readlines()

f.close()

jz4_gro = jz4_gro[2: -1]

complex_gro = complex_gro[:-1] + jz4_gro + [complex_gro[-1]]

complex_gro[1] = str(int(complex_gro[1]) + len(jz4_gro)) +'\n'

with open('complex.gro', 'w') as f:
    for i in complex_gro:
        f.write(i)

f.close()

