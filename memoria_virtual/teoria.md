# ¿Qué es la memoria virtual?

---

El propósito de la memoria virtual es la de usar el disco duro como una extensión de la RAM. Esto significa que se puede aumentar el espacio de direcciones disponible para que un proceso se pueda usar.

Por lo general, no hay suficiente memoria para almacenar varias aplicaciones al mismo tiempo.

La forma más fácil de pensar en la memoria virtual es conceptualizarla como una ubicación de memoria imaginaria en la que el sistema operativo maneja todos los problemas de direccionamiento.

Usa el disco duro para contener el exceso. Esta área en el disco duro se llama archivo de página (page file), porque contiene fragmentos de la memoria principal en el disco duro.

La forma más común de implementar la memoria virtual es mediante el uso de paginación, un método en el que la memoria principal se divide en bloques de tamaño fijo y los programas se dividen en bloques del mismo tamaño.

# Memoria virtual-paginación

---

- En concreto: la paginación consiste en asignar una memoria física a los procesos en fragmentos de tamaño fijo (page frames) y realizar un seguimiento de dónde residen las distintas páginas del proceso al registrar información en una tabla de páginas.
- La tabla de páginas tiene N filas, donde N es el número de páginas virtuales en el proceso. Si hay páginas del proceso que actualmente no están en la memoria principal, la tabla de páginas lo indica al establecer un bit de validación en 0; si la página está en la memoria principal, el bit de validación se establece en 1.
- Las páginas de memoria virtual tienen el mismo tamaño que los frames de página de memoria física.
- La memoria de proceso se divide en estas páginas de tamaño fijo, lo que resulta en una posible fragmentación interna cuando la última página se copia en la memoria.
- La dirección virtual se divide en 2 campos:
    - Campo de página.
    - Campo de desplazamiento (offset): para representar el desplazamiento dentro de esa página donde se encuentran los datos solicitados.
- Este proceso de traducción de direcciones es similar al que usamos cuando dividimos las direcciones de la memoria principal en campos para los algoritmos de mapeo de caché y similar a los bloques de caché.
- Los tamaños de página suelen ser potencias de 2, lo cual simplifica la extracción de números de página y las compensaciones de las direcciones virtuales.

## Características

---

1. No es necesario almacenar fragmentos contiguos de programa.
2. Cada dirección virtual debe traducirse a una dirección física.

## Términos importantes

---

- **Dirección virtual**: dirección lógica o de programa que utiliza el proceso. Cada vez que la CPU
genera una dirección, siempre es en términos de espacio de direcciones virtuales.
- **Dirección física**: dirección real en memoria.
- **Mapeo**: el mecanismo mediante el cual las direcciones virtuales se traducen en físicas (muy similar al mapeo de la MC).
- **Page frames**: bloques en los cuales se divide la memoria principal.
- **Páginas**: bloques en los cuales se divide la memoria virtual (mismo tamaño que page frames).
- **Paginación**: proceso de copiar una página virtual del disco a un page frame en la memoria principal.
- **Fragmentación**: memoria que no se utiliza.
- **Fallo de página (page fault)**: evento que ocurre cuando una página solicitada no está en la memoria principal y debe copiarse en la memoria del disco.

# Memoria Caché

---

La memoria caché es un tipo de memoria pequeña de alta velocidad, es decir, de alto costo, y que sirve como *buffer* para los datos a los que se accede. El tiempo de acceso a estos datos es mucho menor que el tiempo de acceso a RAM o al disco duro, y solo el tiempo de acceso a los registros del CPU es menor.

El principio de localidad brinda la oportunidad para que el sistema use una pequeña cantidad de memoria muy rápida para así reducir el tiempo de lectura de datos. Hay dos formas principales de localidad y se definen a continuación:

- **Localidad temporal**: Los elementos a los que se accedió recientemente tienden a ser accedidos nuevamente en el futuro cercano.
- **Localidad espacial**: Si se accede a una posición de memoria una vez, es probable que el programa acceda a una ubicación de memoria cercana.

