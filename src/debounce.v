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
        end else
            //counter <= {counter[6:0],button};
            if(button) begin
                counter <= {counter[6:0],1'b1};
            end else begin
                counter <= {counter[6:0],1'b0};
            end
            if(counter == 8'b11111111) begin
                debounced <= 1'b1;
            end else if(counter == 8'b00000000) begin
                debounced <= 1'b0;
            end
        end
    end
endmodule
