`default_nettype none
`timescale 1ns/1ns
module rgb_mixer (
    input clk,
    input reset,
    input enc0_a,
    input enc0_b,
    input enc1_a,
    input enc1_b,
    input enc2_a,
    input enc2_b,
    output pwm0_out,
    output pwm1_out,
    output pwm2_out
);
    wire enc0_a_db, enc0_b_db;
    wire enc1_a_db, enc1_b_db;
    wire enc2_a_db, enc2_b_db;
    wire [7:0] enc0, enc1, enc2;


    reg clk_slow;
    reg [7:0] counter;

    always @(posedge clk) begin
        if(reset) begin
            counter <= 0;
            clk_slow <= 0;
        end else begin
            counter <= counter + 1'b1;
            //if(counter[7:7] == 1'b1)
            clk_slow <= ~clk_slow;
        end
    end

    debounce #(.COUNTER_WIDTH(8)) debounce0_a(.clk(clk), .reset(reset), .button(enc0_a), .debounced(enc0_a_db));
    debounce #(.COUNTER_WIDTH(8)) debounce0_b(.clk(clk), .reset(reset), .button(enc0_b), .debounced(enc0_b_db));

    debounce #(.COUNTER_WIDTH(8)) debounce1_a(.clk(clk), .reset(reset), .button(enc1_a), .debounced(enc1_a_db));
    debounce #(.COUNTER_WIDTH(8)) debounce1_b(.clk(clk), .reset(reset), .button(enc1_b), .debounced(enc1_b_db));

    debounce #(.COUNTER_WIDTH(8)) debounce2_a(.clk(clk), .reset(reset), .button(enc2_a), .debounced(enc2_a_db));
    debounce #(.COUNTER_WIDTH(8)) debounce2_b(.clk(clk), .reset(reset), .button(enc2_b), .debounced(enc2_b_db));

    //encoders
    encoder encoder0(.clk(clk), .reset(reset), .a(enc0_a_db), .b(enc0_b_db), .value(enc0));
    encoder encoder1(.clk(clk), .reset(reset), .a(enc1_a_db), .b(enc1_b_db), .value(enc1));
    encoder encoder2(.clk(clk), .reset(reset), .a(enc2_a_db), .b(enc2_b_db), .value(enc2));

    //pwm
    pwm pwm0(.clk(clk), .reset(reset), .out(pwm0_out), .level(enc0));
    pwm pwm1(.clk(clk), .reset(reset), .out(pwm1_out), .level(enc1));
    pwm pwm2(.clk(clk), .reset(reset), .out(pwm2_out), .level(enc2));
endmodule