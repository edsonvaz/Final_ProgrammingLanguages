#include <stdio.h>
#include "cuda_runtime.h"
#include <stdlib.h>
#include <time.h>
#define N 50
#define NumBlocks  (ThreadsPerBlock + (N*M-1))/ThreadsPerBlock
#define THREADS_PER_BLOCK 512   //size of block

__device__ void suddenDeath(double m[2][2], int n, int *attacker, int f1,int f2, char g1, char g2){
    for (int i = 0; i < n; ++i)
    {
        if(f1 == 0){
            printf("\nGroup %c is annihilated!\n\n",g1);
            printf("==================================\nGroup %c is the winner!\n==================================\n",g2);
            return;
        }else if(f2 == 0){
            printf("\nGroup %c is annihilated!\n\n",g2);
            printf("==================================\nGroup %c is the winner!\n==================================\n",g1);
            return;
        }

        if(i%2==0){
        *attacker = 0;
        }else{
            *attacker = 1;
        }

        switch(*attacker){
            case 0:
                    f2 -= 1;
                    printf("\nGroup %c attacked group %c!\n", g1,g2);
                    printf("Number of warriors for each group\nGroup %c: %i\nGroup %c: %i\n",g1,f1, g2,f2);
                break;
            case 1:
                    f1 -= 1;
                    printf("\nGroup %c attacked group %c!\n", g2,g1);
                    printf("Number of warriors for each group\nGroup %c: %i\nGroup %c: %i\n",g1,f1, g2,f2);
                break;
        }


    }
}

__global__ void monteCarlo(double m[3][3], int n, double *rand, int *attacker, int f0, int f1, int f2){
    double x;
    char zero='0', one='1', two='2';

    double newFactions[2][2] = {
            {0.0, 1.0},
            {1.0, 0.0},
    };

        if(f0 == 0){
            printf("\nGroup 0 is annihilated!\n");
            printf("==================================\nReconfiguring stochastic matrix\n");
            suddenDeath(newFactions,n, attacker,f1,f2,one, two);
        }else if(f1 == 0){
            printf("\nGroup 1 is annihilated!\n");
            printf("==================================\nReconfiguring stochastic matrix\n");
            suddenDeath(newFactions,n, attacker,f0,f2, zero,two);
        }else if(f2 == 0){
            printf("\nGroup 2 is annihilated!\n");
            printf("==================================\nReconfiguring stochastic matrix\n");
            suddenDeath(newFactions,n, attacker, f0,f1, zero, one);
        }

        switch(*attacker){
            case 0:
                x = m[0][1];

                if (*rand > 0.0 && *rand <= x){
                    f1 -= 1;
                    printf("\nGroup %i attacked group 1!\n", *attacker);
                    printf("Number of warriors for each group\nGroup 0: %i\nGroup 1: %i\nGroup 2: %i\n",f0, f1,f2);
                }else{
                    f2 -= 1;
                    printf("\nGroup %i attacked group 2!\n", *attacker);
                    printf("Number of warriors for each group\nGroup 0: %i\nGroup 1: %i\nGroup 2: %i\n",f0, f1,f2);
                }

                break;
            case 1:
                x = m[1][0];

                if (*rand > 0.0 && *rand <= x){
                    f0 -= 1;
                    printf("\nGroup %i attacked group 0!\n", *attacker);
                    printf("Number of warriors for each group\nGroup 0: %i\nGroup 1: %i\nGroup 2: %i\n",f0, f1,f2);
                }else{
                    f2 -= 1;
                    printf("\nGroup %i attacked group 2!\n", *attacker);
                    printf("Number of warriors for each group\nGroup 0: %i\nGroup 1: %i\nGroup 2: %i\n",f0, f1,f2);
                }

                break;
            case 2:
                x = m[2][0];

                if (*rand > 0.0 && *rand <= x){
                    f0 -= 1;
                    printf("\nGroup %i attacked group 0!\n", *attacker);
                    printf("Number of warriors for each group\nGroup 0: %i\nGroup 1: %i\nGroup 2: %i\n",f0, f1,f2);
                }else{
                    f1 -= 1;
                    printf("\nGroup %i attacked group 1!\n", *attacker);
                    printf("Number of warriors for each group\nGroup 0: %i\nGroup 1: %i\nGroup 2: %i\n",f0, f1,f2);
                }

                break;
        }

}

double rands(double min, double max)
{
    double range = (max - min);
    double div = RAND_MAX / range;
    return min + (rand() / div);
}

int whoAttacks(int n, int min, int max){
    return n + rand() % (max + 1 - min) + 0;
}

void printMatrix(double m[3][3]) {
    printf("\n");
    for (int row = 0; row < 3; row++) {
        for (int column = 0; column < 3; column++) { printf("%.1f  ", m[row][column]); }
        printf("\n");
    }
}

int main(){
    int WA=5,WB=5,WC=5;

    //initial matrix
    double factions[3][3] = {
            {0.0, 0.7, 0.3},
            {0.4, 0.0, 0.6},
            {0.6, 0.4, 0.0}
    };

    printMatrix(factions);

    //initial warriors
    printf("\nNumber of warriors for each group\nGroup 0: %i\nGroup 1: %i\nGroup 2: %i\n",WA, WB,WC);
    printf("==================================\n");

    double size = sizeof(double);
    double *a, *rand;
    double *d_rand;
    int *attacker, *d_attacker;

    //reserve device memory
    cudaMalloc((void**)&d_rand, size);
	cudaMalloc((void**)&d_attacker, sizeof(int));

    //reserve host memory
    a = (double*)malloc(size);
    rand = (double*)malloc(size);
    attacker = (int*)malloc(sizeof(int));

    //things needed in order for the random numbers to work properly
    srand (time ( 0));
    *a = rands(0.0, 1.0);

    //MONTE CARLO FUNCTION
    for (int i = 0; i < N; ++i)
    {
        *attacker = whoAttacks(0,0,2);
        *rand = rands(0.0, 1.0);

        cudaMemcpy(d_rand, rand, size, cudaMemcpyHostToDevice);
	    cudaMemcpy(d_attacker, attacker, size, cudaMemcpyHostToDevice);

        monteCarlo << <N*N / THREADS_PER_BLOCK,  THREADS_PER_BLOCK >> >(factions, N, d_rand, d_attacker, WA,WB,WC);
    }
    
    //we clean the memory
    free(a);
    free(rand);
    free(attacker);

    return 0;
}
