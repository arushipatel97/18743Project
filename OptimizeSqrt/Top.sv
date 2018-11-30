module Top (
	input logic clk,    // Clock
	input logic reset_n, // Reset
	input logic [9:0] max_prime, // User specified upper limit on prime
	input logic [7:0] user_prime_ram_address, // User specified to get random prime from RAM
	input logic get_prime,
	input logic calculate, // Input from user to start prime number generation
	output logic finished,
	output logic [9:0] prime_ram_q // Random prime from generated RAM
);

	logic bool_ram_wren;
	logic bool_ram_ren;
	logic [9:0] bool_ram_address;
	logic bool_ram_q;

	logic sqrt_ram_wren;
	logic sqrt_ram_ren;
	logic [5:0] sqrt_ram_data;
	logic [9:0] sqrt_ram_address;
	logic [5:0] sqrt_ram_q;

	logic prime_ram_wren;
	logic prime_ram_ren;
	logic [9:0] prime_ram_data;
	logic [7:0] prime_ram_address;

    logic start_calculation;
	logic done_calculating;
	logic done_populating;
	logic new_max_prime;
	logic calculating;
	logic populating;

	logic [9:0] boolean_ram_address_populate;
	logic boolean_ram_ren_populate;
	logic [7:0] prime_ram_address_populate;
	logic prime_ram_wren_populate;

	logic [9:0] max_prime_r;

	logic [9:0] boolean_ram_address_calculate;
	logic boolean_ram_wren_calculate;

	assign new_max_prime = (max_prime_r != max_prime) && calculate;
	always_comb
	begin
	    bool_ram_wren = 0;
	    bool_ram_ren = 0;
	    bool_ram_address = 0;

	    sqrt_ram_wren = 0;
	    sqrt_ram_ren = 0;
	    sqrt_ram_data = 0;
	    sqrt_ram_address = 0;

	    prime_ram_wren = 0;
	    prime_ram_ren = 0;
	    prime_ram_data = 0;
	    prime_ram_address = 0;
	    if(start_calculation) 
	    begin
	    	sqrt_ram_address = max_prime;
	    	sqrt_ram_ren = 1;
	    end
		if(start_calculation || calculating) 
		begin
			bool_ram_address = boolean_ram_address_calculate;
			bool_ram_wren = boolean_ram_wren_calculate;
		end
		else if(populating) 
		begin
			bool_ram_address = boolean_ram_address_populate;
			bool_ram_ren = 1;
			prime_ram_address = prime_ram_address_populate;
			prime_ram_data = boolean_ram_address_populate;
			prime_ram_wren = prime_ram_wren_populate;
		end
		else if(finished && get_prime) 
		begin
			prime_ram_ren = 1;
			prime_ram_address = user_prime_ram_address;
		end
	end

    BoolRamSimulation booleanRam(.clock(clk),.wren(bool_ram_wren),.ren(bool_ram_ren),.data(1),.address(bool_ram_address),.q(bool_ram_q));
    SqrtRamSimulation sqrtRam(.clock(clk),.wren(sqrt_ram_wren),.ren(sqrt_ram_ren),.data(sqrt_ram_data),.address(sqrt_ram_address),.q(sqrt_ram_q));
    PrimeRamSimulation primeRam(.clock(clk),.wren(prime_ram_wren),.ren(prime_ram_ren),.data(prime_ram_data),.address(prime_ram_address),.q(prime_ram_q));

    ControllerFSM controlFSM(.clk, .reset_n, .calculate, .done_calculating, .done_populating, .new_max_prime, .start_calculation,
    								.calculating, .populating, .finished);
    PopulateRam popRam(.clk, .reset_n, .bool_ram_q, .populating, .done_populating, .boolean_ram_index(boolean_ram_address_populate),
    							.prime_ram_index(prime_ram_address_populate), .prime_ram_wren(prime_ram_wren_populate),
    							.max_prime(max_prime_r));
    SieveOfEratosthenes calculatePrimes(.clock(clk), .reset_n, .calculating, .start_calculation, .sqrt_bound(sqrt_ram_q), .done_calculating,
    										.boolean_ram_index(boolean_ram_address_calculate), .boolean_ram_wren(boolean_ram_wren_calculate),
    										.max_prime(start_calculation ? max_prime : max_prime_r));

    always_ff @(posedge clk, negedge reset_n) begin
    	if(~reset_n) 
    	begin
    		 max_prime_r <= 0;
    	end 
    	else 
    	begin
    		if(new_max_prime) 
    		begin
    			max_prime_r <= max_prime;
    		end
    	end
    end

endmodule

module TopTest ();

	logic clk, reset_n, calculate, finished, get_prime;
	logic [9:0] max_prime;
	logic [7:0] user_prime_ram_address;
	logic [9:0] prime_ram_q;

	Top(.*);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial begin
		$monitor("PRIME = %d\n",prime_ram_q);
	end

	initial begin
		reset_n = 0;
		reset_n <= 1;
		calculate = 0;
		max_prime = 0;
		user_prime_ram_address = 0;
		get_prime = 0;
		@(posedge  clk);
		max_prime = 100;
		calculate = 1;
		@(posedge  clk);
		calculate = 0;
		while(!finished)
		begin
			@(posedge clk);
		end
		@(posedge clk);
		get_prime = 1;
		user_prime_ram_address = 11;
		@(posedge clk);
		get_prime = 0;
		user_prime_ram_address = 0;
		max_prime = 500;
		calculate = 1;
		@(posedge  clk);
		calculate = 0;
		while(!finished)
		begin
			@(posedge clk);
		end
		@(posedge clk);
		get_prime = 1;
		user_prime_ram_address = 57;
		@(posedge clk);
		$finish;
	end

endmodule

