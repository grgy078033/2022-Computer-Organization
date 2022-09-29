library verilog;
use verilog.vl_types.all;
entity SME is
    generic(
        Idle            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        ReceivingString : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        ReceivingPattern: vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        Processing      : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        Done            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        PatternIdle     : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        ReadyCheck      : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        CheckMatch      : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        PatternMatch    : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        PatternUnMatch  : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        chardata        : in     vl_logic_vector(7 downto 0);
        isstring        : in     vl_logic;
        ispattern       : in     vl_logic;
        valid           : out    vl_logic;
        match           : out    vl_logic;
        match_index     : out    vl_logic_vector(4 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Idle : constant is 1;
    attribute mti_svvh_generic_type of ReceivingString : constant is 1;
    attribute mti_svvh_generic_type of ReceivingPattern : constant is 1;
    attribute mti_svvh_generic_type of Processing : constant is 1;
    attribute mti_svvh_generic_type of Done : constant is 1;
    attribute mti_svvh_generic_type of PatternIdle : constant is 1;
    attribute mti_svvh_generic_type of ReadyCheck : constant is 1;
    attribute mti_svvh_generic_type of CheckMatch : constant is 1;
    attribute mti_svvh_generic_type of PatternMatch : constant is 1;
    attribute mti_svvh_generic_type of PatternUnMatch : constant is 1;
end SME;
