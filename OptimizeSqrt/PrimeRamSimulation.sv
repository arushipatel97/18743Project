module PrimeRamSimulation 
(  input  logic clock,
   input  logic wren,
   input  logic ren,
   input  logic [9:0]   data,
   input  logic  [7:0]   address,
   output logic [9:0] q);

   logic [9:0] mem [167:0];

   assign q = ren ? mem[address] : 'z;

   always @(posedge clock)
    if (wren)
      mem[address] <= data;
      
  initial $readmemh("prime_ram.hex", mem);

endmodule