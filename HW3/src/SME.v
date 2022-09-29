module SME(clk,reset,chardata,isstring,ispattern,valid,match,match_index);
input clk;
input reset;
input [7:0] chardata;
input isstring;
input ispattern;
output match;
output [4:0] match_index;
output valid;

reg match;
reg [4:0] match_index;
reg valid;

//String
reg [5:0] StringIndex;
reg [7:0] StringReg [0:31];
reg [5:0] StringCounter;
reg [5:0] StringCounterReg;

//Pattern
reg [4:0] PatternIndex;
reg [4:0] PatternIndexTemp;
reg [7:0] PatternReg [0:7];
reg [4:0] PatternCounter;

//MatchCounter
reg [4:0] MatchCounter;
reg [4:0] MatchCounterTemp;

//state
reg [2:0] CurrnetState;
reg [2:0] CurrnetStatePattern; 
reg [2:0] NextState;
reg [2:0] NextStatePattern;

//flag
reg ProcessDoneFlag;

//state flag
parameter Idle = 3'd0;
parameter ReceivingString = 3'd1;
parameter ReceivingPattern = 3'd2;
parameter Processing = 3'd3;
parameter Done = 3'd4;

//pattern flag
parameter PatternIdle = 3'd0;
parameter ReadyCheck = 3'd1;
parameter CheckMatch = 3'd2;
parameter PatternMatch = 3'd3;
parameter PatternUnMatch = 3'd4; 

