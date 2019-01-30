/*
   This file was generated automatically by the Mojo IDE version B1.3.6.
   Do not edit this file directly. Instead edit the original Lucid source.
   This is a temporary file and any changes made to it will be destroyed.
*/

module panel_27_31 (
    input clk,
    input rst,
    input spiBusySignal,
    output reg newSpiData,
    output reg [7:0] ledByteOut,
    output reg [9:0] ramPixelAddress,
    output reg idle,
    input [23:0] rgbIn,
    input startWritingFlag,
    output reg out
  );
  
  
  
  localparam IDLE_state = 1'd0;
  localparam WRITE_state = 1'd1;
  
  reg M_state_d, M_state_q = IDLE_state;
  reg [3:0] M_ledStartBitCounter_d, M_ledStartBitCounter_q = 1'h0;
  reg [3:0] M_rgbCounter_d, M_rgbCounter_q = 1'h0;
  reg [9:0] M_pixelAddress_d, M_pixelAddress_q = 1'h0;
  reg [1:0] M_panelControl1_d, M_panelControl1_q = 1'h0;
  reg [23:0] M_rgbPixels_d, M_rgbPixels_q = 1'h0;
  
  always @* begin
    M_state_d = M_state_q;
    M_ledStartBitCounter_d = M_ledStartBitCounter_q;
    M_panelControl1_d = M_panelControl1_q;
    M_rgbPixels_d = M_rgbPixels_q;
    M_pixelAddress_d = M_pixelAddress_q;
    M_rgbCounter_d = M_rgbCounter_q;
    
    out = 1'h0;
    idle = 1'h0;
    newSpiData = 1'h0;
    ledByteOut = 1'h0;
    ramPixelAddress = 1'h0;
    M_rgbPixels_d[0+23-:24] = rgbIn;
    if (M_panelControl1_q == 1'h0) begin
      idle = 1'h1;
    end
    if (startWritingFlag == 1'h1) begin
      M_panelControl1_d = 2'h3;
      M_ledStartBitCounter_d = 1'h0;
    end
    if (M_panelControl1_q == 2'h3) begin
      M_state_d = WRITE_state;
    end
    
    case (M_state_q)
      IDLE_state: begin
        out = 1'h1;
      end
      WRITE_state: begin
        ramPixelAddress = M_pixelAddress_q;
        if (M_ledStartBitCounter_q < 3'h5 && !spiBusySignal) begin
          ledByteOut = 8'h00;
          newSpiData = 1'h1;
          M_ledStartBitCounter_d = M_ledStartBitCounter_q + 1'h1;
          M_pixelAddress_d = 1'h0;
          M_rgbCounter_d = 1'h0;
        end
        if (M_ledStartBitCounter_q == 3'h5) begin
          if (M_pixelAddress_q > 10'h2a8) begin
            M_rgbPixels_d = 1'h0;
          end
          if (M_rgbCounter_q == 1'h0 && !spiBusySignal) begin
            ledByteOut = 8'he3;
            newSpiData = 1'h1;
            M_rgbCounter_d = 1'h1;
          end
          if (M_rgbCounter_q == 1'h1 && !spiBusySignal) begin
            ledByteOut = M_rgbPixels_q[16+7-:8];
            newSpiData = 1'h1;
            M_rgbCounter_d = 2'h2;
          end
          if (M_rgbCounter_q == 2'h2 && !spiBusySignal) begin
            ledByteOut = M_rgbPixels_q[8+7-:8];
            newSpiData = 1'h1;
            M_rgbCounter_d = 2'h3;
          end
          if (M_rgbCounter_q == 2'h3 && !spiBusySignal) begin
            ledByteOut = M_rgbPixels_q[0+7-:8];
            newSpiData = 1'h1;
            M_rgbCounter_d = 3'h4;
          end
          if (M_rgbCounter_q == 3'h4) begin
            M_pixelAddress_d = M_pixelAddress_q + 1'h1;
            M_rgbCounter_d = 3'h5;
          end
          if (M_rgbCounter_q == 3'h5) begin
            M_rgbCounter_d = 1'h0;
            if (M_pixelAddress_q == 9'h110) begin
              M_pixelAddress_d = 9'h113;
            end
            if (M_pixelAddress_q == 9'h12f) begin
              M_pixelAddress_d = 9'h135;
            end
            if (M_pixelAddress_q == 9'h151) begin
              M_pixelAddress_d = 9'h157;
            end
            if (M_pixelAddress_q == 9'h173) begin
              M_pixelAddress_d = 9'h179;
            end
            if (M_pixelAddress_q == 9'h195) begin
              M_pixelAddress_d = 9'h198;
            end
            if (M_pixelAddress_q == 10'h2b2) begin
              M_ledStartBitCounter_d = 4'hb;
              M_panelControl1_d = 1'h0;
              M_state_d = IDLE_state;
            end
          end
        end
      end
    endcase
  end
  
  always @(posedge clk) begin
    M_ledStartBitCounter_q <= M_ledStartBitCounter_d;
    M_rgbCounter_q <= M_rgbCounter_d;
    M_pixelAddress_q <= M_pixelAddress_d;
    M_panelControl1_q <= M_panelControl1_d;
    M_rgbPixels_q <= M_rgbPixels_d;
    
    if (rst == 1'b1) begin
      M_state_q <= 1'h0;
    end else begin
      M_state_q <= M_state_d;
    end
  end
  
endmodule
