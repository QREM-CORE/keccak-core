module theta_step (
    input [4:0][4:0][63:0] state_array_in,
    output [4:0][4:0][63:0] state_array_out
);

    // Column Parity Wires (Algorithm 1: C matrix in FIPS202)
    // 5x64 grid array (each entry is a parity of the corresponding column)
    wire [4:0][63:0] C;

    wire [4:0][63:0] D;

    // Get Parities of each column
    // From FIPS202: C[x, z] = A[x, 0, z] ⊕ A[x, 1, z] ⊕ A[x, 2, z] ⊕ A[x, 3, z] ⊕ A[x, 4, z]
    genvar x;
    generate
        for (x = 0; x<5; x = x + 1) begin : compute_C
            assign C[x] =       state_array_in[x][0] ^
                                state_array_in[x][1] ^
                                state_array_in[x][2] ^
                                state_array_in[x][3] ^
                                state_array_in[x][4];
        end
    endgenerate

    // Calculate D[x] to mix neighboring column parities with rotation
    // From FIPS202: D[x, z] = C[(x-1) mod 5, z] ⊕ C[(x+1) mod 5, (z – 1) mod w].
    generate
        for (x = 0; x<5; x = x + 1) begin : compute_D
            // Efficient Way to implement the modulo in this case
            wire [2:0] xm1 = (x==0) ? 4 : x - 1; // x - 1 modulo 5
            wire [2:0] xp1 = (x==4) ? 0 : x + 1; // x + 1 modulo 5

            // C[x-1] XOR {Rotated C[x+1]}
            // Doing the XOR operation with each lane of the C array
            assign D[x] = C[xm1] ^ {C[xp1][62:0], C[xp1][63]};
        end
    endgenerate

    // Compute final state array for theta step
    // From FIPS202: A′[x, y, z] = A[x, y, z] ⊕ D[x, z]
    genvar y;
    generate
        for (x = 0; x<5; x = x + 1) begin
            for (y = 0; y<5; y = y + 1) begin
                assign state_array_out[x][y] = state_array_in[x][y] ^ D[x];
            end
        end
    endgenerate

endmodule
