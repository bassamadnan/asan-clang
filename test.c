#include <stdlib.h>

int main() {
    int *array = (int*)malloc(10 * sizeof(int));
    
    // should be caught by ASan
    array[10] = 42;  
    
    free(array);
    return 0;
}