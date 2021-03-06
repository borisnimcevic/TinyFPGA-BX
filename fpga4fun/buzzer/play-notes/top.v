// look in pins.pcf for all the pin names on the TinyFPGA BX board

module divide_by12 (
  input [5:0] numer,
  output [2:0] quotient,
  output [3:0] remain
  );

  reg [2:0] quotient;
  reg [3:0] remain_bit3_bit2;

  assign remain = {remain_bit3_bit2, numer[1:0]}; // the first 2 bits are copied through

  always @(numer[5:2]) // and just do a divide by "3" on the remaining bits
  case(numer[5:2])
     0: begin quotient=0; remain_bit3_bit2=0; end
     1: begin quotient=0; remain_bit3_bit2=1; end
     2: begin quotient=0; remain_bit3_bit2=2; end
     3: begin quotient=1; remain_bit3_bit2=0; end
     4: begin quotient=1; remain_bit3_bit2=1; end
     5: begin quotient=1; remain_bit3_bit2=2; end
     6: begin quotient=2; remain_bit3_bit2=0; end
     7: begin quotient=2; remain_bit3_bit2=1; end
     8: begin quotient=2; remain_bit3_bit2=2; end
     9: begin quotient=3; remain_bit3_bit2=0; end
   10: begin quotient=3; remain_bit3_bit2=1; end
   11: begin quotient=3; remain_bit3_bit2=2; end
   12: begin quotient=4; remain_bit3_bit2=0; end
   13: begin quotient=4; remain_bit3_bit2=1; end
   14: begin quotient=4; remain_bit3_bit2=2; end
   15: begin quotient=5; remain_bit3_bit2=0; end
  endcase
endmodule // divide_by12

module music (
  input CLK,
  output PIN_10,
  output USBPU  // USB pull-up resistor
  );
// drive USB pull-up resistor to '0' to disable USB
assign USBPU = 0;

reg [26:0] tone;
always @ ( posedge CLK ) begin
  tone <= tone + 1;
end

wire [5:0] fullnote = tone [26:21];
wire [2:0] octave;
wire [3:0] note;
divide_by12 divby12(.numer(fullnote[5:0]), .quotient(octave), .remain(note));

reg [8:0] clkdivider;
always @ ( note ) begin
    case(note)
      0: clkdivider = 512-1; // A
      1: clkdivider = 483-1; // A#/Bb
      2: clkdivider = 456-1; // B
      3: clkdivider = 431-1; // C
      4: clkdivider = 406-1; // C#/Db
      5: clkdivider = 384-1; // D
      6: clkdivider = 362-1; // D#/Eb
      7: clkdivider = 342-1; // E
      8: clkdivider = 323-1; // F
      9: clkdivider = 304-1; // F#/Gb
      10: clkdivider = 287-1; // G
      11: clkdivider = 271-1; // G#/Ab
      12: clkdivider = 0; // should never happen
      13: clkdivider = 0; // should never happen
      14: clkdivider = 0; // should never happen
      15: clkdivider = 0; // should never happen
    endcase
end

reg [8:0] counter_note;
always @(posedge CLK) begin
  if (counter_note==0) counter_note <= clkdivider;
  else counter_note <= counter_note-1;
end

reg [7:0] counter_octave;
always @ ( posedge CLK ) begin
  if (counter_note == 0) begin
    if(counter_octave == 0)
      counter_octave <= (octave==0?255:octave==1?127:octave==2?63:octave==3?31:octave==4?15:7);
    else
      counter_octave <= counter_octave-1;
  end
end

reg PIN_10;
always @ (posedge CLK) begin
  if (counter_note==0 && counter_octave==0) PIN_10 <= ~PIN_10;
end


endmodule
