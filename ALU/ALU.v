module ALU
#(parameter W = 32)
(
	input [W-1:0] A, B,
	input [2:0] ctrl,
	output reg CO, OVF, N, Z,
	output reg [W-1:0] Q
);

	always @(*)
	begin
		case(ctrl)
			3'b000:	begin	//addition
							{CO, Q} = A + B;
							N = Q[W-1];	//sign bit is the MSB
							if (Q == 0) 
								Z = 1;
							else
								Z = 0;
							// check if the operands signs are the same but the result sign is different
							if ( (A[W-1] == 0 && B[W-1] == 0 && Q[W-1] == 1) || (A[W-1] == 1 && B[W-1] == 1 && Q[W-1] == 0) )
								OVF = 1;
							else
								OVF = 0;
						end
			3'b001:	begin	//subtraction AB
							{CO, Q} = A - B;
							N = Q[W-1];	//sign bit is the MSB
							if (Q == 0) 
								Z = 1;
							else
								Z = 0;
							// check if the operands signs are the same but the result sign is different
							if ( (A[W-1] == 0 && B[W-1] == 0 && Q[W-1] == 1) || (A[W-1] == 1 && B[W-1] == 1 && Q[W-1] == 0) )
								OVF = 1;
							else
								OVF = 0;	
						end
			3'b010:	begin //subtraction BA
							{CO, Q} = B - A;
							N = Q[W-1];	//sign bit is the MSB
							if (Q == 0) 
								Z = 1;
							else
								Z = 0;
							// check if the operands signs are the same but the result sign is different
							if ( (A[W-1] == 0 && B[W-1] == 0 && Q[W-1] == 1) || (A[W-1] == 1 && B[W-1] == 1 && Q[W-1] == 0) )
								OVF = 1;
							else
								OVF = 0;
						end	
			3'b011:	begin	//bit clear
							Q = A & ~B;
							N = Q[W-1];	//sign bit is the MSB
							if (Q == 0) 
								Z = 1;
							else
								Z = 0;
							CO = 0;	//carry-out and overflow are not considered in logic operations
							OVF = 0;
						end
			3'b100:	begin	//and
							Q = A & B;
							N = Q[W-1];	//sign bit is the MSB
							if (Q == 0) 
								Z = 1;
							else
								Z = 0;
							CO = 0;	//carry-out and overflow are not considered in logic operations
							OVF = 0;
						end				
			3'b101:	begin	//or
							Q = A | B;
							N = Q[W-1];	//sign bit is the MSB
							if (Q == 0) 
								Z = 1;
							else
								Z = 0;
							CO = 0;	//carry-out and overflow are not considered in logic operations
							OVF = 0;						
						end	
			3'b110:	begin	//exor
							Q = A ^ B;
							N = Q[W-1];	//sign bit is the MSB
							if (Q == 0) 
								Z = 1;
							else
								Z = 0;
							CO = 0;	//carry-out and overflow are not considered in logic operations
							OVF = 0;						
						end		
			3'b111:	begin	//exnor
							Q = ~(A ^ B);
							N = Q[W-1];	//sign bit is the MSB
							if (Q == 0) 
								Z = 1;
							else
								Z = 0;
							CO = 0;	//carry-out and overflow are not considered in logic operations
							OVF = 0;						
						end	
		endcase
	end

endmodule