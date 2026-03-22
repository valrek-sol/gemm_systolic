module systolic_mesh #(
    parameter int WIDTH_A = 8,
    parameter int WIDTH_B = 8,
    parameter int WIDTH_ACC = 32,
    parameter int MTX_M = 2,
    parameter int MTX_N = 3,
    parameter int MTX_K = 3
    )(
    input logic clk,
    input logic rstn,
    input logic signed [WIDTH_A-1:0] matrix_a [MTX_M],
    input logic signed [WIDTH_B-1:0] matrix_b [MTX_N],
    //output for testing purposes,
    //real architecture shall have a chain of partial sum propagation
    //this is not efficient, to be changed.
    output logic signed [WIDTH_ACC-1:0] element_value [MTX_M] [MTX_N]
);

    localparam int SYS_MESH_SIZE = MTX_M + MTX_N - 1;

    logic signed [WIDTH_A-1:0] wire_mesh_west_to_east   [SYS_MESH_SIZE][SYS_MESH_SIZE];
    logic signed [WIDTH_B-1:0] wire_mesh_north_to_south [SYS_MESH_SIZE][SYS_MESH_SIZE];

    genvar i,j;
    generate
        for (i = 0 ; i < SYS_MESH_SIZE ; i++) begin : row_gen
            for (j = 0 ; j < SYS_MESH_SIZE ; j++) begin : col_gen
                if (j < (SYS_MESH_SIZE - i) - 1 ) begin : no_insts
                    // no instantiation
                end
                else if (i >= SYS_MESH_SIZE - MTX_M && j >= SYS_MESH_SIZE - MTX_N) begin :pe_insts
                    //pe instantiation
                    pe #(
                        .WIDTH_A(WIDTH_A),
                        .WIDTH_B(WIDTH_B),
                        .WIDTH_ACC(WIDTH_ACC)
                    )pe_inst(
                        .clk(clk),
                        .rstn(rstn),
                        .en(en),
                        .west_data_i(),
                        .north_data_i(),
                        .east_data_o(),
                        .south_data_o(),
                        .acc_data_o()
                    );
                end else begin : de_insts
                    //de instantiation
                    de #(
                        .WIDTH_A(WIDTH_A),
                        .WIDTH_B(WIDTH_B),
                    )de_inst(
                        .clk(clk),
                        .rstn(rstn),
                        .en(en),
                        .west_data_i(),
                        .north_data_i(),
                        .east_data_o(),
                        .south_data_o()
                    );
                end
            end
        end
    endgenerate

endmodule
