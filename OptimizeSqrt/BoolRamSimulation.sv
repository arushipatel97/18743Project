module BoolRamSimulation 
(  input  logic clock,
   input  logic wren,
   input  logic ren,
   input  logic data,
   input  logic  [9:0]   address,
   output logic  q);

   logic mem [999:0];

   assign q = ren ? mem[address] : 'z;

   always @(posedge clock)
    if (wren)
      mem[address] <= data;
      
  initial $readmemh("bool_ram.hex", mem);

endmodule