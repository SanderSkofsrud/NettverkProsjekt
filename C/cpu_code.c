/**
 * @file vector_operations.c
 * @brief This file contains functions for elementwise multiplication and dot product of vectors,
 *        and measures the time taken for these operations over a large number of repetitions.
 */

#include <stdio.h>
#include <time.h>

/**
 * @brief Multiplies two vectors element-wise.
 *
 * This function takes two input vectors `a` and `b`, multiplies them element-wise, and stores the
 * result in the `result` vector. The size of the vectors is specified by `size`.
 *
 * @param a Pointer to the first input vector.
 * @param b Pointer to the second input vector.
 * @param result Pointer to the output vector where the result of element-wise multiplication will be stored.
 * @param size The number of elements in the vectors.
 */
void elementwise_mult(const float *a, const float *b, float *result, int size) {
    for (int i = 0; i < size; i++) {
        result[i] = a[i] * b[i];
    }
}

/**
 * @brief Computes the dot product of two vectors.
 *
 * This function takes two input vectors `a` and `b`, computes their dot product, and stores the
 * result in the variable pointed to by `result`. The size of the vectors is specified by `size`.
 *
 * @param a Pointer to the first input vector.
 * @param b Pointer to the second input vector.
 * @param result Pointer to the float variable where the dot product result will be stored.
 * @param size The number of elements in the vectors.
 */
void dot_product(const float *a, const float *b, float *result, int size) {
    *result = 0;
    for (int i = 0; i < size; i++) {
        *result += a[i] * b[i];
    }
}

/**
 * @brief Main function to demonstrate the use of elementwise_mult and dot_product functions.
 *
 * This function initializes two vectors and measures the time taken for element-wise multiplication
 * and dot product operations over a large number of repetitions. It prints the average time per
 * iteration for both operations.
 *
 * @return int Returns 0 upon successful execution.
 */
int main() {
    // Define the size of the vectors
    int size = 4;

    // Initialize two vectors with predefined values
    float a[] = {1.0, 2.0, 3.0, 4.0};
    float b[] = {0.5, 1.0, 1.5, 2.0};

    // Array to store the result of element-wise multiplication
    float result_mult[size];

    // Variable to store the result of dot product
    float result_dot;

    // Variables to measure time
    clock_t start, end;
    double cpu_time_used;

    // Number of repetitions for the timing measurement
    int repetitions = 1000000;

    // Measure time for element-wise multiplication
    start = clock();
    for (int i = 0; i < repetitions; i++) {
        elementwise_mult(a, b, result_mult, size);
    }
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC / repetitions;
    printf("Elementwise Multiplication Time per iteration: %e seconds\n", cpu_time_used);

    // Measure time for dot product
    start = clock();
    for (int i = 0; i < repetitions; i++) {
        dot_product(a, b, &result_dot, size);
    }
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC / repetitions;
    printf("Dot Product Time per iteration: %e seconds\n", cpu_time_used);

    return 0;
}
