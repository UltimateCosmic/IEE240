#include <stdio.h>

void quickSort(int arr[], int inicio, int fin);
int particion(int arr[], int inicio, int fin);
void intercambiarInt(int *a, int *b);
int getCMode(int arr[], int n);
extern int getAsmMode(int arr[], int n);

int main(){
    int arr1[20] = {4, 1, 1, 4, 6, 1, 3, 1, 9, 2, 9, 2, 9, 0, 6, 3, 7, 7, 1, 5};
    int arr2[20] = {4, 1, 1, 4, 6, 1, 3, 1, 9, 2, 9, 2, 9, 0, 6, 3, 7, 7, 1, 5};
    int asmMode, cMode;

    asmMode = getAsmMode(arr1, 20);
    
    quickSort(arr2, 0, 20);
    cMode = getCMode(arr2, 20);

    printf("Elementos ordenados del arreglo:\n");
    for(int i = 0; i < 20; i++){
        printf("%d ", arr1[i]);
    }

    printf("\nElementos ordenados del arreglo:\n");
    for(int i = 0; i < 20; i++){
        printf("%d ", arr2[i]);
    }
    
    printf("\n\nModa hallada en C: %d", cMode);
    printf("\nModa hallada en ASM: %d\n", asmMode);

    return 0;
}

void quickSort(int arr[], int inicio, int fin){
    if(inicio >= fin)
        return;
    
    int div = particion(arr, inicio, fin);
    quickSort(arr, inicio, div - 1);
    quickSort(arr, div + 1, fin);
}

int particion(int arr[], int inicio, int fin){
    int pivote = arr[fin];
    int i = inicio;
  
    for (int j = inicio; j <= fin - 1; j++)
        if (arr[j] <= pivote) {
            intercambiarInt(&arr[i], &arr[j]);
            i++;
        }

    intercambiarInt(&arr[i], &arr[fin]);
    return i;
}

void intercambiarInt(int *a, int *b) {
    int aux = (*a);
    (*a) = (*b);
    (*b) = aux;
}

int getCMode(int arr[], int n){
    int i, contCand = 0, contMayor = 0, indMayor;

    for(i = 0; i < n; i++){
        if(i > 0 && arr[i] != arr[i-1]){
            if(contCand > contMayor){
                indMayor = i - 1;
                contMayor = contCand;
            }
            contCand = 0;
        }
        contCand++;
    }
    if(contCand > contMayor){
        indMayor = i - 1;
        contMayor = contCand;
    }

    return arr[indMayor];
}
