import numpy as np
from time import perf_counter
import socket
import csv
import time

HOST = '127.0.0.1'
PORT = 5001
cnt_notas = int(input("Ingrese la cantidad de notas que va a tener el curso: "))
while (1):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((HOST, PORT))
        nombre = input("Ingrese el primer nombre o la palabra \'fin'\ para terminar el programa: ")
        if nombre=="fin":
            s.sendall(str.encode(str('fin')))
            break
        else: 
            mensaje = [nombre]
            for i in range(1, cnt_notas+1):
                nota = int(input(f"Ingrese la nota {i}: "))
                mensaje = mensaje + [nota]
            print(mensaje)
            s.sendall(str.encode(str(cnt_notas)))
            s.sendall(str.encode(str(mensaje)))
            promedio = s.recv(1024).decode("utf-8")
            print(promedio)