import matplotlib.pyplot as plt

numeros = [i for i in range(1000)]
numeros_al_cuadrado = [i**2 for i in range(1000)]

plt.plot(numeros,numeros_al_cuadrado)
plt.savefig('Figura.png')