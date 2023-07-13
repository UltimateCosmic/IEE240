import time
import matplotlib.pyplot as plt
from threading import Thread

rango = list()
valor = list() 

def es_primo(n:int):
    max = int(n**(0.5))
    for i in range (2,max+1):
        if n%i == 0:
            return False
    return True

def es_primo_hilo(inicio:int,fin:int):
    fin_ran = int(fin**(0.5))
    for i in range (inicio,fin_ran+1):
        if n%i == 0:
            valor.append(False)
    rango[0] = fin
    rango[1] += fin
    valor.append(True)

def sincrono(n:int):
    if es_primo(n):
        print("Es primo_sincrono")
        return True
    else:
        print("No es primo_sincrono")
        return False

def hilos(n:int,num_procesos:int):
    global rango
    rango.append(2)
    rango.append(int(n/2))
    global valor 
    hilos = list()
    for i in range(num_procesos):
        hilos.append(Thread(target=es_primo_hilo,args=(int(rango[0]),int(rango[1]))))
        hilos[i].start()

    res = True
    for i in range(len(valor)):
        res = res and valor[i]
    
    if res:
        print("Es primo_hilo")
        return True
    else:
        print("No es primo_hilo")
        return False

if __name__=="__main__":
    #n = int(input("Ingresa un numero: "))
    n = 2_345_678_911_111_111
    #n = 5
    tiempo = list()
    cant_procesos = list()

    inicio_sinc = time.perf_counter()
    val_sincr = sincrono(n)
    fin_sinc = time.perf_counter()

    inicio_hilos = time.perf_counter()
    val_hilos = hilos(n,2)
    fin_hilos = time.perf_counter()
    tiempo.append(fin_hilos-inicio_hilos)
    cant_procesos.append(2)

    inicio_hilos = time.perf_counter()
    val_hilos = hilos(n,4)
    fin_hilos = time.perf_counter()
    tiempo.append(fin_hilos-inicio_hilos)
    cant_procesos.append(4)

    inicio_hilos = time.perf_counter()
    val_hilos = hilos(n,8)
    fin_hilos = time.perf_counter()
    tiempo.append(fin_hilos-inicio_hilos)
    cant_procesos.append(8)

    inicio_hilos = time.perf_counter()
    val_hilos = hilos(n,16)
    fin_hilos = time.perf_counter()
    tiempo.append(fin_hilos-inicio_hilos)
    cant_procesos.append(16)

    assert(val_sincr == val_hilos)
    print(f"tiempo sincrono {fin_sinc-inicio_sinc}")
    print(f"tiempo hilos {tiempo[0]}")

    plt.plot(cant_procesos,tiempo)
    plt.show()