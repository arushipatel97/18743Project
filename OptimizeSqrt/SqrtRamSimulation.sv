module SqrtRamSimulation 
(  input  logic clock,
   input  logic wren,
   input  logic ren,
   input  logic [5:0]   data,
   input  logic  [9:0]   address,
   output logic [5:0] q);

   logic [5:0] mem [999:0];

   assign q = ren ? mem[address] : 'z;

   always @(posedge clock)
    if (wren)
      mem[address] <= data;
      
  initial $readmemh("square_root.hex", mem);

endmodule