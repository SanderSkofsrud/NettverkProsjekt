// Module for elementwise multiplication of floating point numbers
module elementwise_mult_float #(
    parameter DATA_WIDTH = 32  // Default data width is 32 bits (float32)
)(
    input [4*DATA_WIDTH-1:0] a,   // Input vector 'a' with 4 elements
    input [4*DATA_WIDTH-1:0] b,   // Input vector 'b' with 4 elements
    output reg [4*DATA_WIDTH-1:0] result // Output vector 'result' with 4 elements
);
    integer i; // Loop variable
    real a_real, b_real, result_real; // Variables to hold real values for calculations
    reg [DATA_WIDTH-1:0] a_array [0:3]; // Array to hold unpacked values of 'a'
    reg [DATA_WIDTH-1:0] b_array [0:3]; // Array to hold unpacked values of 'b'
    reg [DATA_WIDTH-1:0] result_array [0:3]; // Array to hold results of elementwise multiplication

    // Function to calculate absolute value
    function real abs_real(input real val);
        begin
            if (val < 0)
                abs_real = -val;
            else
                abs_real = val;
        end
    endfunction

    // Function to convert real type to integer
    function integer rtoi_real(input real val);
        begin
            rtoi_real = val;
        end
    endfunction

    // Function to convert IEEE 754 representation to real type
    function real ieee_to_real(input [DATA_WIDTH-1:0] ieee);
        reg [22:0] fraction32; // Fraction part for float32
        reg [9:0] fraction16; // Fraction part for float16
        reg [3:0] fraction8; // Fraction part for float8
        reg [7:0] exponent32; // Exponent part for float32
        reg [4:0] exponent16; // Exponent part for float16
        reg [2:0] exponent8; // Exponent part for float8
        reg sign; // Sign bit
        real result; // Real value result
        begin
            if (DATA_WIDTH == 32) begin
                fraction32 = ieee[22:0]; // Extract the fraction part
                exponent32 = ieee[30:23] - 127; // Extract and de-bias the exponent
                sign = ieee[31]; // Extract the sign bit
                if (exponent32 == -127) begin
                    // Denormalized number case
                    result = (sign ? -1.0 : 1.0) * (fraction32 * 2.0**-23) * 2.0**-126;
                end else begin
                    // Normalized number case
                    result = (sign ? -1.0 : 1.0) * (1.0 + fraction32 * 2.0**-23) * 2.0**exponent32;
                end
            end else if (DATA_WIDTH == 16) begin
                fraction16 = ieee[9:0]; // Extract the fraction part
                exponent16 = ieee[14:10] - 15; // Extract and de-bias the exponent
                sign = ieee[15]; // Extract the sign bit
                if (exponent16 == -15) begin
                    // Denormalized number case
                    result = (sign ? -1.0 : 1.0) * (fraction16 * 2.0**-10) * 2.0**-14;
                end else begin
                    // Normalized number case
                    result = (sign ? -1.0 : 1.0) * (1.0 + fraction16 * 2.0**-10) * 2.0**exponent16;
                end
            end else if (DATA_WIDTH == 8) begin
                fraction8 = ieee[3:0]; // Extract the fraction part
                exponent8 = ieee[6:4] - 3; // Extract and de-bias the exponent
                sign = ieee[7]; // Extract the sign bit
                if (exponent8 == -3) begin
                    // Denormalized number case
                    result = (sign ? -1.0 : 1.0) * (fraction8 * 2.0**-4) * 2.0**-2;
                end else begin
                    // Normalized number case
                    result = (sign ? -1.0 : 1.0) * (1.0 + fraction8 * 2.0**-4) * 2.0**exponent8;
                end
            end
            ieee_to_real = result; // Return the real value
        end
    endfunction

    // Function to convert real type to IEEE 754 representation
    function [DATA_WIDTH-1:0] real_to_ieee(input real r);
        reg [22:0] fraction32; // Fraction part for float32
        reg [9:0] fraction16; // Fraction part for float16
        reg [3:0] fraction8; // Fraction part for float8
        reg [7:0] exponent32; // Exponent part for float32
        reg [4:0] exponent16; // Exponent part for float16
        reg [2:0] exponent8; // Exponent part for float8
        reg sign; // Sign bit
        real abs_r; // Absolute value of the real number
        integer biased_exponent; // Biased exponent
        begin
            if (r == 0.0) begin
                real_to_ieee = {DATA_WIDTH{1'b0}}; // Zero case
            end else begin
                sign = (r < 0) ? 1 : 0; // Determine the sign
                abs_r = abs_real(r); // Calculate the absolute value
                if (abs_r == 1.0/0.0) begin // Check for infinity
                    real_to_ieee = {sign, {DATA_WIDTH-1{1'b1}}, {DATA_WIDTH-1{1'b0}}}; // Infinity case
                end else if (abs_r != abs_r) begin // Check for NaN
                    real_to_ieee = {sign, {DATA_WIDTH-1{1'b1}}, {DATA_WIDTH-1{1'b1}}}; // NaN case
                end else begin
                    biased_exponent = rtoi_real($ln(abs_r) / $ln(2.0)); // Calculate biased exponent
                    if (DATA_WIDTH == 32) begin
                        exponent32 = biased_exponent + 127; // Add bias
                        fraction32 = rtoi_real((abs_r / (2.0**biased_exponent) - 1.0) * (2.0**23)); // Calculate fraction
                        real_to_ieee = {sign, exponent32, fraction32}; // Combine to form IEEE 754 representation
                    end else if (DATA_WIDTH == 16) begin
                        exponent16 = biased_exponent + 15; // Add bias
                        fraction16 = rtoi_real((abs_r / (2.0**biased_exponent) - 1.0) * (2.0**10)); // Calculate fraction
                        real_to_ieee = {sign, exponent16, fraction16}; // Combine to form IEEE 754 representation
                    end else if (DATA_WIDTH == 8) begin
                        exponent8 = biased_exponent + 3; // Add bias
                        fraction8 = rtoi_real((abs_r / (2.0**biased_exponent) - 1.0) * (2.0**4)); // Calculate fraction
                        real_to_ieee = {sign, exponent8, fraction8}; // Combine to form IEEE 754 representation
                    end
                end
            end
        end
    endfunction

    always @(*) begin
        // Unpack the input vectors 'a' and 'b' into arrays
        for (i = 0; i < 4; i = i + 1) begin
            a_array[i] = a[i*DATA_WIDTH +: DATA_WIDTH]; // Extract each element of 'a'
            b_array[i] = b[i*DATA_WIDTH +: DATA_WIDTH]; // Extract each element of 'b'
            a_real = ieee_to_real(a_array[i]); // Convert each element of 'a' to real
            b_real = ieee_to_real(b_array[i]); // Convert each element of 'b' to real
            result_real = a_real * b_real; // Perform elementwise multiplication
            result_array[i] = real_to_ieee(result_real); // Convert the result back to IEEE 754 format
        end

        // Pack the result array back into the output vector 'result'
        for (i = 0; i < 4; i = i + 1) begin
            result[i*DATA_WIDTH +: DATA_WIDTH] = result_array[i]; // Combine the results
        end
    end
endmodule