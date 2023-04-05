# iee240
Repositorio del curso de Organización y Arquitectura de Computadoras.
- x86 and amd64 instruction reference: https://www.felixcloutier.com/x86/
- Wiki del curso: https://github.com/stefano-sosac/iee240-learning-material/wiki/

# Lenguaje ensamblador

# Formato de código ensamblador

---

Se empleará *nasm* y el **ensamblador de intel.**

- Sección `.data` donde los datos iniciales son declarados y definidos.
- Sección `.bss` donde se declaran y definen variables sin valor inicial.
- Sección `.text` donde se colocan las instrucciones del código.

## Valores Numéricos

---

Los valores numéricos pueden ser especificados en formato decimal, octal o hexadecimal. En *nasm*, por defecto, se emplea la base decimal.

1. Octal: `q` al final.
2. Hexadecimal: `0x` al inicio.

## Definiciones

---

Estas son substituidas por sus valores definidos durante el proceso de ensamblaje. Para realizar una definición se emplea la directiva `.equ`.

## Sección `.data`

---

En esta sección se ubican las variables y constantes que pueden ser leídas por todo el código (globales). Al ser declaradas se debe indicar su nombre, tipo de dato y valor inicial. Los tipos de datos que soporta *nasm* son los siguientes:

| Declaración | Significado |
| --- | --- |
| db | Variable de 8 bits |
| dw | Variable de 16 bits |
| dd | Variable de 32 bits |
| dq | Variable de 64 bits |

## Sección `.bss`

---

En esta sección se ubican las variables que no tienen valores iniciales. En este caso el valor que acompaña al tamaño indica la cantidad de elementos que se solicitan.

| Declaración | Significado |
| --- | --- |
| resb | Variable de 8 bits |
| resw | Variable de 16 bits |
| resd | Variable de 32 bits |
| resq | Variable de 64 bits |

## Sección `.text`

---

En esta sección se especifican las instrucciones. Se deberán incluir algunas etiquetas que definan al programa inicial. Por ejemplo, asumiendo un programa básico que emplea al enlazador `ld`, se deberá incluir la siguiente expresión:

```nasm
section .text
    global _start
_start
```

# Registros

---

La memoria de un ordenador es esencialmente un arreglo de bytes que el software emplea para instrucciones y datos. Los registros son un tipo especial de memoria que permiten al CPU accesar a datos de forma muy rápida. Los CPUs x86-64 tienen 16 registros de propósito general de 64 
bits y 16 registros especiales para datos en coma flotante. La lista de registros que se pueden emplear es la siguiente:

| 64-bits | 32-bits | 16-bits | 8-bits | Significado |
| --- | --- | --- | --- | --- |
| rax | eax | ax | al | Acumulador |
| rbx | ebx | bx | bl | Base |
| rcx | ecx | cx | cl | Contador |
| rdx | edx | dx | dl | Datos |
| rsi | esi | si | sil | Source Index |
| rdi | edi | di | dil | Destination Index |
| rbp | ebp | bp | bpl | Base Pointer |
| rsp | esp | sp | spl | Stack Pointer |
| r8 | r8d | r8w | r8b | Propósito General |

La tabla se puede extender con los registros de propósito general que fueron añadidos al procesor cuando se extendió a 64 *bits*, y van desde r8 hasta r15 que tienen las mismas características que r8 en la tabla. Otra observación que se debe hacer es que `rax`, `eax`, `ax` y `al` son porciones de un mismo registro. La imagen, a continuación, ilustra la relación entre estos:

