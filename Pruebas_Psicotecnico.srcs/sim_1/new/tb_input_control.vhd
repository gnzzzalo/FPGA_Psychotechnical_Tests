library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_input_control is
end tb_input_control;

architecture Behavioral of tb_input_control is

    constant DEBOUNCE_STABLE_COUNT : integer := 2;

    signal clk_tb : std_logic := '0';

    signal btnC_tb : std_logic := '0';
    signal btnU_tb : std_logic := '0';
    signal swt_tb  : std_logic_vector(0 downto 0) := "0";

    signal reset_all_tb : std_logic;
    signal btnC_edge_tb : std_logic;
    signal btnU_edge_tb : std_logic;

begin

    uut : entity work.input_control
        generic map(
            DEBOUNCE_STABLE_COUNT => DEBOUNCE_STABLE_COUNT
        )
        port map(
            clk       => clk_tb,
            btnC      => btnC_tb,
            btnU      => btnU_tb,
            swt       => swt_tb,
            reset_all => reset_all_tb,
            btnC_edge => btnC_edge_tb,
            btnU_edge => btnU_edge_tb
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
        variable count_btnC_edges : integer := 0;
        variable count_btnU_edges : integer := 0;
    begin

        btnC_tb <= '0';
        btnU_tb <= '0';
        swt_tb  <= "0";

        for i in 1 to 10 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert reset_all_tb = '0'
            report "Error: inicialmente reset_all deberia valer 0"
            severity error;

        assert btnC_edge_tb = '0'
            report "Error: inicialmente btnC_edge deberia valer 0"
            severity error;

        assert btnU_edge_tb = '0'
            report "Error: inicialmente btnU_edge deberia valer 0"
            severity error;

        btnC_tb <= '1';
        count_btnC_edges := 0;

        for i in 1 to 20 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if btnC_edge_tb = '1' then
                count_btnC_edges := count_btnC_edges + 1;
            end if;
        end loop;

        assert count_btnC_edges = 1
            report "Error: al pulsar btnC deberia aparecer exactamente un pulso btnC_edge"
            severity error;

        assert btnC_edge_tb = '0'
            report "Error: btnC_edge no deberia quedarse a 1"
            severity error;

        count_btnC_edges := 0;

        for i in 1 to 10 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if btnC_edge_tb = '1' then
                count_btnC_edges := count_btnC_edges + 1;
            end if;
        end loop;

        assert count_btnC_edges = 0
            report "Error: manteniendo btnC pulsado no deberian salir mas pulsos"
            severity error;

        btnC_tb <= '0';
        count_btnC_edges := 0;

        for i in 1 to 20 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if btnC_edge_tb = '1' then
                count_btnC_edges := count_btnC_edges + 1;
            end if;
        end loop;

        assert count_btnC_edges = 0
            report "Error: al soltar btnC no deberia aparecer pulso de subida"
            severity error;

        btnU_tb <= '1';
        count_btnU_edges := 0;

        for i in 1 to 20 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if btnU_edge_tb = '1' then
                count_btnU_edges := count_btnU_edges + 1;
            end if;
        end loop;

        assert count_btnU_edges = 1
            report "Error: al pulsar btnU deberia aparecer exactamente un pulso btnU_edge"
            severity error;

        assert btnU_edge_tb = '0'
            report "Error: btnU_edge no deberia quedarse a 1"
            severity error;

        btnU_tb <= '0';
        count_btnU_edges := 0;

        for i in 1 to 20 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if btnU_edge_tb = '1' then
                count_btnU_edges := count_btnU_edges + 1;
            end if;
        end loop;

        assert count_btnU_edges = 0
            report "Error: al soltar btnU no deberia aparecer pulso de subida"
            severity error;

        swt_tb(0) <= '1';

        for i in 1 to 20 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert reset_all_tb = '1'
            report "Error: con swt(0) = 1, reset_all deberia valer 1"
            severity error;

        swt_tb(0) <= '0';

        for i in 1 to 20 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert reset_all_tb = '0'
            report "Error: con swt(0) = 0, reset_all deberia volver a 0"
            severity error;

        btnC_tb <= '1';
        btnU_tb <= '1';

        count_btnC_edges := 0;
        count_btnU_edges := 0;

        for i in 1 to 20 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if btnC_edge_tb = '1' then
                count_btnC_edges := count_btnC_edges + 1;
            end if;

            if btnU_edge_tb = '1' then
                count_btnU_edges := count_btnU_edges + 1;
            end if;
        end loop;

        assert count_btnC_edges = 1
            report "Error: btnC deberia generar un pulso al pulsarlo de nuevo"
            severity error;

        assert count_btnU_edges = 1
            report "Error: btnU deberia generar un pulso al pulsarlo de nuevo"
            severity error;

        report "Testbench de input_control finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;