module pe #(
    parameter int WIDTH = 8,
    parameter int WIDTH_ACC = 32)
(
    input logic clk,
    input logic rstn,
    input logic en,
    input logic [WIDTH_ACC-1:0] acc_data_i,
    input logic [WIDTH-1:0] north_data_i,
    input logic [WIDTH-1:0] west_data_i,
    output logic [WIDTH-1:0] south_data_o,
    output logic [WIDTH-1:0] east_data_o,
    output logic [WIDTH_ACC-1:0] acc_data_o

);

    logic mac_en = 1;
    logic [WIDTH_ACC-1:0] acc_reg;
    logic [WIDTH_ACC-1:0] acc_wire_mac_i;
    logic [WIDTH_ACC-1:0] acc_wire_mac_o;

    mac #(
        .WIDTH_A(WIDTH),
        .WIDTH_B(WIDTH),
        .WIDTH_ACC(WIDTH_ACC)
        )mac_inst(
            .rstn(rstn),
            .en(mac_en),
            .a(north_data_i),
            .b(west_data_i),
            .acc_i(acc_wire_mac_i),
            .acc_o(acc_wire_mac_o)
        );

    always_ff @(posedge clk) begin : pe
        if(!rstn) begin
            acc_data_o <= '0;
            south_data_o <= '0;
            east_data_o <='0;
            acc_reg <= '0;
            acc_data_o <= '0;
        end else begin
            if(en) begin
                acc_wire_mac_i <= acc_reg;
                acc_data_o <= acc_wire_mac_o;
                south_data_o <= north_data_i;
                east_data_o <= west_data_i;
            end else begin
                acc_data_o <= acc_data_i;
                south_data_o <= south_data_o;
                east_data_o <= west_data_i;
            end
        end
    end
endmodule
