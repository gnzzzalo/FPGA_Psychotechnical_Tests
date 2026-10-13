library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    generic(
        STABLE_COUNT : integer := 1_000_000
    );
    port(
        clk     : in  std_logic;
        btn_in  : in  std_logic;
        btn_out : out std_logic
    );
end debounce;

architecture Behavioral of debounce is

    signal sync_0     : std_logic := '0';
    signal sync_1     : std_logic := '0';
    signal stable_btn : std_logic := '0';
    signal count      : integer range 0 to STABLE_COUNT := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then

            sync_0 <= btn_in;
            sync_1 <= sync_0;

            if sync_1 /= stable_btn then
                if count = STABLE_COUNT then
                    stable_btn <= sync_1;
                    count <= 0;
                else
                    count <= count + 1;
                end if;
            else
                count <= 0;
            end if;

        end if;
    end process;

    btn_out <= stable_btn;

end Behavioral;