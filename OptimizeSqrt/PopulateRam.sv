module PopulateRam (
	input logic clk,    // Clock
	input logic reset_n, // Reset
	input logic bool_ram_q, // bool value at BoolRam[boolean_ram_index]
	input logic populating, // Handshake signal to indicate start populating
	input logic [9:0] max_prime,
	output logic done_populating, 
	output logic [9:0] boolean_ram_index, // Output to BoolRam to read data
	output logic [7:0] prime_ram_index, // Output to PrimeRam to write data,
	output logic prime_ram_wren // Output to PrimeRam to enable writing
);

  logic [7:0] prime_ram_index_b, prime_ram_index_r;
  logic [9:0] boolean_ram_index_b, boolean_ram_index_r;

  assign boolean_ram_index = boolean_ram_index_r;
  assign prime_ram_index = prime_ram_index_r; 
  assign prime_ram_wren = !bool_ram_q;
  assign done_populating = boolean_ram_index_r == max_prime;

  always_comb 
  begin
        prime_ram_index_b = prime_ram_index_r;
        boolean_ram_index_b = boolean_ram_index_r + 1;
        if(!bool_ram_q) 
        begin
        	prime_ram_index_b = prime_ram_index_r + 1;
        end
  end


  always_ff @(posedge clk or negedge reset_n) begin
  	if(~reset_n) 
  	begin
  		prime_ram_index_r <= 0;
  		boolean_ram_index_r <= 2;
  	end 
  	else if(populating) 
  	begin
  	    boolean_ram_index_r <= boolean_ram_index_b;
  	    prime_ram_index_r <= prime_ram_index_b;
  	end
  end

endmodule