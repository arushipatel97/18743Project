module SieveOfEratosthenes (
	input logic clock, reset_n,
	input logic calculating,
	input logic start_calculation,
	input logic [9:0] max_prime,
	input logic [5:0] sqrt_bound,
	output logic done_calculating,
	output logic [9:0] boolean_ram_index,
	output logic boolean_ram_wren);

	logic [9:0] prime_iterator_r, prime_iterator_b;
	logic [9:0] multiple_iterator_r, multiple_iterator_b;

	logic [9:0] multiple_iterator_step_size_r, multiple_iterator_step_size_b;

	logic increment_prime_iterator;

	logic first_multiple_r, first_multiple_b;

	logic [5:0] sqrt_bound_r, sqrt_bound_b;

	assign increment_prime_iterator = ((multiple_iterator_r + multiple_iterator_step_size_r) > max_prime) && !start_calculation;
	assign done_calculating = (prime_iterator_r == sqrt_bound_r) && (increment_prime_iterator);
	assign boolean_ram_index = multiple_iterator_r;
    assign boolean_ram_wren = !first_multiple_r;

	always_comb 
	begin
		prime_iterator_b = prime_iterator_r;
		multiple_iterator_b = multiple_iterator_r;
		multiple_iterator_step_size_b = multiple_iterator_step_size_r;
		first_multiple_b = 0;
		sqrt_bound_b = sqrt_bound_r;

		if(start_calculation) 
		begin
			sqrt_bound_b = sqrt_bound;
		end

		if(increment_prime_iterator) 
		begin
			prime_iterator_b = prime_iterator_r + 1;
			first_multiple_b = 1;
			multiple_iterator_b = prime_iterator_b;
			multiple_iterator_step_size_b = prime_iterator_b;
		end
		else 
		begin
			multiple_iterator_b = multiple_iterator_r + multiple_iterator_step_size_r;
		end
	end

	always_ff @(posedge clock or negedge reset_n) 
	begin
		if(~reset_n) 
		begin
			prime_iterator_r <= 2;
			multiple_iterator_r <= 2;
			multiple_iterator_step_size_r <= 2;
			first_multiple_r <= 1;
			sqrt_bound_r <= 0;
		end
		else if(calculating)
		begin
			prime_iterator_r <= prime_iterator_b;
			multiple_iterator_r <= multiple_iterator_b;
			multiple_iterator_step_size_r <= multiple_iterator_step_size_b;
			first_multiple_r <= first_multiple_b;
		end
		else if(start_calculation)
		begin
			sqrt_bound_r <= sqrt_bound_b;
		end
		else if(done_calculating)
		begin
			prime_iterator_r <= 2;
			multiple_iterator_r <= 2;
			multiple_iterator_step_size_r <= 2;
			first_multiple_r <= 1;
			sqrt_bound_r <= 0;
		end
	end

endmodule