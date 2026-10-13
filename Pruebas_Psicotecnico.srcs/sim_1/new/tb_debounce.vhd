library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_debounce is
end tb_debounce;

architecture Behavioral of tb_debounce is

    signal clk_tb     : std_logic := '0';
    signal btn_in_tb  : std_logic := '0';
    signal btn_out_tb : std_logic;

begin

    uut : entity work.debounce
        generic map(
            STABLE_COUNT => 5
        )
        port map(
            clk     => clk_tb,
            btn_in  => btn_in_tb,
            btn_out => btn_out_tb
        );

    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for 5 ns;
            clk_tb <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_process : process
    begin

        btn_in_tb <= '0';
        wait for 50 ns;

        btn_in_tb <= '1';
        wait for 10 ns;
        btn_in_tb <= '0';
        wait for 10 ns;
        btn_in_tb <= '1';
        wait for 10 ns;
        btn_in_tb <= '0';
        wait for 10 ns;
        btn_in_tb <= '1';

        wait for 150 ns;

        btn_in_tb <= '0';
        wait for 10 ns;
        btn_in_tb <= '1';
        wait for 10 ns;
        btn_in_tb <= '0';
        wait for 10 ns;
        btn_in_tb <= '1';
        wait for 10 ns;
        btn_in_tb <= '0';

        wait for 150 ns;

        btn_in_tb <= '1';
        wait for 100 ns;

        btn_in_tb <= '0';
        wait for 100 ns;

        wait;

    end process;

end Behavioral;