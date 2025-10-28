/*
 * Constants file for Keccak Core
 */

`ifndef KECCAK_CONSTANTS_SVH_
`define KECCAK_CONSTANTS_SVH_

typedef enum reg [2:0] {
    SHA3_256,
    SHA3_512,
    SHAKE128,
    SHAKE256
} keccak_mode;

`endif
