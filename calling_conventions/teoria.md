# Punto Flotante

---

## **Valores en Punto Flotante**

---

En C, las variables con precisión simple son declaradas como `float` y las variables con precisión doble son declaradas como `double`.

```c
float a     // a es una variable float de 32 bits
double b    // b es una variable double de 64 bits
float *c    // c es un puntero a una variable float
double *d   // d es un puntero a una variable double
```

## **Registros de Punto Flotante**

---

Los **XMM** don registros empleados para dar soporte a instrucciones de punto flotante y son de 128 bits, pero en los últimos procesadores son de 256 bits. Hay 16 registros **XMM** que van desde `xmm0` hasta `xmm15`. Para esta oportunidad solo se empleará los últimos 32 o 64 bits de estos registros pues solo se van a realizar operaciones escalares. [↑](https://github.com/stefano-sosac/iee240-learning-material/wiki/Punto-Flotante-y-Convenciones-de-llamadas-a-funci%C3%B3n-en-64-bits#contenidos)

## **Instrucciones de Punto Flotante**

---

La las instrucciones para operaciones de punto flotante serán en el siguiente orden:

- Instruciones de Transferencia de Datos.
- Instrucciones de Conversión.
- Instrucciones Aritméticas de Punto Flotante.
- Intrucciones de Control de Punto Flotante.

Para una lista completa de las instrucciones se puede revisar el siguiente [enlace](https://www.felixcloutier.com/x86/).

### Instruciones de Transferencia de Datos Escalares

---

Estas instrucciones permiten transferir datos de una posición de memoria a un registro, y de un registro a una posición de memoria y de un registro a otro registro. Hay dos instrucciones para mover escalares en punto flotante: `movss` para mover valores de 32 bits (`float`) y `movsd` para mover valores de 64 bits (`double`). [↑](https://github.com/stefano-sosac/iee240-learning-material/wiki/Punto-Flotante-y-Convenciones-de-llamadas-a-funci%C3%B3n-en-64-bits#contenidos)

```nasm
movss xmm0, [a]     ; mover el valor en a al registro xmm0
movsd [b], xmm1     ; mover el valor en el registro xmm1 a b
movss xmm2, xmm0    ; mover el valor en xmm0 a xmm2
```

### **Instruciones de Conversión**

---

Cuando se requiere emplear enteros en una operación en punto flotante, los enteros deben ser convertidos primero a punto flotante. De igual manera, si se requieren en una misma operación valores de precisión simple y precisión doble, se deberá realizar previamente una operación de conversión para que ambos operandos compartan el mismo tipo de dato.****

### Conversión entre Operandos Punto Flotante de distinto tamaño

Hay dos instrucciones para convertir operandos escalares en punto flotante: `cvtss2sd` para convertir valores de 32 bits a 64 bits y `cvtsd2ss` para convertir valores de 64 bits a 32 bits.

```nasm
cvtss2sd xmm0, [x]  ; convertir el float en x a double en xmm0
cvtsd2ss xmm0, xmm0 ; el float en xmm0 a double en xmm0
```

### Conversión de/a Punto Flotante de/a Entero

Cuando el método para convertir números en punto flotante a enteros es por redondeo hay dos intrucciones: `cvtss2si` para convertir un `float` a entero y `cvtsd2si` para convertir un `double` a entero. Cuando el método de conversión es por truncamiento hay otras dos instrucciones: `cvttss2si` y `cvttsd2si`. Asimismo, para convertir números enteros a punto flotante hay dos instrucciones: `cvtsi2ss` y `cvtsi2sd`.

```nasm
cvtss2si eax, xmm0  ; float en xmm0 a int en eax
cvtsi2sd xmm0, rax  ; long en rax a double en xmm0
cvtsi2sd xmm0, [x]  ; int en x a double en xmm0
```

### **Instruciones Aritméticas de Punto Flotante**

---

Estas intrucciones permiten ejecutar operaciones de suma, resta, multiplicación, división y raíz cuadrada con operandos en punto flotante de 32 o 64 bits.

```nasm
addss   xmm0, [a]   ;   xmm0 <- xmm0 + [a] (float)
addss   xmm0, xmm1  ;   xmm0 <- xmm0 + xmm1 (float)
addsd   xmm0, [b]   ;   xmm0 <- xmm0 + [b] (double)
addsd   xmm0, xmm1  ;   xmm0 <- xmm0 + xmm1 (double)
subss   xmm0, [a]   ;   xmm0 <- xmm0 - [a] (float)
subss   xmm0, xmm1  ;   xmm0 <- xmm0 - xmm1 (float)
subsd   xmm0, [b]   ;   xmm0 <- xmm0 - [b] (double)
subsd   xmm0, xmm1  ;   xmm0 <- xmm0 - xmm1 (double)
mulss   xmm0, [a]   ;   xmm0 <- xmm0 * [a] (float)
mulss   xmm0, xmm1  ;   xmm0 <- xmm0 * xmm1 (float)
mulsd   xmm0, [b]   ;   xmm0 <- xmm0 * [b] (double)
mulsd   xmm0, xmm1  ;   xmm0 <- xmm0 * xmm1 (double)
divss   xmm0, [a]   ;   xmm0 <- xmm0 / [a] (float)
divss   xmm0, xmm1  ;   xmm0 <- xmm0 / xmm1 (float)
divsd   xmm0, [b]   ;   xmm0 <- xmm0 / [b] (double)
divsd   xmm0, xmm1  ;   xmm0 <- xmm0 / xmm1 (double)
sqrtss  xmm0, [a]   ;   xmm0 <- ([a])^0.5 (float)
sqrtss  xmm0, xmm1  ;   xmm0 <- (xmm1)^0.5 (float)
sqrtsd  xmm0, [b]   ;   xmm0 <- ([b])^0.5 (double)
sqrtsd  xmm0, xmm1  ;   xmm0 <- (xmm1)^0.5 (double)
```

### **Instruciones de Control de Punto Flotante**

---

Las instrucciones de control son aquellas que permiten implementar estructuras selectivas (*IF - ELSE*) e iterativas (*FOR - WHILE*). La instrucción `cmp` que se empleaba con enteros no funcionará con operandos en punto flotante. Las instrucciones de comparación tendrán ambos operandos en punto flotante, y al igual que en el caso de los enteros el resultado será almacenado el registro de banderas.****

### Comparaciones en Punto Flotante

La forma general de las operaciones de comparación es una de las siguientes:

```nasm
ucomiss Rxmm, op2
ucomisd Rxmm, op2
```

Donde `Rxmm` y `op2` son operandos en punto flotante y deben ser del mismo tamaño. Ninguno de los operandos será alterado por las operaciones de comparación. El operando `Rxmm` debe ser un registro `xmm`, y el operando `op2` puede ser un registro `xmm` o el contenido de una posición de memoria.

En los siguientes ejemplos se pueden apreciar algunas de las operaciones de saltos de control que se pueden realizar:

```nasm
je  label   ;   jump equal          si op1  ==  op2
jne label   ;   jump not equal      si op1  !=  op2
jb  label   ;   jump below than     si op1  <   op2
jbe label   ;   jump below or equal si op1  <=  op2
ja  label   ;   jump above than     si op1  >   op2
jae label   ;   jump above or equal si op1  >=  op2
```

## **Convenciones de llamada a función**

---

La mayoría de funciones tienen parámetros. Los parámetros nos permiten que una función opere con datos distintos en cada llamada que se realiza. Adicionalmente, una función puede tener un valor de retorno como indicador de éxito o error.****

### Transmisión de Argumentos

---

Es como se le denomina al envío de información a una función y a la obtención adecuada de un resultado de dicha función. Hay varias maneras de pasar argumentos a una función, pero las más usadas son las siguientes:

- Colocar valores o direcciones en un registro.
- Definir variables globales.
- Colocar valores o direcciones en la pila.

### Paso de Parámetros

---

Como se mencionó anteriormente los parámetros pueden ser pasados a una función mediante el uso de registros o de la pila. La siguiente tabla muestra cuales son los registros que se usan cuando enteros (`char`, `short`, `int`, `long`) o flotantes (`float`, `double`).

En la tabla se puede apreciar los registros que se corresponden con los argumentos de una función:

| Posición del argumento | Entero | Flotante |
| --- | --- | --- |
| Primero | rdi | xmm0 |
| Segundo | rsi | xmm1 |
| Tercero | rdx | xmm2 |
| Cuarto | rcx | xmm3 |
| Quinto | r8 | xmm4 |
| Sexto | r9 | xmm5 |
| Séptimo |  | xmm6 |
| Octavo |  | xmm7 |

En el siguiente ejemplo se muestra una función llamada `myfunction` y sus argumentos. En el comentario se indica en que registro va cada parámetro de la función.

```c
extern void my_function(char a, short b, float c, double *d, double e)
// a en rdi, b en rsi, c en xmm0, d en rdx, e en xmm1
```

### ***Caller* y *Callee***

---

Dadas dos funciones `foo` y `bar`, una situación en que la función `foo` llama a la función `bar`, se dice que la función `foo` es el *caller* y que la función `bar` es el *callee*. El uso de los registros no estará limitado al paso de argumentos y su modificación deberá tomar en cuenta el rol de las funciones durante la ejecución del programa. Por ejemplo, los registros usados para pasar los primeros 6 argumentos enteros, y para devolver el valor son *caller-saved*, por esto el *callee* puede disponer libremente de estos registros sin tomar precausión alguna. Si `rax` contiene un valor que el *caller* desea preservar, el *caller* debe copiar el valor de `rax` a un lugar seguro antes de realizar la llamada a función. En contraste, si el *callee* desea usar algún registro que sea *callee-saved* deberá preservar su valor en algún lugar seguro y restaurarlo antes de salir de la llamada a función.

En la siguiente table se muestran los usos convencionales para cada registro según el rol de la función:

| Registro | Uso convencional |
| --- | --- |
| rax | caller-saved |
| rdi | caller-saved |
| rsi | caller-saved |
| rdx | caller-saved |
| rcx | caller-saved |
| r8 | caller-saved |
| r9 | caller-saved |
| r10 | caller-saved |
| r11 | caller-saved |
| rsp | callee-saved |
| rbx | callee-saved |
| rbp | callee-saved |
| r12 | callee-saved |
| r13 | callee-saved |
| r14 | callee-saved |
| r15 | callee-saved |

## **Ejemplos**

---

### Producto interno

---

Código en ensamblador para calcular el producto interno de dos vectores.

```nasm
global asmFloatInnerProd
	section .text

asmFloatInnerProd:
	xorpd	xmm0,	xmm0
	xorpd	xmm1,	xmm1
	xorpd	xmm2,	xmm2
	cmp	rdx,	0
	je	done
next:
	movss	xmm0,	[rdi]
	movss	xmm1,	[rsi]
	mulss	xmm0,	xmm1
	addss	xmm2,	xmm0
	add	rdi,	4
	add	rsi,	4
	sub	rdx,	1
	jnz	next	
done:
	movss	[rcx],	xmm2
	ret
```

<aside>
💡 Acerca de la instrucción `jnz`:

> The `jnz` instruction **transfers control to the specified address if the value in the accumulator is not 0.**
> 
</aside>

Código en C que calcula el producto interno de dos vectores con una función propia. El programa principal llama a la función hecha en ensamblador y a la función hecha en C. También imprime el tiempo en nanosegundos que toma cada función, y el error relativo del resultado en ensamblador considerando como referencia el valor calculado en C.

```c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

extern void asmFloatInnerProd(float *v1, float *v2, int N, float *ip);
void initVector(float *v, int N);
void cFloatInnerProd(float *v1, float *v2, int N, float *ip);
float calcRelErr(float ref, float cal);

int main()
{
    // semilla para los números aleatorios
    srandom(time(NULL));

    float *v1, *v2, ipC, ipAsm;
    int N = 1024;

    v1 = malloc(N * sizeof(float));

    v2 = malloc(N * sizeof(float));

    int i = 0;

    initVector(v1, N);
    initVector(v2, N);

    struct timespec ti, tf;
    double elapsed;

    clock_gettime(CLOCK_REALTIME, &ti);
    cFloatInnerProd(v1, v2, N, &ipC);
    clock_gettime(CLOCK_REALTIME, &tf);
    elapsed = (tf.tv_sec - ti.tv_sec) * 1e9 + (tf.tv_nsec - ti.tv_nsec);
    printf("el tiempo en nanosegundos que toma la función en C es %lf\n", elapsed);

    clock_gettime(CLOCK_REALTIME, &ti);
    asmFloatInnerProd(v1, v2, N, &ipAsm);
    clock_gettime(CLOCK_REALTIME, &tf);
    elapsed = (tf.tv_sec - ti.tv_sec) * 1e9 + (tf.tv_nsec - ti.tv_nsec);
    printf("el tiempo en nanosegundos que toma la función en ASM es %lf\n", elapsed);

    float relerr = calcRelErr(ipC, ipAsm);

    printf("el error relativo es %f\n", relerr);

    free(v1);

    free(v2);

    return 0;
};

void initVector(float *v, int N)
{
    for (int i = 0; i < N; i++)
    {
        float e = random() % 255;
        v[i] = (sinf(e) + cosf(e));
    }
}

void cFloatInnerProd(float *v1, float *v2, int N, float *ip)
{
    int i = 0;
    float sum = 0;
    for (i = 0; i < N; i++)
    {
        sum += v1[i] * v2[i];
    }
    ip[0] = sum;
}

// error relativo de escalares:
// la idea es
// calcular el valor absoluto de la diferencia de las entradas
// calcular el valor absoluto de la referencia
// y dividir el primer valor entre el segundo
// a ese resultado se le llama el error relativo de cal respecto de ref
// mientras menor sea el resultado, mejor
float calcRelErr(float ref, float cal)
{
    return fabsf(ref - cal) / fabsf(ref);
}
```

Para crear el ejecutable y probar el programa:

```
nasm -f elf64 asmFloatInnerProd.asm -o asmFloatInnerProd.o
gcc asmFloatInnerProd.o floatInnerProd.c -o floatInnerProd -lm
./floatInnerProd
```

### Norma-2

---

Código en ensamblador que calcula norma-2 de un vector de *floats*. A esta operación, a veces, le llaman "valor absoluto de un vector", y se suele usar como operación previa para calcular el error relativo entre dos vectores.

```nasm
global asmFloatNormTwo
	section .text

asmFloatNormTwo:
	xorpd	xmm0,	xmm0
	xorpd	xmm1,	xmm1
	cmp	rdx,	0
	je	done
next:
	movss	xmm0,	[rdi]
	mulss	xmm0,	xmm0
	addss	xmm1,	xmm0
	add	rdi,	4
	sub	rsi,	1
	jnz	next	
done:
	sqrtss	xmm1,	xmm1
	movss	[rdx],	xmm1
	ret
```

Código en C para realizar las comparaciones necesarias.

```c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

extern void asmFloatNormTwo(float *v1, int N, float *n2);
void cFloatNormTwo(float *v1, int N, float *n2);

int main() {

	float *v1, n2C, n2Asm;
	int N = 1024;

	v1 = malloc(N * sizeof(float));

	int i = 0;

	for(i = 0; i < N; i++){
		v1[i] = (float)i;
	}

	cFloatNormTwo(v1, N, &n2C);
	
	asmFloatNormTwo(v1, N, &n2Asm);

	printf("%f\n%f\n",n2C,n2Asm);

        free(v1);

	return 0;
};

void cFloatNormTwo(float *v1, int N, float *n2) {
	int i = 0;
	float sum = 0;
	for(i = 0; i < N; i++) {
		sum += v1[i] * v1[i];
	}
	n2[0] = sqrtf(sum);
}
```

El ejecutable se puede crear con comandos similares a los del ejemplo anterior, solo tendría que usar los nombres correspondientes a los archivos del ejemplo. Como ejercicio, se le sugiere calcular el error relativo de los resultados obtenidos en C y ensamblador, hacer que el vector inicie con valores aleatorios entre -1.0 y 1.0 aprox, y que mostrar los tiempos de ejecución en microsegundos, así como el error calculado.