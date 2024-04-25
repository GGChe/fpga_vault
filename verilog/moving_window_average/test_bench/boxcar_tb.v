`timescale 1ns / 1ps

module boxcar_tb;

    // Parameters
    parameter IW = 16;   // Input width
    parameter LGMEM = 6; // Log2 of memory depth
    parameter OW = IW + LGMEM; // Output width

    // Testbench Signals
    reg clk;
    reg reset;
    reg i_ce;
    reg [(LGMEM-1):0] i_navg;
    reg [(IW-1):0] i_sample;
    wire [(OW-1):0] o_result;

    // Instantiate the Unit Under Test (UUT)
    boxcar #(.IW(IW), .LGMEM(LGMEM), .OW(OW)) uut (
        .i_clk(clk),
        .i_reset(reset),
        .i_navg(i_navg),
        .i_ce(i_ce),
        .i_sample(i_sample),
        .o_result(o_result)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz Clock
    end

    // Initial Setup and Stimuli
    initial begin
        // Initialize Inputs
        reset = 1;
        i_ce = 0;
        i_navg = 0;
        i_sample = 0;

        // Apply Reset
        #100;
        reset = 0;
        i_navg = 4; // Set number of averages to 4

        // Begin Test Cases
        #20;
        i_ce = 1; // Enable input capture
        i_sample = 10;
        #10; i_sample = 20;
        #10; i_sample = 30;
        #10; i_sample = 40; // Continue to input samples

        // Change the number of averages
        #50; 
        i_navg = 8;
        reset = 1; // Apply reset to change navg
        #10;
        reset = 0;
        i_sample = 25;
        #10; i_sample = 35;
        #10; i_sample = 45;
        #10; i_sample = 55; // More samples with new navg setting

        // Finish Test
        #100;
        i_ce = 0; // Stop input capture
        #30;
        $stop; // Stop simulation
    end

    // Monitor Outputs
    initial begin
        $monitor("At time %t, output = %d", $time, o_result);
    end

endmodule
