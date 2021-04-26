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
        end if(button) begin
            counter <= counter + 1'b1;
        end else begin
            counter <= counter - 1'b1;
        if counter = 1'b11111111 or counter = 1'b00000000 begin
            assign debounced = counter;
        end
    end
endmodule
