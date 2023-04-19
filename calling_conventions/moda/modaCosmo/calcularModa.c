#include <stdio.h>
//                               rdi     rsi      rdx
extern void calcularModaASM(int *arr, int n, int *moda);
void calcularModaC(int *arr, int n, int *moda);

int main() {
    int arr[20] = {7,3,7,4,1,7,1,2,7,1,7,1,7,1,3,7,6,5,4,5}, n=20, moda;
	calcularModaC(arr, n, &moda);
    calcularModaASM(arr, n, &moda);
    printf("Moda C:   %d\n", moda);
    calcularModaASM(arr, n, &moda);
    printf("Moda ASM: %d\n", moda);
    return 0;
}

void calcularModaC(int *arr, int n, int *moda) {
    int mayor=0, cantidad, num;
    for (int i=0; i<n; i++) {
        cantidad=0;
        for (int j=i+1; j<n; j++) 
            if (arr[j]==arr[i])
                cantidad++;
        if (cantidad>mayor) {
            mayor = cantidad;  
            (*moda) = arr[i];          
        }
    }
}