Los programas que emplean buenas prácticas de localidad tienen menor tiempo de ejecución. Considera la siguiente función, la cual suma los elementos de un vector.

```cpp
int sumvec(int* v, int N) {
  int i, sum=0;
  for (i=0; i<N; i++)
    sum += v[i];
  return sum;
}
```

Se escribe en a variable `sum` una vez en cada iteración; por lo tanto, la función presenta una buena localidad temporal con respecto a `sum`; sin embargo, dado que `sum` es escalar, la función carece de una localidad espacial para dicha variable. Por otro lado, los elementos del vector `v` se leen secuencialmente, uno tras otro, en el orden en que se almacenan en la memoria. Debido a esto, con respecto al arreglo `v`, tiene buena localidad espacial, pero pobre localidad temporal.

Las lecturas secuenciales son importantes en los programas que hacen referencias a arreglos. Por ejemplo, considere la función `sumarrayitems`, que suma los elementos de un arreglo bidimensional.

```cpp
int sumarrayitems(int **a, int M, int N) {
	int i, j, sum=0;
  for (i=0; i<M; i++)
    for (j=0; j<N; j++)
	    sum += a[i][j];
  return sum;
}
```

Suponga que los elementos del arreglo bidimensional `a` están **escritos** en memoria fila por fila (*row-major*). Para este caso la forma en como se leen los datos tiene un buen impacto en la localidad espacial, pues el doble bucle **lee** los elementos fila por fila (*row-view*). Digamos que se realiza un cambio mínimo, y en lugar de leer el arreglo fila por fila, se hace columna por columna (*column-view*).

```cpp
int sumarrayitems(int **a, int M, int N) {
  int i, j, sum=0;
  for (j=0; j<N; j++)
    for (i=0; i<M; i++)
      sum += a[i][j];
  return sum;
}
```

El resultado numérico en la variable `sum` será el mismo, pero debido a que la lectura de los elementos se realiza de una forma que no se corresponde con la forma en que están escritos, la función tendrá un mayor tiempo de ejecución.

Reglas simples para evaluar cualitativamente la localidad en un programa:

1. Los programas que acceden repetidamente a la mismas variables disfrutan de una buena localidad temporal.
2. Para programas con bucles que incluyan matrices multidimensionales secuenciales, cuanto más pequeño sea el salto secuencial, mejor será la localidad espacial. Los programas con saltos grandes alrededor de la memoria presentan una localidad espacial pobre.
3. Los bucles tienen una buena ubicación temporal y espacial con respecto a lectura de instrucciones. Cuanto más pequeño sea el cuerpo del bucle y mayor sea el número de iteraciones del bucle, mejor será la localidad.

En lo referente a las memorias caché, cuando se quiere acceder a un dato y este es encontrado, se dice que se ha producido un **acierto o *hit*** y en caso de que dicho dato no sea encontrado dentro de la caché se produce un **fallo o *miss***. Esto último ocasiona que el dato deba ser buscado en la *RAM* o disco duro, los cuales poseen un tiempo de acceso más lento. De esta manera, la ejecución del programa tiene un mayor tiempo de ejecución.

Es por eso que muchos algoritmos no solo se basan en la lógica de la resolución del problema en sí, sino que también organizan la estructura de acceso a datos de tal manera que, si algunos valores deben ser reutilizados para futuras operaciones, estos puedan aprovechar la localidad tanto espacial como temporal para la mejora del tiempo de ejecución del programa.****

## Ejemplo

---

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/aa434082-ca24-4eae-9d47-b64f051c7ea0/Untitled.png)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/46e69d5d-5642-4f40-8f85-0e0af94c8f44/Untitled.png)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/4a172ac1-614e-4055-a169-bd393e1aed3f/Untitled.png)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/8025d50b-f08a-4217-87f6-feeb3416d8b3/Untitled.png)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/eaf5501c-439c-465b-8713-8662fbfe80fc/Untitled.png)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5f206644-add9-4d7c-a53f-ee37a8c6eb3d/Untitled.png)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/cd6afbc9-9051-462a-abf5-2f018f41af4d/Untitled.png)