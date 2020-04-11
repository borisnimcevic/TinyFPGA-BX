// look in pins.pcf for all the pin names on the TinyFPGA BX board


module music (
  input CLK,
  output PIN_10,
  output USBPU  // USB pull-up resistor
  );
// drive USB pull-up resistor to '0' to disable USB
assign USBPU = 0;

reg [21:0] tone;
always @ ( posedge CLK ) begin
  tone <= tone + 1;
end

wire [6:0] ramp = (tone[21] ? tone[20:14] : ~tone[20:14]);
wire [14:0] clkdivider = {3'b001,ramp,5'b00000};

reg [14:0] music_counter;
always @(posedge CLK) begin
  if (music_counter==0) music_counter <= clkdivider;
  else music_counter <= music_counter-1;
end

reg PIN_10;
always @ (posedge CLK) begin
  if (music_counter == 0) PIN_10 <= ~PIN_10;
end


endmodule
