`timescale 10ns/1ns

/////////////////////////////////////////////
// keyexpansion
//   creates key schedule based on initial key and set of operations:
//		RotWord and SubWord
//   Section 5.2, Figure 6
//   
/////////////////////////////////////////////

module keyexpansion(input  logic [127:0] state0,
				  input logic [127:0] roundkey,
                 output logic [127:0] state1);
	// TO DO
endmodule