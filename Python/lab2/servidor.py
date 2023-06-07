import numpy as np
from time import perf_counter
import socket
import csv

HOST = '127.0.0.1'
PORT = 5001
n=1
count=0
rec='recibido'
notas={}

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    while n!=0:
        conn,addr=s.accept()
        with conn:
            print(f'Conectado con {addr}')
            cnt_notas = conn.recv(1024).decode("utf-8")
            data = conn.recv(1024).decode("utf-8")
            if (cnt_notas=='fin'):
                continue
            else: 
                data=data[1:len(data)-1]
                info=data.split(", ")
                cnt_notas = int(cnt_notas)
                notas[info[i][1:len(info[0])-1]]=[int(element) for element in info[1:]]
                mensaje = f"El promedio de las notas de {info[0][1:len(info[0])-1]}"
                mensaje = str.encode(str(mensaje))
                conn.sendall(mensaje)
                with open("dataBase.csv", "w", newline='') as file:
                    titulo = ['Nombre'] + ['Nota'+str(i+1) for i in range(cnt_notas)]
                    writer = csv.writer(file)
                    writer.writerow(titulo)
                    [writer.writerow([key] + values) for key,values in notas.items()]
                file.close()