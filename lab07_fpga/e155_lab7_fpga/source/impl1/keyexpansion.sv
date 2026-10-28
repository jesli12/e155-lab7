`timescale 10ns/1ns

/////////////////////////////////////////////
// keyexpansion
//   creates round key (keyOut) based on previous round key and set of operations:
//		RotWord and SubWord, other stuff
//   Section 5.2, Figure 6 (see also page 17)
//   
/////////////////////////////////////////////

module keyexpansion(input  logic clk,
					input  logic [3:0] round, // IMPORTANT: 1 to 10 rounds
					input  logic [127:0] rkey,
					output logic [127:0] keyOut);
	// Nk is 4, for the four 32 bit words comprising the key for AES-128
	// Nr is 10, for the 4 rounds for AES-128
	// First key is the key itself, then 10 more keys created through the 10 rouns of key expansion
	
	// for me, i will range 0 <= i < 4, to generate one key (one of the 11 total keys in key schedule)
	// lwk confusing but new key's word 0 (w[0]) is the key schedule's w[4] because
	// its in round 2, and it goes on. But since I'm just doing one key, i need to be careful about what i is.
	
	logic [31:0] rcon, subW0;
	
	// calculating NEW key's w[0]   ///////////////////////////////////////////////////////////////
	// w[0]=rk_w[0]^subword(rotword(w[3]))^Rcon(of the round im on)
	
		// 1. Set Rcon according to inputted round (1 to 10)
	always_comb begin
			case(round)
				4'd1: rcon = 32'h01000000;
				4'd2: rcon = 32'h02000000;
				4'd2: rcon = 32'h04000000;
				4'd2: rcon = 32'h08000000;
				4'd2: rcon = 32'h10000000;
				4'd2: rcon = 32'h20000000;
				4'd2: rcon = 32'h40000000;
				4'd2: rcon = 32'h80000000;
				4'd2: rcon = 32'h1b000000;
				4'd2: rcon = 32'h36000000;
				default: rcon = 32'h01000000;
			endcase
	end
	
	// key(128 bits)[127:0]: w0(32 bits) = key[127:96], w1 = key[95:64], w2 = key[63:32], w3 = key[31:0]
	// each w# (word) contains 4 bytes:, for w3: b0=w3[31:24], b1=w3[23:16], b2=w3[15:8], b3=w3[7:0]
	
		// 2. find Subword(Rotword(rk_w[3])) = subW0
		// rot word shifts (rotates) the 4 bytes to the left and loops the last to the back [b1, b2, b3 , b0]
		// with the resulting word, its 4 bytes are inputted into sbox
	sbox_sync sbox_b4(.a(rkey[23:16]), .clk(clk), .y(subW0[31:24]));
	sbox_sync sbox_b4(.a(rkey[15:8]), .clk(clk), .y(subW0[23:16]));
	sbox_sync sbox_b4(.a(rkey[7:0]), .clk(clk), .y(subW0[15:8]));
	sbox_sync sbox_b4(.a(rkey[31:24]), .clk(clk), .y(subW0[7:0]));
	
		// 3. w[0]=rk_w[0]^subW0^Rcon
	assign keyOut[127:96] = rkey[127:96]^subW0^Rcon;
	
	// calculating NEW key's w[1] w[2] w[3]  ///////////////////////////////////////////////////////////////
	// w[i] = w[i-4]^w[i-1]  --> w[i] = rk_w[i]^w[i-1];
	assign keyOut[95:64] = rkey[95:64]^keyOut[127:96]; // w1
	assign keyOut[63:32] = rkey[63:32]^keyOut[95:64];  // w2
	assign keyOut[31:0] = rkey[31:0]^keyOut[63:32];    // w3
	
	
endmodule