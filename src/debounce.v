`default_nettype none
`timescale 1ns/1ns
module debounce #( parameter COUNTER_WIDTH = 8 )(
    input wire clk,
    input wire reset,
    input wire button,
    output reg debounced
);
    // make equivalent of binary value full of "ones" (i.e. 8'b11111111)
    localparam on_value = 2 ** COUNTER_WIDTH - 1;
    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk) begin
        if(reset) begin
            counter <= {COUNTER_WIDTH{1'b0}};
            debounced <= 1'b0;
        end else begin
            // shortcut to adding to shift register
            //counter <= {counter[6:0],button};
            // Long form add to shift register, {} is a concatenate
            // Results in synthesis passing around 
            // COUNTER_WIDTH - 1 bitwidth...
            if(button)
                counter <= {counter[COUNTER_WIDTH-2:0],1'b1};
            else
                counter <= {counter[COUNTER_WIDTH-2:0],1'b0};
            if(counter == on_value)
                debounced <= 1'b1;
            // This gets converted to a "not" logic check in synthesis
            // nested {{}} is "replication" operator
            else if(counter == {COUNTER_WIDTH{1'b0}})
                debounced <= 1'b0;
        end
    end
endmodule
