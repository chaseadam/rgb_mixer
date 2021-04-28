`default_nettype none
`timescale 1ns/1ns
module encoder #(
    parameter OUT_WIDTH = 8,
    parameter INCREMENT = 1'b1
)(
    input clk,
    input reset,
    input a,
    input b,
    output reg [OUT_WIDTH-1:0] value
);

    // make equivalent of binary value full of "ones" (i.e. 8'b11111111)
    //localparam on_value = 2 ** COUNTER_WIDTH - 1;
    //reg [COUNTER_WIDTH-1:0] counter;
    reg [3:0] rotary; 
    reg [3:0] rotary_history;

    always @(posedge clk) begin
        if( reset ) begin
            value <= {OUT_WIDTH{1'b0}};
            rotary <= 4'b0000;
            rotary_history <= 4'b0000;
        end else begin
            // load up new rotary values (A position 3 and B position 1)
            // WARNING: we pre load the rotary with "zero" which may cause
            // issues with first transition? 

            // shift values into "old" values
            // commented out because we are shifting as part of "A" capture
            //rotary[2:2] <= rotary[3:3]
            //rotary[0:0] <= rotary[1:1]
            
            if ( a != rotary_history[2:2] )
                // add new A value, shift old A value and leave B values as is
                rotary <= {a,rotary_history[3:3], rotary_history[1:0]};
            if ( b != rotary_history[0:0] )
                // keep A values as is, set B value and shift B value (could
                // just use inverted value as we would only get here if
                // B changed)
                rotary <= {rotary[3:2], b, rotary[1:1]};
            if ( rotary != rotary_history )
                if ( rotary == 4'b1000 | rotary == 4'b0111 )
                    value <= value + INCREMENT;
                else if ( rotary == 4'b0010 | rotary == 4'b1101 )
                    value <= value - INCREMENT;
                rotary_history <= rotary;
        end
    end
endmodule
