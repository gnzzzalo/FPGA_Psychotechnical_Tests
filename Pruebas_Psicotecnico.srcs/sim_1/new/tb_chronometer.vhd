library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_chronometer is
end tb_chronometer;

architecture Behavioral of tb_chronometer is

    constant CLK_FREQ_HZ : integer := 100;
    constant OUT_WIDTH   : integer := 16;

    signal clk_tb       : std_logic := '0';
    signal ini_tb       : std_logic := '0';
    signal fin_tb       : std_logic := '0';
    signal count_out_tb : std_logic_vector(OUT_WIDTH-1 downto 0);
    signal limit_out_tb : std_logic;
    signal done_out_tb  : std_logic;

begin

    uut : entity work.chronometer
        generic map(
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            OUT_WIDTH   => OUT_WIDTH
        )
        port map(
            clk       => clk_tb,
            ini       => ini_tb,
            fin       => fin_tb,
            count_out => count_out_tb,
            limit_out => limit_out_tb,
            done_out  => done_out_tb
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

        ini_tb <= '0';
        fin_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(count_out_tb) = 0
            report "Error: inicialmente count_out deberia valer 0"
            severity error;

        assert limit_out_tb = '0'
            report "Error: inicialmente limit_out deberia valer 0"
            severity error;

        assert done_out_tb = '0'
            report "Error: inicialmente done_out deberia valer 0"
            severity error;

        ini_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(count_out_tb) = 0
            report "Error: con ini, count_out deberia reiniciarse a 0"
            severity error;

        assert limit_out_tb = '0'
            report "Error: con ini, limit_out deberia valer 0"
            severity error;

        assert done_out_tb = '0'
            report "Error: con ini, done_out deberia valer 0"
            severity error;

        ini_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(count_out_tb) = 1
            report "Error: despues de iniciar, count_out deberia valer 1"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(count_out_tb) = 2
            report "Error: count_out deberia valer 2"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(count_out_tb) = 3
            report "Error: count_out deberia valer 3"
            severity error;

        fin_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(count_out_tb) = 3
            report "Error: con fin, count_out deberia quedarse con el valor medido"
            severity error;

        assert done_out_tb = '1'
            report "Error: con fin, done_out deberia valer 1"
            severity error;

        assert limit_out_tb = '0'
            report "Error: parando con fin, limit_out deberia seguir valiendo 0"
            severity error;

        fin_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(count_out_tb) = 3
            report "Error: despues de fin, el cronometro no deberia seguir contando"
            severity error;

        assert done_out_tb = '1'
            report "Error: despues de fin, done_out deberia mantenerse a 1"
            severity error;

        ini_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(count_out_tb) = 0
            report "Error: ini deberia reiniciar count_out despues de haber terminado"
            severity error;

        assert done_out_tb = '0'
            report "Error: ini deberia poner done_out a 0"
            severity error;

        assert limit_out_tb = '0'
            report "Error: ini deberia poner limit_out a 0"
            severity error;

        ini_tb <= '0';

        for i in 1 to 10 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert unsigned(count_out_tb) = 10
            report "Error: despues de 10 ciclos contando, count_out deberia valer 10"
            severity error;

        ini_tb <= '1';
        fin_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(count_out_tb) = 0
            report "Error: si ini y fin valen 1 a la vez, deberia ganar ini y reiniciar count_out"
            severity error;

        assert done_out_tb = '0'
            report "Error: si ini y fin valen 1 a la vez, deberia ganar ini y done_out deberia valer 0"
            severity error;

        ini_tb <= '0';
        fin_tb <= '0';

        for i in 1 to 30005 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            exit when done_out_tb = '1';
        end loop;

        assert unsigned(count_out_tb) = 30000
            report "Error: al llegar al limite, count_out deberia valer 30000"
            severity error;

        assert limit_out_tb = '1'
            report "Error: al llegar al limite, limit_out deberia valer 1"
            severity error;

        assert done_out_tb = '1'
            report "Error: al llegar al limite, done_out deberia valer 1"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(count_out_tb) = 30000
            report "Error: despues del limite, count_out no deberia seguir aumentando"
            severity error;

        report "Testbench de chronometer finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;