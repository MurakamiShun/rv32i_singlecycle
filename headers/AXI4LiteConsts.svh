`ifndef AXI4_LITE_CONSTS_SVH
`define AXI4_LITE_CONSTS_SVH

/* verilator lint_off DECLFILENAME */
package AXI4LiteWriteResp;
    typedef enum logic[1:0]{
        OKAY   = 2'b00, // Succeed
        EXOKAY = 2'b01,
        SLVERR = 2'b10, // Error
        DECERR = 2'b11
    } Type;
endpackage

package AXI4LiteReadResp;
    typedef enum logic[1:0]{
        OKAY   = 2'b00, // Succeed
        EXOKAY = 2'b01,
        SLVERR = 2'b10, // Error
        DECERR = 2'b11
    } Type;
endpackage

`endif