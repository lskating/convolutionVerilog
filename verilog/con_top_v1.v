`timescale 1ns/1ns
// Author: Simon Liao
// Function: 3x3 convolution kernel, 7x7 picture data, each data is 16-bit
// Top_cell: con_5x5
// Version: v2.0
// Date: 25th Dec, 2020 
module con_5x5(
	input rst_n,			// syn. reset
	input clk,				// clk, about 100MHz max
	input ena,				// enable for reading data from chip-out
	input [15:0] data,		// 16-bit each data, all parallel in  
	output reg valid,		// output valid signal, "1" 
	output reg finish,		// finish calculating, "1"
	output [15:0] result	// 16-bit result for each convoution
	);

	reg [15:0] data_core[1:3][1:3];
	reg [15:0] data_pics[1:3][1:3];
	reg [15:0] data_pics_next[1:3][1:3];
	reg [15:0] core_now,pics_now;

	reg [3:0] core_num;
	reg [7:0] pics_num;
	reg [1:0] pics_num_add;

	con_unit cu_juan(
		.core_11(data_core[1][1]),
		.core_12(data_core[1][2]),
		.core_13(data_core[1][3]),
		.core_21(data_core[2][1]),
		.core_22(data_core[2][2]),
		.core_23(data_core[2][3]),
		.core_31(data_core[3][1]),
		.core_32(data_core[3][2]),
		.core_33(data_core[3][3]),
		.in_Data_11(data_pics[1][1]),
		.in_Data_12(data_pics[1][2]),
		.in_Data_13(data_pics[1][3]),
		.in_Data_21(data_pics[2][1]),
		.in_Data_22(data_pics[2][2]),
		.in_Data_23(data_pics[2][3]),
		.in_Data_31(data_pics[3][1]),
		.in_Data_32(data_pics[3][2]),
		.in_Data_33(data_pics[3][3]),
		.R(result)
		);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			core_num <= 4'h0;
			pics_num <= 8'h0;
			pics_num_add <= 2'b00;
			finish <= 1'b0;
		end
		else if(ena) begin
			if (core_num < 4'h9) begin
				core_now <= data;
				core_num <= core_num + 1'b1;
			end
			else if(core_num == 4'h9) begin
				pics_now <= data;
				pics_num <= pics_num + 1'b1;
				if(pics_num > 8'h8) begin
					if(pics_num_add == 2'd3) pics_num_add <= 2'd1;
					else pics_num_add <= pics_num_add + 1'b1;
				end
				else begin
					pics_num_add <= pics_num_add;
				end
			end
		end	
		else if(pics_num > 8'h50 && pics_num < 8'h54) begin
			pics_num <= pics_num + 1'b1;
			if(pics_num_add == 2'd3) pics_num_add <= 2'd1;
			else pics_num_add <= pics_num_add + 1'b1;
			case(pics_num)
				8'h52:finish <= 1'b1;
				8'h53:finish <= 1'b1;
				8'h54:finish <= 1'b0;
			endcase
		end
		else begin
			pics_num <= 8'h0;
			pics_num_add <= 2'd0;
			core_num <= 4'h0;
			finish <= 1'b0;
		end
	end

	always@(posedge clk) begin
		case (core_num)
			4'h1:data_core[1][1] = core_now;
			4'h2:data_core[1][2] = core_now;
			4'h3:data_core[1][3] = core_now;
			4'h4:data_core[2][1] = core_now;
			4'h5:data_core[2][2] = core_now;
			4'h6:data_core[2][3] = core_now;
			4'h7:data_core[3][1] = core_now;
			4'h8:data_core[3][2] = core_now;
			4'h9:data_core[3][3] = core_now;
			// default: only 1~9, all here
		endcase
	end

	always@(posedge clk)begin
		if(pics_num_add == 2'd1) begin
			data_pics[1][1] <= data_pics_next[1][1];
			data_pics[1][2] <= data_pics_next[1][2];
			data_pics[1][3] <= data_pics_next[1][3];
			data_pics[2][1] <= data_pics_next[2][1];
			data_pics[2][2] <= data_pics_next[2][2];
			data_pics[2][3] <= data_pics_next[2][3];
			data_pics[3][1] <= data_pics_next[3][1];
			data_pics[3][2] <= data_pics_next[3][2];
			data_pics[3][3] <= data_pics_next[3][3];
			valid <= 1'b1;
		end
		else if(pics_num_add == 2'd2) begin
			valid <= 1'b1;
		end
		else valid <= 1'b0;
	end

	always@(posedge clk) begin
		if(pics_num < 8'h0A)
			case (pics_num)
				8'h1: data_pics_next[1][1] = pics_now;
				8'h2: data_pics_next[2][1] = pics_now;
				8'h3: data_pics_next[3][1] = pics_now;
				8'h4: data_pics_next[1][2] = pics_now;
				8'h5: data_pics_next[2][2] = pics_now;
				8'h6: data_pics_next[3][2] = pics_now;
				8'h7: data_pics_next[1][3] = pics_now;
				8'h8: data_pics_next[2][3] = pics_now;
				8'h9: data_pics_next[3][3] = pics_now;
			endcase
		else if((pics_num > 8'h9 && pics_num < 8'd21) || (pics_num > 8'd40 && pics_num < 8'd51) || (pics_num > 8'd70 && pics_num < 8'd81)) begin
			data_pics_next[1][1] = data_pics[1][2];
			data_pics_next[2][1] = data_pics[2][2];
			data_pics_next[3][1] = data_pics[3][2];
			data_pics_next[1][2] = data_pics[1][3];
			data_pics_next[2][2] = data_pics[2][3];
			data_pics_next[3][2] = data_pics[3][3];
			case(pics_num_add)
				2'd1: data_pics_next[1][3] = pics_now;
				2'd2: data_pics_next[2][3] = pics_now;
				2'd3: data_pics_next[3][3] = pics_now;
			endcase
		end
		else if((pics_num > 8'd21 && pics_num < 8'd25) || (pics_num > 8'd51 && pics_num < 8'd55) || (pics_num > 8'd36 && pics_num < 8'd40) || (pics_num > 8'd66 && pics_num < 8'd70)) begin
			data_pics_next[1][1] = data_pics[2][1];
			data_pics_next[1][2] = data_pics[2][2];
			data_pics_next[1][3] = data_pics[2][3];
			data_pics_next[2][1] = data_pics[3][1];
			data_pics_next[2][2] = data_pics[3][2];
			data_pics_next[2][3] = data_pics[3][3];
			case(pics_num_add)
				2'd1: data_pics_next[3][1] = pics_now;
				2'd2: data_pics_next[3][2] = pics_now;
				2'd3: data_pics_next[3][3] = pics_now;
			endcase
		end
		else if((pics_num > 8'd25 && pics_num < 8'd36) || (pics_num > 8'd55 && pics_num < 8'd66)) begin
			data_pics_next[1][3] = data_pics[1][2];
			data_pics_next[2][3] = data_pics[2][2];
			data_pics_next[3][3] = data_pics[3][2];
			data_pics_next[1][2] = data_pics[1][1];
			data_pics_next[2][2] = data_pics[2][1];
			data_pics_next[3][2] = data_pics[3][1];
			case(pics_num_add)
				2'd1: data_pics_next[1][1] = pics_now;
				2'd2: data_pics_next[2][1] = pics_now;
				2'd3: data_pics_next[3][1] = pics_now;
			endcase
		end
	end
endmodule

module con_unit(
	input [15:0]core_11,core_12,core_13,
				core_21,core_22,core_23,
				core_31,core_32,core_33,
				in_Data_11,in_Data_12,in_Data_13,
				in_Data_21,in_Data_22,in_Data_23,
				in_Data_31,in_Data_32,in_Data_33,
	output [15:0] R
	);

	wire [15:0]P[1:3][1:3];
	multiper16x16 mul_11(core_11,in_Data_11,P[1][1]);
	multiper16x16 mul_12(core_12,in_Data_12,P[1][2]);
	multiper16x16 mul_13(core_13,in_Data_13,P[1][3]);
	multiper16x16 mul_21(core_21,in_Data_21,P[2][1]);
	multiper16x16 mul_22(core_22,in_Data_22,P[2][2]);
	multiper16x16 mul_23(core_23,in_Data_23,P[2][3]);
	multiper16x16 mul_31(core_31,in_Data_31,P[3][1]);
	multiper16x16 mul_32(core_32,in_Data_32,P[3][2]);
	multiper16x16 mul_33(core_33,in_Data_33,P[3][3]);
	assign R = P[1][1]+P[1][2]+P[1][3]+P[2][1]+P[2][2]+P[2][3]+P[3][1]+P[3][2]+P[3][3];
endmodule


module multiper16x16(A,B,P_16);
	input signed [15:0]A,B; 	//16-bit
	output signed [15:0] P_16;
	wire signed [18:0] PP_1;
	wire signed [17:0] PP_2,PP_3,PP_4,PP_5,PP_6,PP_7,PP_8;
	wire signed [14:0] PP_9;
	wire signed [31:0] P_32; 	//P_out;
	wire signed [15:0] PP[1:9];
	wire signed [18:0] A_temp; 	//19-bit, low 1'b0, high 2-signed-bit

	assign A_temp = {A[15],A[15],A,1'b0};
	booth_2_unit b2u_1(A_temp[2:0],B,PP[1]);
	booth_2_unit b2u_2(A_temp[4:2],B,PP[2]);
	booth_2_unit b2u_3(A_temp[6:4],B,PP[3]);
	booth_2_unit b2u_4(A_temp[8:6],B,PP[4]);
	booth_2_unit b2u_5(A_temp[10:8],B,PP[5]);
	booth_2_unit b2u_6(A_temp[12:10],B,PP[6]);
	booth_2_unit b2u_7(A_temp[14:12],B,PP[7]);
	booth_2_unit b2u_8(A_temp[16:14],B,PP[8]);
	booth_2_unit b2u_9(A_temp[18:16],B,PP[9]);

	assign PP_1 = {!PP[1][15],PP[1][15],PP[1][15],PP[1]};
	assign PP_2 = {1'b1,!PP[2][15],PP[2]};
	assign PP_3 = {1'b1,!PP[3][15],PP[3]};
	assign PP_4 = {1'b1,!PP[4][15],PP[4]};
	assign PP_5 = {1'b1,!PP[5][15],PP[5]};
	assign PP_6 = {1'b1,!PP[6][15],PP[6]};
	assign PP_7 = {1'b1,!PP[7][15],PP[7]};
	assign PP_8 = {1'b1,!PP[8][15],PP[8]};
	assign PP_9 = {PP[9][14:0]};

	// level-1 3to2
	wire signed [21:0]Carry11,Sum11;
	wire signed [21:0]Carry12,Sum12;
	wire signed [19:0]Carry13,Sum13;
	compressor_3to2_20 c3to2_20_11({3'b0,PP_1[18:2]},{2'b0,PP_2},{PP_3,2'b0},Sum11[21:2],Carry11[21:2]); 	// [21:2],[1]=PP_1[1],[0]=PP_1[0];
	assign Sum11[1:0] = {PP_1[1:0]};
	assign Carry11[1:0] = 2'b0;
	compressor_3to2_20 c3to2_20_12({4'b0,PP_4[17:2]},{2'b0,PP_5},{PP_6,2'b0},Sum12[21:2],Carry12[21:2]);
	assign Sum12[1:0] = {PP_4[1:0]};
	assign Carry12[1:0] = 2'b0;
	compressor_3to2_20 c3to2_20_13({2'b0,PP_7},{PP_8,2'b0},{1'b0,PP_9,4'b0},Sum13,Carry13);
	
	// level-2 3to2
	wire signed [27:0]Carry21,Sum21;
	wire signed [25:0]Carry22,Sum22;
	compressor_3to2_20 c3to2_20_21({5'b0,Carry11[21:7]},{6'b0,Sum11[21:8]},Sum12[21:2],Sum21[27:8],Carry21[27:8]);
	compressor_3to2 c3to2_21(Carry11[6],Sum11[7],Sum12[1],Sum21[7],Carry21[7]);
	compressor_3to2 c3to2_22(Carry11[5],Sum11[6],Sum12[0],Sum21[6],Carry21[6]);
	compressor_3to2 c3to2_24(Carry11[4],Sum11[5],1'b0,Sum21[5],Carry21[5]);
	compressor_3to2 c3to2_25(Carry11[3],Sum11[4],1'b0,Sum21[4],Carry21[4]);
	compressor_3to2 c3to2_26(Carry11[2],Sum11[3],1'b0,Sum21[3],Carry21[3]);
	compressor_3to2 c3to2_27(Carry11[1],Sum11[2],1'b0,Sum21[2],Carry21[2]);
	compressor_3to2 c3to2_28(Carry11[0],Sum11[1],1'b0,Sum21[1],Carry21[1]);
	assign Sum21[0] = Sum11[0];
	assign Carry21[0] = 1'b0;
	compressor_3to2_20 c3to2_20_22({4'b0,Carry12[21:6]},{1'b0,Sum13[19:1]},Carry13,Sum22[25:6],Carry22[25:6]);
	compressor_3to2 c3to2_23(Carry12[5],Sum13[0],1'b0,Sum22[5],Carry22[5]);
	assign Sum22[4:0] = Carry12[4:0];
	assign Carry22[4:0] = {5'b0};
	// level-3 4to2

	assign P_32 = {3'b0,Carry21,1'b0} + {4'b0,Sum21} + {Carry22[23:0],8'b0} + {Sum22[24:0],7'b0};
	// assign P_out = {10'b0,Sum11} + {9'b0,Carry11,1'b0} + {4'b0,Sum12,6'b0} + {Sum13,12'b0} + {Carry13[18:0],13'b0} + {3'b0,Carry12,7'b0};	// pass!!!
	// assign P_32 = PP_1 + {PP_2,2'b0} + {PP_3,4'b0} + {PP_4,6'b0} + {PP_5,8'b0} + {PP_6,10'b0} + {PP_7,12'b0} + {PP_8,14'b0} + {PP_9,16'b0};
	// compressor_tree compressor_tree_my(PP_1,PP_2,PP_3,PP_4,PP_5,PP_6,PP_7,PP_8,PP_9,P_out);
	bin32to16 bin32to16_my(P_32,P_16);
endmodule

// cut the 32-bit result of multiplier to 16-bit
module bin32to16(A,B);
	input signed [31:0]A;
	output signed [15:0]B;
	assign B = {A[31],A[26:12]};
endmodule

module booth_2_unit(A,B,PP);
	input [2:0] A;
	input signed [15:0] B;
	output reg signed [15:0] PP;

	wire signed [15:0] B_not;
	wire signed [15:0] B_shift;
	wire signed [15:0] B_shift_not;

	assign B_not = ~B;
	assign B_shift = {B[14:0],1'b0}; // left shift after adding signed-bit
	assign B_shift_not = ~B_shift;

	always@(*) begin
	// always@(A) begin !!! bug-1-fixed: no output data.
		case(A)
			3'b000: PP = 16'h0;					// +0
			3'b001: PP = B;						// +X
			3'b010:	PP = B; 					// +X
			3'b011: PP = B_shift;				// +2X
			3'b100: PP = B_shift_not + 1'b1;	// -2X
			3'b101: PP = B_not + 1'b1;			// -X
			3'b110: PP = B_not + 1'b1; 			// -X
			3'b111: PP = 16'h0;					// -0
		endcase
	end
endmodule

module compressor_3to2_4(A_1,A_2,A_3,Sum,Carry);
	input [3:0]A_1,A_2,A_3;
	output [3:0]Sum,Carry;
	compressor_3to2 c3to2_0(A_1[0],A_2[0],A_3[0],Sum[0],Carry[0]);
	compressor_3to2 c3to2_1(A_1[1],A_2[1],A_3[1],Sum[1],Carry[1]);
	compressor_3to2 c3to2_2(A_1[2],A_2[2],A_3[2],Sum[2],Carry[2]);
	compressor_3to2 c3to2_3(A_1[3],A_2[3],A_3[3],Sum[3],Carry[3]);
endmodule

module compressor_3to2_20(A_1,A_2,A_3,Sum,Carry);
	input [19:0]A_1,A_2,A_3;
	output [19:0]Sum,Carry;
	compressor_3to2_4 c3to2_4_0(A_1[3:0],A_2[3:0],A_3[3:0],Sum[3:0],Carry[3:0]);
	compressor_3to2_4 c3to2_4_1(A_1[7:4],A_2[7:4],A_3[7:4],Sum[7:4],Carry[7:4]);
	compressor_3to2_4 c3to2_4_2(A_1[11:8],A_2[11:8],A_3[11:8],Sum[11:8],Carry[11:8]);
	compressor_3to2_4 c3to2_4_3(A_1[15:12],A_2[15:12],A_3[15:12],Sum[15:12],Carry[15:12]);
	compressor_3to2_4 c3to2_4_4(A_1[19:16],A_2[19:16],A_3[19:16],Sum[19:16],Carry[19:16]);
endmodule

module compressor_3to2(a,b,cin,sum,cout);
	input a,b,cin;
	output sum,cout;
	//assign s = a ^ b ^ c;
	assign sum = a + b + cin;
	assign cout = (a&b) + (a&cin) + (b&cin); 
endmodule