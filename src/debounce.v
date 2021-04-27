`default_nettype none
`timescale 1ns/1ns
module debounce (
    input wire clk,
    input wire reset,
    input wire button,
    output reg debounced
);

    reg [7:0] counter;
    always @(posedge clk) begin
        if(reset) begin
            counter <= 0;
            debounced <= 1'b0;
        end else begin
            //counter <= {counter[6:0],button};
            if(button)
                counter <= {counter[6:0],1'b1};
            else
                counter <= {counter[6:0],1'b0};
            if(counter == 8'b11111111)
                debounced <= 1'b1;
            else if(counter == 8'b00000000)
                debounced <= 1'b0;
        end
    end
endmodule
