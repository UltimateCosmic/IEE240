import pickle
import json

def pregunta_sn(pregunta:str) -> bool:
	rpta = input(pregunta)
	if rpta == 's':
		return True
	elif rpta == 'n':
		return False
	else:
		raise Exception('Caracter no valido')


def main():
	print("Ingrese datos del paciente")
	paciente = {}
	paciente['nombre'] = input("Nombre(s): ")
	paciente['apellido'] = input("Apellidos: ")
	paciente['peso'] = int(input("Peso(kg): "))
	paciente['talla'] = int(input("Talla(cm): "))
	paciente['edad'] = int(input("Edad: "))
	paciente['seguro'] = pregunta_sn("¿Cuenta con seguro? (s/n): ")
	
	msg_json = json.dumps(paciente)
	print(msg_json)
	print(type(msg_json))
	#socket.sendall(msg_json.encode())
	print(json.loads(msg_json))

	msg_pickles = pickle.dumps(paciente)
	print(msg_pickles)
	print(type(msg_pickles))
	#socket.sendall(msg_pickles)
	print(pickle.loads(msg_pickles))


if __name__ == "__main__":
	main()