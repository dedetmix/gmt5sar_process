// Program to print all combination of size r in an array of size n
// source code: geeksforgeeks.org [Bateesh] modified by Noorlaila Isya (2017)

#include <stdio.h>
#include <stdlib.h>

void combinationUtil(int arr[], int data[], int start, int end, 
                     int index, int r);
 
// The main function that prints all combinations of size r
// in arr[] of size n. This function mainly uses combinationUtil()
void printCombination(int arr[], int n, int r)
{

    // A temporary array to store all combination one by one
    int data[r];
 
    // Print all combination using temporary array 'data[]'
    combinationUtil(arr, data, 0, n-1, 0, r);

}
 
/* arr[]  ---> Input Array
   data[] ---> Temporary array to store current combination
   start & end ---> Staring and Ending indexes in arr[]
   index  ---> Current index in data[]
   r ---> Size of a combination to be printed */
void combinationUtil(int arr[], int data[], int start, int end,
                     int index, int r)
{
    FILE *result_combination;
    result_combination =  fopen("result_combination.txt","a");
// Current combination is ready to be printed, print it
    if (index == r)
    {
        for (int j=0; j<r; j++)
        fprintf(result_combination,"%d ", data[j]);
        fprintf(result_combination,"\n");
        return;
    }

    // replace index with all possible elements. The condition
    // "end-i+1 >= r-index" makes sure that including one element
    // at index will make a combination with remaining elements
    // at remaining positions
    for (int i=start; i<=end && end-i+1 >= r-index; i++)
    {
        data[index] = arr[i];
        combinationUtil(arr, data, i+1, end, index+1, r);

        // Remove duplicates
        while (arr[i] == arr[i+1])
             i++;
    }
    fclose(result_combination);
}
 
// Driver program to test above functions
int main(int argc, char **argv, int *arr)
{
    FILE *indate;

    /* reading in some parameters and open corresponding files */
    indate = fopen(argv[1],"r+");

    if (indate == NULL) {
        printf("Couldn't open the file.");
        return 1;
    }

    char tmp1[200];
    int i,n;
	i=0;
        while(fscanf(indate, "%s", &tmp1[0])) 
	{
		if (feof(indate)) break;
                arr[i]=atoi(tmp1);
                i=i+1;
        }
	printf ("number of i = %i \n", i);

    int r = 2;
//  int n = sizeof(arr)/sizeof(arr[0]);
    n = i;
    printf ("size of date array = %i \n", n);
    

    char filename[] = "result_combination.txt";
    remove(filename);

    printCombination(arr, n, r);

}
