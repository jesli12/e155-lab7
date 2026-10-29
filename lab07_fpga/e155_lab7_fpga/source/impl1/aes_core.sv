/////////////////////////////////////////////
// aes_core
//   top level AES encryption module
//   when load is asserted, takes the current key and plaintext
//   generates cyphertext and asserts done when complete 11 cycles later
// 
//   See FIPS-197 with Nk = 4, Nb = 4, Nr = 10
//
//   The key and message are 128-bit values packed into an array of 16 bytes as
//   shown below
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   Equivalently, the values are packed into four words as given
//        [127:96]  [95:64] [63:32] [31:0]      w[0]    w[1]    w[2]    w[3]
/////////////////////////////////////////////

module aes_core(input  logic         clk, 
                input  logic         load,
                input  logic [127:0] key, 
                input  logic [127:0] plaintext, 
                output logic         done, 
                output logic [127:0] cyphertext);

    // CIPHER aes128 is implemented here, FSM style
	typedef enum logic [1:0] {FIRST, DELAY, ROUNDS, LAST} statetype;
	statetype state, nextstate;
	
	logic [3:0] round; // counts which round we're on
	// logic [3:0] selector; // output of FSM controller, selects mux outputs, [FIRST, DELAY, ROUND, LAST]

	logic [127:0] textIn, subbytesOut, shiftrowsOut, mixcolumnsOut, opmuxOut, addroundkeyOut, textOut;
	logic [127:0] prevKey, newKey;
	
// Datapath ////////////////////////////////////////////////////////////////////////////////////
	subbytes subbyte_op(.clk(clk), .state(textIn), .Sstate(subbytesOut));
	shiftrows shiftrows_op(.a(subbytesOut), .y(shiftrowsOut));
	mixcolumns mixcolumns_op(.a(shiftrowsOut),.y(mixcolumnsOut));
	// Mux 1 (Op Mux): operation mux to be inputted into addroundkey
	// controls opmuxOut
	always_comb
		case (state)
			FIRST: opmuxOut = plaintext;
			// DELAY: op selector is dont care
			ROUNDS: opmuxOut = mixcolumnsOut;
			LAST: opmuxOut = shiftrowsOut;
			default: opmuxOut = mixcolumnsOut;
		endcase
	// End Mux 1
	keyexpansion keyexpansion_op(.clk(clk), .round(round), .rkey(prevKey), .keyOut(newKey));
	addroundkey addroundkey_op(.a(opmuxOut), .roundkey(newKey), .y(addroundkeyOut));
	// Mux 2: delay/not delay mux to be inputted into register next
	// controls textOut
	always_comb
		case (state)
			DELAY: textOut = textIn;
			// all other states is not delay
			default: textOut = addroundkeyOut;
		endcase
	// End Mux 2, textOut is set
	
// FSM CONTROLLER //////////////////////////////////////////////////////////////////////////////
	// FSM register + datapath register in one oop
	always_ff @(posedge clk) begin
		if (load) begin // load is high when MCU is still sending info to FPGA, keep in state 0
			round <= 4'd0;
			textIn <= plaintext;
			prevKey <= key;
			state <= FIRST;
		end 
		else if (state == DELAY) begin
			textOut <= textIn;
			state <= nextstate;
		end
		else begin
			round <= round + 4'd1;
			textIn <= textOut;
			prevKey <= newKey;
			state <= nextstate;
		end
	end
	
	// next state logic!
	always_comb
		case (state)
			FIRST: nextstate = (round > 4'd0)? ROUNDS : DELAY;
			DELAY: nextstate = ROUNDS; // one clock tick for key expansion's subword (SBOX) to process
			ROUNDS: nextstate = (round > 4'd10)? LAST : ROUNDS;
			LAST: nextstate = LAST;
			default: nextstate = FIRST;
		endcase
		
	assign done = (state == LAST);
	assign cyphertext = textOut;
    
endmodule