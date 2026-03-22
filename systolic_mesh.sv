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
    input logic en,
    input logic signed [WIDTH_A-1:0] matrix_a [MTX_M],
    input logic signed [WIDTH_B-1:0] matrix_b [MTX_N],
    //output for testing purposes,
    //real architecture shall have a chain of partial sum propagation
    //this is not efficient, to be changed.
    output logic signed [WIDTH_ACC-1:0] element_value [MTX_M] [MTX_N]
);

    localparam int SYS_MESH_SIZE = MTX_M + MTX_N - 1;

    logic signed [WIDTH_A-1:0] wire_mesh_west_to_east   [SYS_MESH_SIZE+1][SYS_MESH_SIZE+1];
    logic signed [WIDTH_B-1:0] wire_mesh_north_to_south [SYS_MESH_SIZE+1][SYS_MESH_SIZE+1];

    genvar i,j;
    generate
        for (i = 0 ; i < SYS_MESH_SIZE ; i++) begin : gen_row
            for (j = 0 ; j < SYS_MESH_SIZE ; j++) begin : gen_col
                if (j < (SYS_MESH_SIZE - i) - 1 ) begin : gen_no_insts
                    // no instantiation
                end
                else if (i >= SYS_MESH_SIZE - MTX_M && j >= SYS_MESH_SIZE - MTX_N)
                begin : gen_pe_insts
                    //pe instantiation
                    pe #(
                        .WIDTH_A(WIDTH_A),
                        .WIDTH_B(WIDTH_B),
                        .WIDTH_ACC(WIDTH_ACC)
                    )pe_inst(
                        .clk(clk),
                        .rstn(rstn),
                        .en(en),
                        .west_data_i(wire_mesh_west_to_east[i][j]),
                        .north_data_i(wire_mesh_north_to_south[i][j]),
                        .east_data_o(wire_mesh_west_to_east[i][j+1]),
                        .south_data_o(wire_mesh_north_to_south[i+1][j]),
                        .acc_data_o(element_value[i-(MTX_N-1)][j-(MTX_M-1)])
                    );
                end else begin : gen_de_insts
                    //de instantiation
                    de #(
                        .WIDTH_A(WIDTH_A),
                        .WIDTH_B(WIDTH_B)
                    )de_inst(
                        .clk(clk),
                        .rstn(rstn),
                        .en(en),
                        .west_data_i(wire_mesh_west_to_east[i][j]),
                        .north_data_i(wire_mesh_north_to_south[i][j]),
                        .east_data_o(wire_mesh_west_to_east[i][j+1]),
                        .south_data_o(wire_mesh_north_to_south[i+1][j])
                    );
                end
            end
        end
    endgenerate

    generate
        for(i = 0 ; i < SYS_MESH_SIZE ; i++) begin : gen_connects_row
            for (j = 0 ; j < SYS_MESH_SIZE ; j++ ) begin : gen_connects_col
                if(j > (SYS_MESH_SIZE - MTX_N) - 1) begin : gen_connects_mat_B
                    if(j+i == SYS_MESH_SIZE - 1)
                        assign wire_mesh_north_to_south[i][j] = matrix_b[j-(MTX_M-1)];
                end
                if(i >= MTX_M - 1) begin : gen_connects_mat_A
                    if(j+i == SYS_MESH_SIZE - 1)
                        assign wire_mesh_west_to_east[i][j] = matrix_a[i-(MTX_N-1)];
                end
            end
        end
    endgenerate

endmodule
