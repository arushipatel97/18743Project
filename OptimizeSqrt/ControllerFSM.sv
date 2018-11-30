module ControllerFSM (
	input logic clk,    // Clock
	input logic reset_n, // Reset,
	input logic calculate, // User input to start prime number generation
	input logic done_calculating, // Done generating boolean array
	input logic done_populating, // Done populating prime array
	input logic new_max_prime, // Indicates used wants to change the max_prime
	output logic start_calculation,
	output logic calculating,
	output logic populating,
	output logic finished
);

	enum logic[2:0] {Idle, Calculating, Populate_RAM, Finished} currentState, nextState;

	always_comb 
	begin
		nextState = Idle;
		case (currentState)
			Idle: nextState = calculate ? Calculating : Idle;
			Calculating: nextState = done_calculating ? Populate_RAM : Calculating;
			Populate_RAM: nextState = done_populating ? Finished : Populate_RAM;
			Finished: nextState = new_max_prime ? Calculating : Finished;
		endcase
	end

	always_comb 
	begin
		calculating = 0;
		populating = 0;
		start_calculation = 0;
		finished = 0;
		case (currentState)
			Idle: start_calculation = calculate;
			Calculating: begin
							if(!done_calculating) 
							begin
								calculating = 1;
							end
							else
							begin
								populating = 1;
							end
						end
			Populate_RAM: populating = !done_populating;
			Finished: begin 
						if(new_max_prime) 
						begin
							start_calculation = 1;
						end
						else 
							finished = 1;
					  end
		endcase
	end

	always_ff @(posedge clk or negedge reset_n) begin
		if(~reset_n) 
		begin
			currentState <= Idle;
		end 
		else 
		begin
			currentState <= nextState;
		end
	end

endmodule