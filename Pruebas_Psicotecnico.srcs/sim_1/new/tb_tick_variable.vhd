library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_tick_variable is
end tb_tick_variable;

architecture Behavioral of tb_tick_variable is

    constant MIN_COUNT : integer := 4;
    constant MAX_COUNT : integer := 35;

    signal clk_tb       : std_logic := '0';
    signal reset_tb     : std_logic := '0';
    signal randomize_tb : std_logic := '0';
    signal tick_tb      : std_logic;

begin

    uut : entity work.tick_variable
        generic map(
            MIN_COUNT => MIN_COUNT,
            MAX_COUNT => MAX_COUNT
        )
        port map(
            clk       => clk_tb,
            reset     => reset_tb,
            randomize => randomize_tb,
            tick      => tick_tb
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
        variable tick_count : integer := 0;
    begin

        reset_tb <= '1';
        randomize_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert tick_tb = '0'
            report "Error: durante reset, tick deberia valer 0"
            severity error;

        reset_tb <= '0';

        tick_count := 0;

        for i in 1 to 40 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if tick_tb = '1' then
                tick_count := tick_count + 1;
            end if;
        end loop;

        assert tick_count = 1
            report "Error: con count_max inicial = MAX_COUNT, deberia aparecer 1 tick en 40 ciclos"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert tick_tb = '0'
            report "Error: tick deberia durar solo un ciclo"
            severity error;

        randomize_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert tick_tb = '0'
            report "Error: durante randomize no deberia generarse tick"
            severity error;

        randomize_tb <= '0';

        tick_count := 0;

        for i in 1 to 40 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if tick_tb = '1' then
                tick_count := tick_count + 1;
            end if;
        end loop;

        assert tick_count >= 1
            report "Error: despues de randomize deberia aparecer al menos un tick"
            severity error;

        randomize_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        randomize_tb <= '0';

        tick_count := 0;

        for i in 1 to 10 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if tick_tb = '1' then
                tick_count := tick_count + 1;
            end if;
        end loop;

        assert tick_count <= 2
            report "Error: tick no deberia quedarse constantemente a 1"
            severity error;

        reset_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert tick_tb = '0'
            report "Error: al activar reset, tick deberia volver a 0"
            severity error;

        reset_tb <= '0';

        tick_count := 0;

        for i in 1 to 40 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if tick_tb = '1' then
                tick_count := tick_count + 1;
            end if;
        end loop;

        assert tick_count = 1
            report "Error: despues de reset, count_max deberia volver a MAX_COUNT"
            severity error;

        report "Testbench de tick_variable finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;