// Testbench module for dot product with floating point numbers
module tb_dot_product_float #(parameter DATA_WIDTH = 32);

    reg [4*DATA_WIDTH-1:0] a; // Register to hold the first input vector 'a' with 4 elements
    reg [4*DATA_WIDTH-1:0] b; // Register to hold the second input vector 'b' with 4 elements
    wire [DATA_WIDTH-1:0] result; // Wire to hold the result of the dot product

    // Instantiate the dot product module
    dot_product_float #(DATA_WIDTH) uut (
        .a(a),
        .b(b),
        .result(result)
    );

    complete finish_checker(); // Instance of the complete module to check when all testbenches are done

    initial begin
        // Initialize input vectors 'a' and 'b' with appropriate values based on DATA_WIDTH
        if (DATA_WIDTH == 32) begin
            // Example values for float32
            a = {32'h3f800000, 32'h40000000, 32'h40400000, 32'h40800000}; // [1.0, 2.0, 3.0, 4.0] in IEEE 754 format
            b = {32'h3f000000, 32'h3f800000, 32'h40000000, 32'h40400000}; // [0.5, 1.0, 2.0, 3.0] in IEEE 754 format
            #10; // Wait for results to stabilize
            // Display the results
            $display("float32 - a = [%h, %h, %h, %h], b = [%h, %h, %h, %h], result = %h, time = %0t",
                a[127:96], a[95:64], a[63:32], a[31:0],
                b[127:96], b[95:64], b[63:32], b[31:0],
                result, $time);
        end else if (DATA_WIDTH == 16) begin
            // Example values for float16
            a = {16'h3c00, 16'h4000, 16'h4200, 16'h4400}; // [1.0, 2.0, 3.0, 4.0] in IEEE 754 format
            b = {16'h3800, 16'h3c00, 16'h4000, 16'h4200}; // [0.5, 1.0, 2.0, 3.0] in IEEE 754 format
            #10; // Wait for results to stabilize
            // Display the results
            $display("float16 - a = [%h, %h, %h, %h], b = [%h, %h, %h, %h], result = %h, time = %0t",
                a[63:48], a[47:32], a[31:16], a[15:0],
                b[63:48], b[47:32], b[31:16], b[15:0],
                result, $time);
        end else if (DATA_WIDTH == 8) begin
            // Example values for float8
            a = {8'h3c, 8'h40, 8'h44, 8'h48}; // [1.0, 2.0, 3.0, 4.0] in IEEE 754 format
            b = {8'h38, 8'h3c, 8'h40, 8'h44}; // [0.5, 1.0, 2.0, 3.0] in IEEE 754 format
            #10; // Wait for results to stabilize
            // Display the results
            $display("float8 - a = [%h, %h, %h, %h], b = [%h, %h, %h, %h], result = %h, time = %0t",
                a[31:24], a[23:16], a[15:8], a[7:0],
                b[31:24], b[23:16], b[15:8], b[7:0],
                result, $time);
        end

        // Call the task to check completion
        finish_checker.check_done();
    end
endmodule