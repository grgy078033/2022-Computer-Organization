library verilog;
use verilog.vl_types.all;
entity Comparison is
    port(
        invalid1        : in     vl_logic;
        invalid2        : in     vl_logic;
        value1          : in     vl_logic_vector(7 downto 0);
        value2          : in     vl_logic_vector(7 downto 0);
        o_invalid       : out    vl_logic;
        o_value         : out    vl_logic_vector(7 downto 0)
    );
end Comparison;
