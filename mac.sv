module mac #(
    parameter int WIDTH_A = 8,
    parameter int WIDTH_B = 8,
    parameter int WIDTH_ACC = 32
    )
    (
        input logic rstn,
        input logic en,
        input logic [WIDTH_A-1:0] a,
        input logic [WIDTH_B-1:0] b,
        input logic [WIDTH_ACC-1:0] acc_i,
        output logic [WIDTH_ACC-1:0] acc_o
);

    always_comb begin : mac_unit
        if(!rstn) begin
            acc_o = '0;
        end
        else if (en) begin
            acc_o = acc_i + (a * b);
        end
    end
endmodule
