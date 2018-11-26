module SieveOfEratosthenes (
	input logic clock, reset_n,
	output logic done,
	output logic [100:0] is_prime);

	logic [100:0] prime_iterator_r, prime_iterator_b;
	logic [100:0] multiple_iterator_r, multiple_iterator_b;

	logic [100:0] multiple_iterator_step_size_r, multiple_iterator_step_size_b;

	logic [100:0] is_prime_r, is_prime_b;

	logic increment_prime_iterator;

	logic first_multiple_r, first_multiple_b;

	assign increment_prime_iterator = (multiple_iterator_r + multiple_iterator_step_size_r) > 100;
	assign done = (prime_iterator_r == 100) && (increment_prime_iterator);

	assign is_prime = done ? is_prime_r : '0;

	always_comb
	begin
		is_prime_b = is_prime_r;
		if(!first_multiple_r) 
		begin
			is_prime_b[multiple_iterator_r] = 1;
		end
	end

	always_comb 
	begin
		prime_iterator_b = prime_iterator_r;
		multiple_iterator_b = multiple_iterator_r;
		multiple_iterator_step_size_b = multiple_iterator_step_size_r;
		first_multiple_b = 0;

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
			is_prime_r <= 3;
		end
		else 
		begin
			prime_iterator_r <= prime_iterator_b;
			multiple_iterator_r <= multiple_iterator_b;
			multiple_iterator_step_size_r <= multiple_iterator_step_size_b;
			first_multiple_r <= first_multiple_b;
			is_prime_r <= is_prime_b;
		end
	end

endmodule