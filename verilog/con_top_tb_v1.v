`timescale 1ns/1ns

module con_5x5_tb();
	reg rst_n,clk,ena;
	reg [15:0] data;
	reg [15:0] data_core[1:3][1:3]; 
	reg [15:0] data_pics[1:7][1:7];

	wire [15:0] result;
	wire valid;
	parameter T_clk = 10;
	parameter T_half = T_clk / 2;
	initial $readmemh ("weights_data.txt",data_core); 
	initial $readmemh ("input_data.txt",data_pics);
	con_5x5 con_5x5_uut(
		.rst_n(rst_n),
		.clk(clk),
		.ena(ena),
		.data(data),
		.valid(valid),
		.finish(finish),
		.result(result)
		);

	always @(negedge valid) begin
		$display("%h",result);
	end
	initial begin
		ena = 1'b0;
		#T_clk ena = 1'b1;
		#(90*T_clk) ena = 1'b0;

		#(5*T_clk) ena =1'b1;
		#(90*T_clk) ena = 1'b0;
	end

	initial begin
		#T_clk data = data_core[1][1];
		#T_clk data = data_core[1][2];
		#T_clk data = data_core[1][3];

		#T_clk data = data_core[2][1];
		#T_clk data = data_core[2][2];
		#T_clk data = data_core[2][3];

		#T_clk data = data_core[3][1];
		#T_clk data = data_core[3][2];
		#T_clk data = data_core[3][3];

		// data_pics -1
		#T_clk data = data_pics[1][1];
		#T_clk data = data_pics[2][1];
		#T_clk data = data_pics[3][1];

		#T_clk data = data_pics[1][2];
		#T_clk data = data_pics[2][2];
		#T_clk data = data_pics[3][2];

		#T_clk data = data_pics[1][3];
		#T_clk data = data_pics[2][3];
		#T_clk data = data_pics[3][3];
		// 12
		#T_clk data = data_pics[1][4];
		#T_clk data = data_pics[2][4];
		#T_clk data = data_pics[3][4];
		// 13
		#T_clk data = data_pics[1][5];
		#T_clk data = data_pics[2][5];
		#T_clk data = data_pics[3][5];
		// 14
		#T_clk data = data_pics[1][6];
		#T_clk data = data_pics[2][6];
		#T_clk data = data_pics[3][6];
		// 15
		#T_clk data = data_pics[1][7];
		#T_clk data = data_pics[2][7];
		#T_clk data = data_pics[3][7];

		// data pics -2
		// 25
		#T_clk data = data_pics[4][5];
		#T_clk data = data_pics[4][6];
		#T_clk data = data_pics[4][7];
		// 24
		#T_clk data = data_pics[2][4];
		#T_clk data = data_pics[3][4];
		#T_clk data = data_pics[4][4];
		// 23
		#T_clk data = data_pics[2][3];
		#T_clk data = data_pics[3][3];
		#T_clk data = data_pics[4][3];
		// 22
		#T_clk data = data_pics[2][2];
		#T_clk data = data_pics[3][2];
		#T_clk data = data_pics[4][2];
		// 21
		#T_clk data = data_pics[2][1];
		#T_clk data = data_pics[3][1];
		#T_clk data = data_pics[4][1];

		// data pics -3 
		// 31
		#T_clk data = data_pics[5][1];
		#T_clk data = data_pics[5][2];
		#T_clk data = data_pics[5][3];
		// 32
		#T_clk data = data_pics[3][4];
		#T_clk data = data_pics[4][4];
		#T_clk data = data_pics[5][4];
		// 33
		#T_clk data = data_pics[3][5];
		#T_clk data = data_pics[4][5];
		#T_clk data = data_pics[5][5];
		// 34
		#T_clk data = data_pics[3][6];
		#T_clk data = data_pics[4][6];
		#T_clk data = data_pics[5][6];
		// 35
		#T_clk data = data_pics[3][7];
		#T_clk data = data_pics[4][7];
		#T_clk data = data_pics[5][7];

		// data pics -4
		// 45
		#T_clk data = data_pics[6][5];
		#T_clk data = data_pics[6][6];
		#T_clk data = data_pics[6][7];
		// 44
		#T_clk data = data_pics[4][4];
		#T_clk data = data_pics[5][4];
		#T_clk data = data_pics[6][4];
		// 43
		#T_clk data = data_pics[4][3];
		#T_clk data = data_pics[5][3];
		#T_clk data = data_pics[6][3];
		// 42
		#T_clk data = data_pics[4][2];
		#T_clk data = data_pics[5][2];
		#T_clk data = data_pics[6][2];
		// 41
		#T_clk data = data_pics[4][1];
		#T_clk data = data_pics[5][1];
		#T_clk data = data_pics[6][1];

		// data pics -5
		// 51
		#T_clk data = data_pics[7][1];
		#T_clk data = data_pics[7][2];
		#T_clk data = data_pics[7][3];
		// 52
		#T_clk data = data_pics[5][4];
		#T_clk data = data_pics[6][4];
		#T_clk data = data_pics[7][4];
		// 53
		#T_clk data = data_pics[5][5];
		#T_clk data = data_pics[6][5];
		#T_clk data = data_pics[7][5];
		// 54
		#T_clk data = data_pics[5][6];
		#T_clk data = data_pics[6][6];
		#T_clk data = data_pics[7][6];
		// 55
		#T_clk data = data_pics[5][7];
		#T_clk data = data_pics[6][7];
		#T_clk data = data_pics[7][7];


		// SECOND ROUND
		#(5*T_clk);
		#T_clk data = data_core[1][1];
		#T_clk data = data_core[1][2];
		#T_clk data = data_core[1][3];

		#T_clk data = data_core[2][1];
		#T_clk data = data_core[2][2];
		#T_clk data = data_core[2][3];

		#T_clk data = data_core[3][1];
		#T_clk data = data_core[3][2];
		#T_clk data = data_core[3][3];

		// data_pics -1
		#T_clk data = data_pics[1][1];
		#T_clk data = data_pics[2][1];
		#T_clk data = data_pics[3][1];

		#T_clk data = data_pics[1][2];
		#T_clk data = data_pics[2][2];
		#T_clk data = data_pics[3][2];

		#T_clk data = data_pics[1][3];
		#T_clk data = data_pics[2][3];
		#T_clk data = data_pics[3][3];
		// 12
		#T_clk data = data_pics[1][4];
		#T_clk data = data_pics[2][4];
		#T_clk data = data_pics[3][4];
		// 13
		#T_clk data = data_pics[1][5];
		#T_clk data = data_pics[2][5];
		#T_clk data = data_pics[3][5];
		// 14
		#T_clk data = data_pics[1][6];
		#T_clk data = data_pics[2][6];
		#T_clk data = data_pics[3][6];
		// 15
		#T_clk data = data_pics[1][7];
		#T_clk data = data_pics[2][7];
		#T_clk data = data_pics[3][7];

		// data pics -2
		// 25
		#T_clk data = data_pics[4][5];
		#T_clk data = data_pics[4][6];
		#T_clk data = data_pics[4][7];
		// 24
		#T_clk data = data_pics[2][4];
		#T_clk data = data_pics[3][4];
		#T_clk data = data_pics[4][4];
		// 23
		#T_clk data = data_pics[2][3];
		#T_clk data = data_pics[3][3];
		#T_clk data = data_pics[4][3];
		// 22
		#T_clk data = data_pics[2][2];
		#T_clk data = data_pics[3][2];
		#T_clk data = data_pics[4][2];
		// 21
		#T_clk data = data_pics[2][1];
		#T_clk data = data_pics[3][1];
		#T_clk data = data_pics[4][1];

		// data pics -3 
		// 31
		#T_clk data = data_pics[5][1];
		#T_clk data = data_pics[5][2];
		#T_clk data = data_pics[5][3];
		// 32
		#T_clk data = data_pics[3][4];
		#T_clk data = data_pics[4][4];
		#T_clk data = data_pics[5][4];
		// 33
		#T_clk data = data_pics[3][5];
		#T_clk data = data_pics[4][5];
		#T_clk data = data_pics[5][5];
		// 34
		#T_clk data = data_pics[3][6];
		#T_clk data = data_pics[4][6];
		#T_clk data = data_pics[5][6];
		// 35
		#T_clk data = data_pics[3][7];
		#T_clk data = data_pics[4][7];
		#T_clk data = data_pics[5][7];

		// data pics -4
		// 45
		#T_clk data = data_pics[6][5];
		#T_clk data = data_pics[6][6];
		#T_clk data = data_pics[6][7];
		// 44
		#T_clk data = data_pics[4][4];
		#T_clk data = data_pics[5][4];
		#T_clk data = data_pics[6][4];
		// 43
		#T_clk data = data_pics[4][3];
		#T_clk data = data_pics[5][3];
		#T_clk data = data_pics[6][3];
		// 42
		#T_clk data = data_pics[4][2];
		#T_clk data = data_pics[5][2];
		#T_clk data = data_pics[6][2];
		// 41
		#T_clk data = data_pics[4][1];
		#T_clk data = data_pics[5][1];
		#T_clk data = data_pics[6][1];

		// data pics -5
		// 51
		#T_clk data = data_pics[7][1];
		#T_clk data = data_pics[7][2];
		#T_clk data = data_pics[7][3];
		// 52
		#T_clk data = data_pics[5][4];
		#T_clk data = data_pics[6][4];
		#T_clk data = data_pics[7][4];
		// 53
		#T_clk data = data_pics[5][5];
		#T_clk data = data_pics[6][5];
		#T_clk data = data_pics[7][5];
		// 54
		#T_clk data = data_pics[5][6];
		#T_clk data = data_pics[6][6];
		#T_clk data = data_pics[7][6];
		// 55
		#T_clk data = data_pics[5][7];
		#T_clk data = data_pics[6][7];
		#T_clk data = data_pics[7][7];
	end
	// total 27 groups, 81 data, ≈ 1/3
	// each 9 datas to make one group, 25 * 9 = 225 data

	initial begin
		rst_n = 1'b0;
		#T_clk rst_n = 1'b1;
	end

	initial begin
		clk = 1'b0;
		forever #T_half clk = ~clk;
	end
endmodule