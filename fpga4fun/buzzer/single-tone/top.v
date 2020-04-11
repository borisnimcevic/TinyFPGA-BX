// look in pins.pcf for all the pin names on the TinyFPGA BX board


module music (
  input CLK,
  output PIN_10,
  output USBPU  // USB pull-up resistor
  );

parameter frequency = 600;
parameter clkdivider = 16000000/frequency/2;

// drive USB pull-up resistor to '0' to disable USB
assign USBPU = 0;

reg [14:0] music_counter;
always @(posedge CLK) begin
  if (music_counter==0) music_counter <= clkdivider-1;
  else music_counter <= music_counter-1;
end

reg PIN_10;
always @ (posedge CLK) begin
  if (music_counter == 0) PIN_10 <= ~PIN_10;
end


endmodule
