module pe #(
    parameter int WIDTH_A = 8,
    parameter int WIDTH_B = 8,
    parameter int WIDTH_ACC = 32)
(
    input logic clk,
    input logic rstn,
    input logic en,
    //basic ports, include separate chain for propagation of accumulated data
    //later
    input logic signed [WIDTH_A-1:0] west_data_i,
    input logic signed [WIDTH_B-1:0] north_data_i,
    output logic signed [WIDTH_A-1:0] east_data_o,
    output logic signed [WIDTH_B-1:0] south_data_o,
    output logic signed [WIDTH_ACC-1:0] acc_data_o

);

    logic signed [WIDTH_ACC-1:0] acc_reg;
    logic signed [WIDTH_ACC-1:0] mac_result;


    //fully combinational MAC module
    mac #(
        .WIDTH_A(WIDTH_A),
        .WIDTH_B(WIDTH_B),
        .WIDTH_ACC(WIDTH_ACC)
        )mac_inst(
            .a(west_data_i),
            .b(north_data_i),
            .acc_i(acc_reg),
            .acc_o(mac_result)
        );

    always_ff @(posedge clk) begin : pe
        //reset is a must to initialize
        if(!rstn) begin
            acc_data_o <= '0;
            south_data_o <= '0;
            east_data_o <='0;
            acc_reg <= '0;
        end else begin
            if(en) begin
                acc_reg <= mac_result;
                south_data_o <= north_data_i;
                east_data_o <= west_data_i;
                acc_data_o <= mac_result;
            end
        end
    end
endmodule
