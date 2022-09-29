S`timescale 1ns/10ps
module CS(Y, X, reset, clk);

  input clk, reset; 
  input 	[7:0] X;
  output 	[9:0] Y;
  
  //--------------------------------------
  //  \^o^/   Write your code here~  \^o^/S
  //--------------------------------------
  reg [71:0] data;  //8-bit per X, n = 9 -> 8*9=72
  reg [11:0] X_sum;
  reg [11:0] X_avg;
  reg [11:0] X_app;
  //reg flag = 0;
  
  always @(posedge clk or posedge reset) begin  // always, clk -> use non-blocking assignment!
    if(reset) begin // reset
      data[7:0] <= 8'b00000000;              // X0
      data[15:8] <= 8'b00000000;             // X1
      data[23:16] <= 8'b00000000;            // X2
      data[31:24] <= 8'b00000000;            // X3
      data[39:32] <= 8'b00000000;            // X4
      data[47:40] <= 8'b00000000;            // X5
      data[55:48] <= 8'b00000000;            // X6
      data[63:56] <= 8'b00000000;            // X7
      data[71:64] <= 8'b00000000;            // X8
      X_sum <= 0;
      X_avg <= 0;
      X_app <= 0;
      //flag <= 0;
    end
    else begin
      // input data
      data[71:64] <= data[63:56];            // X8
      data[63:56] <= data[55:48];            // X7
      data[55:48] <= data[47:40];            // X6
      data[47:40] <= data[39:32];            // X5
      data[39:32] <= data[31:24];            // X4
      data[31:24] <= data[23:16];            // X3
      data[23:16] <= data[15:8];             // X2
      data[15:8] <= data[7:0];               // X1
      data[7:0] <= X;                        // X0
        
      //  calculate X_sum
      X_sum <= data[7:0] + data[15:8] + data[23:16] + data[31:24] + data[39:32] + data[47:40] + data[55:48] + data[63:56] + data[71:64];
        
      //  calculate X_avg
      X_avg <= X_sum / 9;

      //  find X_app
      if(data[7:0] == X_avg) begin  //  if X_avg in XS
        X_app <= data[7:0];
        //flag <= 1;
      end
      if(data[15:8] == X_avg) begin
        X_app <= data[15:8];
        //flag <= 1;
      end
      if(data[23:16] == X_avg) begin
        X_app <= data[23:16];
        //flag <= 1;
      end
      if(data[31:24] == X_avg) begin
        X_app <= data[31:24];
        //flag <= 1;
      end
      if(data[39:32] == X_avg) begin
        X_app <= data[39:32];
        //flag <= 1;
      end
      if(data[47:40] == X_avg) begin
        X_app <= data[47:40];
        //flag <= 1;
      end
      if(data[55:48] == X_avg) begin
        X_app <= data[55:48];
        //flag <= 1;
      end
      if(data[63:56] == X_avg) begin
        X_app <= data[63:56];
        //flag <= 1;
      end
      if(data[71:64] == X_avg) begin
        X_app <= data[71:64];
        //flag <= 1;
      end
      //  if X_avg not in XS
      //if(!flag) begin
        if(data[7:0] < X_avg) begin
          if(X_app == 0) begin
            X_app <= data[7:0];
            end
            if(data[7:0] > X_app) begin
              X_app <= data[7:0];
            end
            else begin
              X_app <= X_app;
            end
          end
        if(data[15:8] < X_avg) begin
          if(X_app == 0) begin
            X_app <= data[15:8];
          end
          if(data[15:8] > X_app) begin
            X_app <= data[15:8];
          end 
          else begin
            X_app <= X_app;
          end
        end
        if(data[23:16] < X_avg) begin
          if(X_app == 0) begin
            X_app <= data[23:16];
          end
          if(data[23:16] > X_app) begin
            X_app <= data[23:16];
          end 
          else begin
            X_app <= X_app;
          end
        end
        if(data[31:24] < X_avg) begin
          if(X_app == 0) begin
            X_app <= data[31:24];
          end
          if(data[31:24] > X_app) begin
            X_app <= data[31:24];
          end 
          else begin
            X_app <= X_app;
          end
        end
        if(data[39:32] < X_avg) begin
          if(X_app == 0) begin
            X_app <= data[39:32];
          end
          if(data[39:32] > X_app) begin
            X_app <= data[39:32];
          end 
          else begin
            X_app <= X_app;
          end
        end
        if(data[47:40] < X_avg) begin
          if(X_app == 0) begin
            X_app <= data[47:40];
          end
          if(data[47:40] > X_app) begin
            X_app <= data[47:40];
          end 
          else begin
            X_app <= X_app;
          end
        end
        if(data[55:48] < X_avg) begin
          if(X_app == 0) begin
            X_app <= data[55:48];
          end
          if(data[55:48] > X_app) begin
            X_app <= data[55:48];
          end 
          else begin
          X_app <= X_app;
          end
        end
        if(data[63:56] < X_avg) begin
          if(X_app == 0) begin
            X_app <= data[63:56];
          end
          if(data[63:56] > X_app) begin
            X_app <= data[63:56];
          end 
          else begin
            X_app <= X_app;
          end
        end
        if(data[71:64] < X_avg) begin
          if(X_app == 0) begin
          X_app <= data[71:64];
          end
          if(data[71:64] > X_app) begin
            X_app <= data[71:64];
          end 
          else begin
            X_app <= X_app;
          end
        end
      //end
      //  calculate Y
      //Y <= (X_sum + (X_app * 9)) / (9 - 1);
    end    
  end
  
  assign Y = (X_sum + (X_app * 9)) / (9 - 1);
  
endmodule
