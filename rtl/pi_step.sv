/*
 * Module Name: pi_step
 * Author: Kiet Le
 * Description: The effect of π is to rearrange the positions of the lanes.
 * NOTE: Purely combinational so far. Can be pipelined for higher clock speed if needed.
 */

import keccak_pkg::*;

module pi_step (
    input   [ROW_SIZE-1:0][COL_SIZE-1:0][LANE_SIZE-1:0] state_array_in,
    output  [ROW_SIZE-1:0][COL_SIZE-1:0][LANE_SIZE-1:0] state_array_out
);



endmodule
