// Top-level module to instantiate and run multiple simulations in parallel
module top_module;

    // Instantiate multiple testbenches for elementwise multiplication with different float types
    tb_elementwise_mult_float #(32) tb_elem32_1(); // Instance for elementwise multiplication with float32
    tb_elementwise_mult_float #(32) tb_elem32_2(); // Another instance for elementwise multiplication with float32
    tb_elementwise_mult_float #(16) tb_elem16_1(); // Instance for elementwise multiplication with float16
    tb_elementwise_mult_float #(16) tb_elem16_2(); // Another instance for elementwise multiplication with float16
    tb_elementwise_mult_float #(8) tb_elem8_1(); // Instance for elementwise multiplication with float8
    tb_elementwise_mult_float #(8) tb_elem8_2(); // Another instance for elementwise multiplication with float8

    // Instantiate multiple testbenches for dot product with different float types
    tb_dot_product_float #(32) tb_dot32_1(); // Instance for dot product with float32
    tb_dot_product_float #(32) tb_dot32_2(); // Another instance for dot product with float32
    tb_dot_product_float #(16) tb_dot16_1(); // Instance for dot product with float16
    tb_dot_product_float #(16) tb_dot16_2(); // Another instance for dot product with float16
    tb_dot_product_float #(8) tb_dot8_1(); // Instance for dot product with float8
    tb_dot_product_float #(8) tb_dot8_2(); // Another instance for dot product with float8

endmodule