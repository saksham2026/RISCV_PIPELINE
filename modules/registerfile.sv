//-----------------------------------------------------------------------------
// Title       : Parameterized Register File
// File        : register_file.sv
// Author      : Saksham Aggarwal
// Created     : 2025-09-18
// Description : Parameterized 2-read, 1-write register file.
//               - Configurable number of registers and data width
//               - Synchronous write, asynchronous read
//               - Optional zero-register protection (useful for RISC-V)
//-----------------------------------------------------------------------------

module register_file #(
    parameter int REG_COUNT     = 32,  // Number of registers
    parameter int DATA_WIDTH    = 32,  // Width of each register
    parameter bit ZERO_PROTECT  = 1    // 1 = Prevent writes to R0
) (
    input  logic                        clk_i,        // Clock
    input  logic                        rst_i,        // Async reset, active high
    input  logic                        write_en_i,   // Write enable
    input  logic                        read_en_i,    // Read enable
    input  logic [$clog2(REG_COUNT)-1:0] read_addr1_i, // Read address 1
    input  logic [$clog2(REG_COUNT)-1:0] read_addr2_i, // Read address 2
    input  logic [$clog2(REG_COUNT)-1:0] write_addr_i, // Write address
    input  logic [DATA_WIDTH-1:0]        write_data_i, // Write data
    output logic [DATA_WIDTH-1:0]        read_data1_o, // Read data port 1
    output logic [DATA_WIDTH-1:0]        read_data2_o  // Read data port 2
);

    //--------------------------------------------------------------------------
    // Register file storage
    //--------------------------------------------------------------------------
    logic [DATA_WIDTH-1:0] reg_file [0:REG_COUNT-1];

    //--------------------------------------------------------------------------
    // Reset and write logic (synchronous write)
    //--------------------------------------------------------------------------
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            for (int i = 0; i < REG_COUNT; i++) begin
                reg_file[i] <= '0;
            end
        end 
        else if (write_en_i) begin
            if (!(ZERO_PROTECT && (write_addr_i == '0))) begin
                reg_file[write_addr_i] <= write_data_i;
            end
        end
    end

    //--------------------------------------------------------------------------
    // Read logic (asynchronous read)
    //--------------------------------------------------------------------------
    always_comb begin
        if (read_en_i) begin
            read_data1_o = reg_file[read_addr1_i];
            read_data2_o = reg_file[read_addr2_i];
        end else begin
            read_data1_o = '0;
            read_data2_o = '0;
        end
    end

endmodule