[El gráfico aplica para todos los registros del procesador.](https://camo.githubusercontent.com/b8ba5ec049bac157cc40953bf3baa20a6bce4e33044d2a196520f3c9368a239e/68747470733a2f2f692e737461636b2e696d6775722e636f6d2f66465346332e706e67)

El gráfico aplica para todos los registros del procesador.

## Registros de banderas

---

El registro de banderas se llama `rflags` y es de 64 bits, pero solo se emplean 32 bits, por lo que para referirse a este registro es suficiente con `eflags`.

| Bandera | Descripción |
| --- | --- |
| CF | Carry Flag (Bandera de acarreo) |
| PF | Parity Flag (Bandera de paridad) |
| ZF | Zero Flag (Bandera de cero) |
| SF | Sign Flag (Bandera de signo) |
| OF | Overflow Flag (Bandera de desborde) |
| AF | Adjust Flag (Bandera de ajuste) |
| IF | Interrupt Enable Flag (Bandera para habilitar interrupciones) |

Por lo general, el registro de banderas no es modificado directamente por el programador [↑](https://github.com/stefano-sosac/iee240-learning-material/wiki/Lenguaje-ensamblador#contenidos).

# Modos de direccionamiento

---

Un modo de direccionamiento es una expresión que calcula una dirección en la memoria para leer o escribir. El siguiente código demuestra como escribir el valor inmediato `1` en varias ubicaciones de memoria usando la instrucción `mov` en un ejemplo para cada uno de los modos de direccionamiento disponible.

```nasm
mov 0x604892,      1 ; modo directo (la dirección es un valor constante)
mov [rax],         1 ; modo indirecto (la dirección está en un registro)
mov [rbp-24],      1 ; modo indirecto con desplazamiento
mov [rsp+8+4*rdi], 1 ; modo indirecto con desplazamiento y escalamiento
mov [rsp+4*rdi],   1 ; modo indirecto con desplazamiento 0
mov [8+4*rdi],     1 ; modo indirecto con base 8
mov [rsp+8+rdi],   1 ; modo indirecto con escalamiento 1
```

# Llamadas al sistema

---

Cuando un programa necesita hacer una operación de lectura o escritura, se realiza una llamada al sistema. Una llamada al sistema es una llamada a  función que cambia el CPU a modo *kernel* y ejecuta una función que es parte del *kernel*. Los parámetros de las llamadas al sistema se indican en registros específicos. La siguiente tabla muestra los argumentos, y el registro asociado a cada uno:

| Registro | Uso |
| --- | --- |
| rax | ID de la llamada al sistema |
| rdi | Primer argumento |
| rsi | Segundo argumento |
| rdx | Tercer argumento |
| r10 | Cuarto argumento |
| r8 | Quinto argumento |
| r9 | Sexto argumento |

Dependiendo de la llamada al sistema que se está realizando la cantidad de parámetros variará; sin embargo, se debe tener en cuenta que el ID de la llamada al sistema siempre se deberá indicar. Las llamadas al sistema en x64 salvan el registro que apunta a la instrucción `rip` en `rcx` y luego salvan el registro de banderas en el registro `r11`, no modifican nada en la pila, ni alteran el valor de `rsp`. Tenga en cuenta esto al usar `syscall`, porque estos registros volverán con valores modificados.

Luego de que los parámetros estén fijos, se deberá ejecutar la instrucción `syscall`. Esta instrucción pondrá el programa en pausa, y le dará el control al sistema operativo, el cual ejecutará la llamada indicada en el registro `rax`. 

# Conjunto de instrucciones

---

Las instrucciones serán presentadas por funcionalidad y en el siguiente orden:

- Instrucciones para mover datos
- Instrucciones aritméticas
- Instrucciones lógicas
- Instrucciones de control

## Instrucciones para mover datos

---

Con la instrucción `mov` se pueden mover constantes, direcciones y contenidos de posiciones de memoria a registros, mover datos de un registro a otro y mover datos de un registro a una posición de memoria.

```nasm
mov rax, 100 ; rax <- 100
mov rax, a   ; rax <- a
mov rax, [a] ; rax <- el contenido de la dirección a
mov [a], rax ; el valor de rax se escribe en el contenido de la dirección a 
mov rax, rbx ; rax <- rbx
```

Cuando realizamos un acceso a memoria, la mayoría de veces el tamaño del operando es obvio. Por ejemplo, la siguiente instrucción:

```nasm
mov eax, [rbx]
```

Mueve una palabra doble (32 bits); sin embargo, en algunos casos puede haber confusión sobre el tamaño del operando. Por ejemplo:

```nasm
inc [rbx]
```

Debido a que el tamaño del operando no está claro, se recomienda emplear un **calificador de tamaño** para que quede claro el tamaño del operando. Los calificadores pueden ser: byte, word, dword y qword. Con esta aclaración, el ejemplo anterior queda de la siguiente manera:

```nasm
inc byte [rbx]
```

De esta forma, el ensamblador sabe que solo debe incrementar un byte.

## Instrucciones aritméticas

---

Estas instrucciones permiten ejecutar operaciones de suma, resta, multiplicación y división sobre valores enteros.

```nasm
inc rax      ; rax <- rax + 1
add rax, rbx ; rax <- rax + rbx
dec rax      ; rax <- rax - 1
sub rax, rbx ; rax <- rax - rbx
```

Cuando se usan estas instrucciones, se recomienda que los operandos sean del mismo tamaño.

<aside>
💡 Multiplicación en Assembly

```nasm
mul cx        ; ax = ax * cx   ; actually dx:ax = ax * cx
```

</aside>

## Instrucciones lógicas

---

Estas instrucciones permiten ejecutar operaciones del álgebra de Boole, bit a bit entre los operandos.

```nasm
neg rax      ; rax <- ! rax
and rax, rbx ; rax <- rax && rbx
or  rax, rbx ; rax <- rax || rbx
xor rax, rbx ; rax <- rax xor rbx
```

Cuando se usan estas instrucciones, se recomienda que los operandos sean del mismo tamaño.

## Saltos sin condición

---

Permite un salto a una etiqueta específica del programa. Para esto se emplea la instrucción `jmp`.

```nasm
jmp loopStart ; saltar a la etiqueta loopStart
jmp ifDone    ; saltar a la etiqueta ifDone
jmp end       ; saltar a la etiqueta end
```

La etiqueta puede estar en cualquier lugar del segmento `.text`.

## Saltos con condición

---

El salto especial se ejecutará dependiendo del resultado de la operación de comparación, el cual será almacenado en el registro de banderas.

| Instrucción | Resultado de cmp a, b |
| --- | --- |
| je | a == b |
| jne | a != b |
| jg | a > b |
| jge | a >= b |
| jl | a < b |
| jz | a == 0 |
| jnz | a != 0 |

Ejemplo:

```nasm
; si rax es menor o igual que rbx
; saltar a la etiqueta notNewMax
cmp rax, rbx
jle notNewMax
```

## Iteraciones

---

Se puede implementar un bucle básico que consiste en un contador que se verifica en la parte inferior o superior de un bucle con un salto de comparación y condicional.

Por ejemplo, asuma que la siguiente porción de código está dentro de un programa:

```nasm
cant    dq  15      ; cantidad de iteraciones
suma    dq  0       ; suma
```

Esta otra porción de código acumulará los enteros impares del 1 al 30:

```nasm
    mov     rcx,    qword [cant]    ; contador de iteraciones
    mov     rax,    1               ; registro de impares
sumLoop:
    add     qword [suma], rax       ; acumulando
    add     rax,    2               ; siguiente impar
    dec     rcx
    cmp     rcx,    0               ; 
    jne     sumLoop
```

Existe una instrucción especial que emplea el registro rcx e instrucciones de comparación para iterar: `loop`. Su formato general de uso es el siguiente:

```nasm
loop <etiqueta>
```

La instrucción decrementará el registro `rcx`, lo comparará con 0 y saltará a la etiqueta indicada en caso `rcx` sea distinto de cero. La etiqueta debería estar definida solo una vez y el registro `rcx` no debería ser reescrito durante su uso.

Por ejemplo, el código anterior se puede reescribir de la siguiente manera:

```nasm
    mov     rcx,    qword [cant]    ; contador de iteraciones
    mov     rax,    1               ; registro de impares
sumLoop:
    add     qword [suma], rax       ; acumulando
    add     rax,    2               ; siguiente impar
    loop     sumLoop
```

La instrucción `loop` está limitada al registro `rcx` y no es recomendada para lazos anidados.

# **El depurador de GNU**

---

GDB (*GNU Project debugger*) puede realizar una serie de tareas que permiten la correcta depuración del código fuente. Entre ellas tenemos:

- Iniciar un programa especificando las condiciones que puedan afectar su funcionamiento.
- Detener el programa cuando alguna condición se cumpla.
- Examinar cuál es el estado de las variables cuando el programa se detiene.
- Experimentar con los errores para su correcta depuración.

## Programa de ejemplo

---

Se hará una presentación general de los comandos que nos servirán para hacer un seguimiento del programa con el siguiente ejemplo:

```nasm
; para ensamblar:
; nasm -f elf64 -g ejemplo_gdb.asm -o ejemplo_gdb.o
; para enlazar:
; ld ejemplo_gdb.o -o ejemplo_gdb
        segment .data
a       dd      4   
b       dd      1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8,9.9
btam    dd      9
c       dw      1,2 
e       db      "hola mundo",10,0
f       equ     $-e 

        segment .bss
g       resb    1   
h       resw    10  
i       resq    100 

        segment .text
        global _start

_start:
    
        mov     rax, 1
        mov     rdi, 1
        mov     rsi, e
        mov     rdx, f
        syscall
    
        mov     rax, 60
        mov     rdi, 0
        syscall
```

## Primeros comandos con GDB

---

Antes de ejecutar el depurador, debe estar seguro de que ha colocado la bandera `-g` en el momento de generar el ejecutable. Para correr el depurador con nuestro programa ejemplo deberá ejecutar el siguiente comando:

```nasm
gdb ejemplo_gdb
```

- Dentro de GDB ya puede empezar a ejecutar comandos para la depuración. Para hacer seguimiento de los comandos ejecutados:
    
    ```nasm
    set trace-commands on
    ```
    
- Para guardar las salidas de los comandos ejecutados en un archivo de salida:
    
    ```nasm
    set logging file commands.txt
    ```
    
- Para empezar a guardar los resultados:
    
    ```nasm
    set logging on
    ```
    
- Para fijar un punto de quiebre en el código:
    
    ```nasm
    break _start
    ```
    

Esta sentencia, en general, debe indicar el comando `break` y la **etiqueta** en la que se desea hacer la pausa. También puede fijar un punto de quiebre indicando el número de línea. (En caso sea un programa en ensamblador, debe ser una línea del segmento `.text`)

Para fijar un punto de quiebre en la línea 23:

```nasm
b 23
```

O para fijar un punto de quiebre en la línea 24:

```nasm
b 24
```

- Para ver la información de los *breakpoints*:
    
    ```nasm
    info break
    ```
    
- Para borrar un *breakpoint*:
    
    ```nasm
    delete 2 3
    ```
    

Para este comando basta con indicar el número del *breakpoint* luego de `delete`. Luego, podemos verificar que se han borrado volviendo a ejecutar el comando `info`.

- Para ejecutar el código:

```nasm
run
```

Si se han fijado *breakpoints* el programa se ejecutará hasta el primero de estos, en caso contrario ejecutará todo el programa.

- Para fijar la sintaxis del *dissassembly*:

```nasm
set disassembly-flavor intel
```

- Para mostrar el *disassembly*:

```nasm
disassemble
```

También puede usar la forma corta `disass`.

Este comando muestra el código ensamblado y su lugar en la memoria de cada instrucción. La flecha en la parte izquierda indica la instrucción en la que se encuentra y **aún no ha ejecutado**.

- Para mostrar variables:
    
    ```nasm
    info variables
    ```
    
- Para **ver** la siguiente instrucción:
    
    ```nasm
    x/i $pc
    ```
    
- Para **ejecutar** la siguiente instrucción:
    
    ```nasm
    nexti
    ```
    

También puede usar su forma corta `ni`.

- Para definir un símbolo con un valor:
    
    ```nasm
    set $raxval=$rax
    ```
    

En este caso se ha definido un símbolo `$raxval` que tiene el valor del registro `rax` en el momento que se definió el símbolo. Debe tener en cuenta que si el valor de `rax` cambia el valor del símbolo no cambiará, y si usted desea que cambie con el nuevo valor, deberá actualizar el símbolo ejecutando otra vez el comando `set`. Este comando también se pudo haber realizado con variables definidas en el segmento de datos, por ejemplo:

```nasm
set $aval=(int)a
```

Por último, mencionar que también lo pudo haber efectuado con un valor constante.

## **Comandos para seguimiento de registros**

---

- Para mostrar la información de los registros de propósito general:
    
    ```nasm
    info registers
    ```
    

También tiene una forma corta:

```nasm
i r
```

- Para mostrar la información de un registro específico:
    
    ```nasm
    i r rax
    ```
    

También puede indicar una lista de registros:

```nasm
i r rax rbx rcx
```

- Para mostrar la información de todos los registros:
    
    ```nasm
    i all-registers
    ```
    
- Para mostrar la información de los registros de la unidad SIMD:
    
    ```nasm
    p $xmm0
    ```
    

El mismo comando se puede usar para todos los registros de la unidad, desde `xmm0` hasta `xmm15`. Este comando será más útil cuando emplee operaciones en coma flotante.
