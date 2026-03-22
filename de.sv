module de #(
    parameter int WIDTH_A = 8,
    parameter int WIDTH_B = 8
    )(
    input logic clk,
    input logic rstn,
    input logic en,
    //basic ports, include separate chain for propagation of accumulated data
    //later
    input logic signed [WIDTH_A-1:0] west_data_i,
    input logic signed [WIDTH_B-1:0] north_data_i,
    output logic signed [WIDTH_A-1:0] east_data_o,
    output logic signed [WIDTH_B-1:0] south_data_o

);

    always_ff @(posedge clk) begin : de
        //reset is a must to initialize
        if(!rstn) begin
            south_data_o <= '0;
            east_data_o <='0;
        end else begin
            if(en) begin
                south_data_o <= north_data_i;
                east_data_o <= west_data_i;
            end
        end
    end
endmodule
