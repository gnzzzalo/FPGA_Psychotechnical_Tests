library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity logic_R is
    generic(
        WIDTH : integer := 16
    );
    port(
        count1 : in std_logic_vector(WIDTH-1 downto 0);
        count2 : in std_logic_vector(WIDTH-1 downto 0);

        done1 : in std_logic;
        done2 : in std_logic;

        pos_neg  : in std_logic;
        zero_out : in std_logic;

        show_result : in std_logic;

        in_range     : out std_logic;
        negative     : out std_logic;
        display_mode : out std_logic_vector(1 downto 0)
    );
end logic_R;

architecture Behavioral of logic_R is

    signal count1_int : integer range 0 to 65535 := 0;
    signal count2_int : integer range 0 to 65535 := 0;

    signal in_range_s : std_logic;
    signal negative_s : std_logic;

begin

    count1_int <= to_integer(unsigned(count1));
    count2_int <= to_integer(unsigned(count2));

    in_range_s <= '1' when done1 = '1' and done2 = '1' and
                           (10 * count2_int) >= (8 * count1_int) and
                           (10 * count2_int) <= (12 * count1_int)
                  else '0';

    negative_s <= '1' when done1 = '1' and done2 = '1' and
                           zero_out = '0' and pos_neg = '0'
                  else '0';

    display_mode <= "00" when show_result = '0' else
                    "01" when in_range_s = '1' else
                    "10";

    in_range <= in_range_s;
    negative <= negative_s;

end Behavioral;