// Module to track completion of all testbenches
module complete();
    // Static variable to keep track of completed testbenches
    integer done;

    initial begin
        done = 0; // Initialize the counter
    end

    // Task to check if all testbenches are complete
    task check_done;
        begin
            done = done + 1; // Increment the counter
            if (done == 12) begin // Check if all 12 testbenches are complete
                $finish; // End the simulation
            end
        end
    endtask
endmodule