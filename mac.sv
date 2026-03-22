module mac #(
    parameter int WIDTH_A = 8,
    parameter int WIDTH_B = 8,
    parameter int WIDTH_ACC = 32
    )
    (
        input logic signed [WIDTH_A-1:0] a,
        input logic signed [WIDTH_B-1:0] b,
        input logic signed [WIDTH_ACC-1:0] acc_i,
        output logic signed [WIDTH_ACC-1:0] acc_o
);

    assign acc_o = acc_i + (a * b);

endmodule
