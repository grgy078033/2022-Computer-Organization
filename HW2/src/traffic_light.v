module traffic_light (
    input  clk,
    input  rst,
    input  pass,
    output reg R,
    output reg G,
    output reg Y
);

//write your code here
reg [2:0] state = 3'b000;
reg [9:0] count = 10'd0;

always@(posedge clk, posedge rst) begin
    if(rst) begin
        state <= 3'b000;
        count <= 10'd0;
    end
    else begin
        case(state)
            3'b110 : begin // 010
                R <= 0;
                G <= 1;
                Y <= 0;
                count <= count + 1;
                if(pass == 1) begin
                    state <= state;
                    count <= count;
                end
                else begin
                    if(count == 10'd512) begin
                        state <= 3'b000;
                        count <= 10'd0;
                    end
                end
            end
            3'b000 : begin // 000
                R <= 0;
                G <= 0;
                Y <= 0;
                count <= count + 1;
                if(count == 10'd64) begin
                    state <= 3'b001;
                    count <= 10'd0;
                end
            end
            3'b001 : begin // 010
                R <= 0;
                G <= 1;
                Y <= 0;
                count <= count + 1;
                if(pass == 1) begin
                    state <= 3'b110;
                    count <= 10'd0;
                end
                else begin
                    if(count == 10'd64) begin
                        state <= 3'b010;
                        count <= 10'd0;
                    end
                end
            end
            3'b010 : begin // 000
                R <= 0;
                G <= 0;
                Y <= 0;
                count <= count + 1;
                if(count == 10'd64) begin
                    state <= 3'b011;
                    count <= 10'd0;
                end
            end
            3'b011 : begin // 010
                R <= 0;
                G <= 1;
                Y <= 0;
                count <= count + 1;
                if(pass == 1) begin
                    state <= 3'b110;
                    count <= 10'd0;
                end
                else begin
                    if(count == 10'd64) begin
                        state <= 3'b100;
                        count <= 10'd0;
                    end
                end
            end
            3'b100 : begin // 001
                R <= 0;
                G <= 0;
                Y <= 1;
                count <= count + 1;
                if(count == 10'd256) begin
                    state <= 3'b101;
                    count <= 10'd0;
                end
            end
            3'b101 : begin // 100
                R <= 1;
                G <= 0;
                Y <= 0;
                count <= count + 1;
                if(count == 10'd512) begin
                    state <= 3'b110;
                    count <= 10'd0;
                end
            end
        endcase
    end

end

endmodule
