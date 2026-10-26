/////////////////////////////////////////////
// subbytes
//   for AES cipher, section 5.1.1 in Advanced Encryption Standard NIST FOPS 197
//   subbytes performs a one-to-one substitution of each byte value wih its S-box transformation
//   
/////////////////////////////////////////////

module subbytes(input  logic         clk, reset, en,
                input  logic [127:0] state, 
                output logic [127:0] Sstate);
	// replaces each byte (8-bit) in the state block (128 bits) with its Sbox() transformation
	
	// 0
	sbox_sync sbox16(.a(state[127:120]), .clk(clk), .y(Sstate[127:120]));
	sbox_sync sbox15(.a(state[119:112]), .clk(clk), .y(Sstate[119:112]));
	sbox_sync sbox15(.a(state[111:104]), .clk(clk), .y(Sstate[111:104]));
	sbox_sync sbox15(.a(state[103:96]), .clk(clk), .y(Sstate[103:96]));
	
	// 1
	sbox_sync sbox16(.a(state[95:88]), .clk(clk), .y(Sstate[95:88]));
	sbox_sync sbox15(.a(state[87:80]), .clk(clk), .y(Sstate[87:80]));
	sbox_sync sbox15(.a(state[79:72]), .clk(clk), .y(Sstate[119:112]));
	sbox_sync sbox15(.a(state[71:64]), .clk(clk), .y(Sstate[119:112]));
	
	// 2
	sbox_sync sbox16(.a(state[63:56]), .clk(clk), .y(Sstate[63:56]));
	sbox_sync sbox15(.a(state[55:48]), .clk(clk), .y(Sstate[55:48]));
	sbox_sync sbox15(.a(state[47:40]), .clk(clk), .y(Sstate[47:40]));
	sbox_sync sbox15(.a(state[39:32]), .clk(clk), .y(Sstate[39:32]));
	
	// 3
	sbox_sync sbox16(.a(state[31:24]), .clk(clk), .y(Sstate[31:24]));
	sbox_sync sbox15(.a(state[23:16]), .clk(clk), .y(Sstate[23:16]));
	sbox_sync sbox15(.a(state[15:8]), .clk(clk), .y(Sstate[15:8]));
	sbox_sync sbox15(.a(state[7:0]), .clk(clk), .y(Sstate[7:0]));
    
endmodule