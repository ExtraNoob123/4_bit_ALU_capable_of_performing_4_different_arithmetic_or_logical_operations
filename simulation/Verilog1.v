module Verilog1(A, B, opcode, clk, reset, C, CF, ZF,SF);
	input clk,reset;
	input [3:0] A;
	input [3:0] B;
	input [2:0] opcode;
	output reg [3:0] C;
	output reg CF;
	output reg ZF;
	output reg SF;

// Temporary variable to store the result
	reg [4:0] temp;
	reg [3:0]prev_C = 4'b0000;

	always @(posedge clk, posedge reset) 
	begin
		if (reset == 1)
		begin
			temp = 5'b00000;
			C = temp[3:0];
			CF = 0;
			ZF = 1;
			SF = 0;
		end
		
		else
		begin
			prev_C = C;
			
			case (opcode)
				3'b000:    //RESET operation
				begin
					C = prev_C;
					CF = CF;
				end
				
				3'b001:   //AND operation
				begin
					temp = (A & B);
					C = temp[3:0];
					CF = 0;
					
				end
				
				3'b010:   //ADD operation
				begin
					temp = (A + B);
					C = temp[3:0];
					if (temp[4] == 1)
					begin
						CF = 1;
					end
					else
					begin
						CF = 0;
					end
				end
				
				3'b011:   //NOR operation
				begin
					temp = ~(A | B);
					C = temp[3:0];
					CF = 0;
				end
				
				3'b100:   //SUB operation
				begin
					C = A - B;
					if (A >= B)
					begin
						CF = 0;
					end
					else
					begin
						CF = 1;
					end
				end
				 
				default: 
				begin
					temp = 5'bxxxxx;
					C = 4'bxxxx;
					CF = 1'bx;
				end			
			endcase
			
			if (C == 4'b0000)
			begin
				ZF = 1;
			end
			else
			begin
				ZF = 0;
			end
					
			SF = C[3];

		end	
	end
endmodule

