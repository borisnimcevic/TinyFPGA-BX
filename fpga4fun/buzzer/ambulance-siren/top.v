// look in pins.pcf for all the pin names on the TinyFPGA BX board


module music (
  input CLK,
  output PIN_10,
  output USBPU  // USB pull-up resistor
  );
// drive USB pull-up resistor to '0' to disable USB
assign USBPU = 0;

parameter frequency = 440;
parameter clkdivider = 16000000/frequency/2;

reg [23:0] tone;
always @ ( posedge CLK ) begin
  tone <= tone + 1;
end

reg [14:0] music_counter;
always @(posedge CLK) begin
  if (music_counter==0) music_counter <= tone[23] ? clkdivider-1 : clkdivider/2-1;
  else music_counter <= music_counter-1;
end

reg PIN_10;
always @ (posedge CLK) begin
  if (music_counter == 0) PIN_10 <= ~PIN_10;
end


endmodule