always@(posedge clk or posedge reset) begin
    if(reset) begin
        //state switching
        CurrnetState <= Idle;
        CurrnetStatePattern <= PatternIdle;
        //processing flag & variable
        StringIndex <= 0;
        PatternIndex <= 0;
        PatternIndexTemp <= 0;
        MatchCounter <= 0;
        MatchCounterTemp <= 0;
        match_index <= 0;
        ProcessDoneFlag <= 0;
        //pattern match
        match <= 0;
        //data valid
        valid <= 0;
        //string
        StringReg[0] <= 0;
        StringReg[1] <= 0;
        StringReg[2] <= 0;
        StringReg[3] <= 0;
        StringReg[4] <= 0;
        StringReg[5] <= 0;
        StringReg[6] <= 0;
        StringReg[7] <= 0;
        StringReg[8] <= 0;
        StringReg[9] <= 0;
        StringReg[10] <= 0;
        StringReg[11] <= 0;
        StringReg[12] <= 0;
        StringReg[13] <= 0;
        StringReg[14] <= 0;
        StringReg[15] <= 0;
        StringReg[16] <= 0;
        StringReg[17] <= 0;
        StringReg[18] <= 0;
        StringReg[19] <= 0;
        StringReg[20] <= 0;
        StringReg[21] <= 0;
        StringReg[22] <= 0;
        StringReg[23] <= 0;
        StringReg[24] <= 0;
        StringReg[25] <= 0;
        StringReg[26] <= 0;
        StringReg[27] <= 0;
        StringReg[28] <= 0;
        StringReg[29] <= 0;
        StringReg[30] <= 0;
        StringReg[31] <= 0;
        StringCounterReg <= 0;
        //pattern
        PatternReg[0] <= 0;
        PatternReg[1] <= 0;
        PatternReg[2] <= 0;
        PatternReg[3] <= 0;
        PatternReg[4] <= 0;
        PatternReg[5] <= 0;
        PatternReg[6] <= 0;
        PatternReg[7] <= 0;
        PatternReg[8] <= 0;
        PatternCounter <= 0;
    end
    else begin
        //state switching
        CurrnetState <= NextState;
        CurrnetStatePattern <= NextStatePattern;
        //processing flag & variable
        if(CurrnetState == Done) begin
            StringIndex <= 0;
            PatternIndex <= 0;
            PatternIndexTemp <= 0;
            MatchCounter <= 0;
            MatchCounterTemp <= 0;
            match_index <= 0;
            ProcessDoneFlag <= 0;
        end
                        // 5e = ^
                        // 24 = $
                        // 2e = .
                        // 20 = space
        //processing    // 2A = *         
        else if(CurrnetState == Processing) begin
            if(CurrnetStatePattern == ReadyCheck) begin
                if(StringReg[StringIndex] == PatternReg[PatternIndex] || PatternReg[PatternIndex] == 8'h2e) begin
                    PatternIndex <= PatternIndex + 1;
                    StringIndex <= StringIndex + 1;
                    MatchCounter <= MatchCounter + 1; 
                    if(!PatternIndex) begin
                        match_index <= StringIndex;
                    end
                end
                else if(PatternReg[PatternIndex] == 8'h5e) begin
                    if(!StringIndex && (StringReg[StringIndex] == PatternReg[PatternIndex+1] || PatternReg[PatternIndex+1] == 8'h2e) ) begin
                        PatternIndex <= PatternIndex + 1;
                        StringIndex <= StringIndex + 1;
                        MatchCounter <= MatchCounter + 1; 
                        if(StringReg[StringIndex] == 8'h20) begin
                            match_index <= StringIndex + 1;
                        end
                        else begin
                            match_index <= StringIndex;
                        end
                    end
                    else if(StringReg[StringIndex] == 8'h20 && (StringReg[StringIndex+1] == PatternReg[PatternIndex+1] || PatternReg[PatternIndex+1] == 8'h2e) ) begin
                        PatternIndex <= PatternIndex + 1;
                        StringIndex <= StringIndex + 1;
                        MatchCounter <= MatchCounter + 1; 
                        if(StringReg[StringIndex] == 8'h20) begin
                            match_index <= StringIndex + 1;
                        end
                        else begin
                            match_index <= StringIndex;
                        end
                    end
                    else begin
                        PatternIndex <= PatternIndexTemp;
                        MatchCounter <= 0;
                        if(PatternIndex != 0) begin
                            StringIndex <= match_index + 1;
                        end
                        else begin
                            StringIndex <= StringIndex + 1;
                        end
                    end
                end
                else if(PatternReg[PatternIndex] == 8'h24 && (StringIndex == StringCounter || StringReg[StringIndex] == 8'h20)) begin
                    PatternIndex <= PatternIndex + 1;
                    StringIndex <= StringIndex + 1;
                    MatchCounter <= MatchCounter + 1; 
                    if(!PatternIndex) begin
                        match_index <= StringIndex;
                    end
                end
                else if(StringReg[StringIndex] != PatternReg[PatternIndex] && PatternReg[PatternIndex] != 8'h2e) begin
                    PatternIndex <= PatternIndexTemp;
                    MatchCounter <= 0;
                    if(PatternIndex != 0) begin
                        StringIndex <= match_index + 1;
                    end
                    else begin
                        StringIndex <= StringIndex + 1;
                    end
                end
            end
            else if(CurrnetStatePattern == PatternMatch || CurrnetStatePattern == PatternUnMatch) begin 
                ProcessDoneFlag <= 1;
            end 
        end
        else begin
            ProcessDoneFlag <= 0;
        end
        //data valid
        if(NextState == Done) begin
            valid <= 1;
            PatternCounter <= 0;
        end
        else begin
            valid <= 0;
        end
        //pattern match
        if(NextStatePattern == PatternMatch) begin
            match <= 1;
        end
        else if(NextStatePattern == PatternUnMatch) begin
            match <= 0;
        end
        //reg & counter
        if(CurrnetState == Done && NextState == ReceivingString) begin
            StringReg[0] <= chardata;
        end
        if(isstring) begin
            StringReg[StringCounter] <= chardata;
            StringCounterReg <= StringCounter;
        end
        if(ispattern) begin
            PatternReg[PatternCounter] <= chardata;
            PatternCounter <= PatternCounter + 1;
        end
    end
end

//state case
always@(*) begin
    case(CurrnetState)
    Idle : begin
        if(isstring) begin
            NextState = ReceivingString;
        end 
        else if(ispattern) begin
            NextState = ReceivingPattern;
        end 
        else begin
            NextState = Idle;
        end
    end
    ReceivingString : begin
        if(isstring) begin
            NextState = ReceivingString;
        end
        else begin
            NextState = ReceivingPattern;
        end
    end
    ReceivingPattern : begin
        if(ispattern) begin
            NextState = ReceivingPattern;
        end
        else begin
            NextState = Processing;
        end
    end
    Processing : begin
        if(ProcessDoneFlag) begin
            NextState = Done;
        end
        else begin
            NextState = Processing;
        end
    end
    Done : begin
        if(isstring) begin
            NextState = ReceivingString;
        end
        else if(ispattern) begin
            NextState = ReceivingPattern;
        end
        else begin
            NextState = Idle;
        end
    end
    default : begin
        NextState = Idle;
    end
    endcase 

    //processing
    if(CurrnetState == Processing) begin
        case(CurrnetStatePattern)
        PatternIdle: begin
            NextStatePattern = ReadyCheck;
        end 
        ReadyCheck : begin
            if(MatchCounter == PatternCounter) begin
                NextStatePattern = PatternMatch;
            end
            else if(StringCounter == StringIndex || PatternCounter == PatternIndex) begin
                NextStatePattern = CheckMatch;
            end
            else begin
                NextStatePattern = ReadyCheck;
            end
        end 
        CheckMatch : begin
            if(PatternReg[PatternCounter-1] == 8'h24) begin
                if(MatchCounter+1 == PatternCounter) begin
                    NextStatePattern = PatternMatch;
                end
                else begin
                    NextStatePattern = PatternUnMatch;
                end
            end
            else begin
                if(MatchCounter == PatternCounter) begin
                    NextStatePattern = PatternMatch;
                end
                else begin
                    NextStatePattern = PatternUnMatch;
                end
            end
        end
        PatternMatch : begin
            NextStatePattern = PatternIdle;
        end
        PatternUnMatch : begin
            NextStatePattern = PatternIdle;
        end
        default : begin
            NextStatePattern = PatternIdle;
        end
        endcase 
    end
    else begin
        NextStatePattern = PatternIdle;
    end
    //done
    if(CurrnetState == Done && NextState == ReceivingString) begin
        StringCounter = 0;
    end
    //idle
    else if(CurrnetState  == Idle && NextState == ReceivingString) begin
        StringCounter = 0;
    end
    //string counter
    else if(isstring) begin
        StringCounter = StringCounterReg + 1;
    end
    else begin
        StringCounter = StringCounterReg;
    end
end

endmodule