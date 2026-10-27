`timescale 10ns/1ns

/////////////////////////////////////////////
// shiftrows
//   Cyclically shift row r of the state left by r bytes
//   Section 5.1.2, Figure 8
//   Purely combinational
//
//   Uses the same packing as aes_core in aes_starter.sv:
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   Note that each 32-bit word is a *column* of the state, not a row.
//
//   remember that stateArr[row][col]
/////////////////////////////////////////////

module shiftrows(input  logic [127:0] a,
                 output logic [127:0] y);

    logic [0:3][0:3][7:0] state0, state1;
	input_to_state i2s(.a(a), .y(state0));
	
	// row 0 shifts 0
	assign state1[0] = state0[0];
	
	// row 1 shifts left 1
	assign state1[1][0] = state0[1][3];
	assign state1[1][1] = state0[1][0];
	assign state1[1][2] = state0[1][1];
	assign state1[1][3] = state0[1][2];
	
	// row 2 shifts left 2
	assign state1[2][0] = state0[2][2];
	assign state1[2][1] = state0[2][3];
	assign state1[2][2] = state0[2][0];
	assign state1[2][3] = state0[2][1];
	
	// row 3 shifts left 3
	assign state1[3][0] = state0[3][1];
	assign state1[3][1] = state0[3][2];
	assign state1[3][2] = state0[3][3];
	assign state1[3][3] = state0[3][0];
	
	state_to_output s2o(.a(state1), .y(y));

endmodule