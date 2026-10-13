library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_display_7seg_R is
end tb_display_7seg_R;

architecture Behavioral of tb_display_7seg_R is

    constant CLK_FREQ_HZ : integer := 4000;
    constant WIDTH       : integer := 16;

    signal clk_tb          : std_logic := '0';
    signal value_cs_tb     : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal display_mode_tb : std_logic_vector(1 downto 0) := "00";
    signal negative_tb     : std_logic := '0';

    signal seg_tb : std_logic_vector(6 downto 0);
    signal an_tb  : std_logic_vector(3 downto 0);
    signal dp_tb  : std_logic;

begin

    uut : entity work.display_7seg_R
        generic map(
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            WIDTH       => WIDTH
        )
        port map(
            clk          => clk_tb,
            value_cs     => value_cs_tb,
            display_mode => display_mode_tb,
            negative     => negative_tb,
            seg          => seg_tb,
            an           => an_tb,
            dp           => dp_tb
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

        value_cs_tb <= std_logic_vector(to_unsigned(123, WIDTH));
        display_mode_tb <= "00";
        negative_tb <= '0';

        wait for 1 ns;

        assert an_tb = "1111"
            report "Error: con display_mode = 00, todos los anodos deberian estar apagados"
            severity error;

        assert seg_tb = "1111111"
            report "Error: con display_mode = 00, los segmentos deberian estar apagados"
            severity error;

        assert dp_tb = '1'
            report "Error: con display_mode = 00, el punto decimal deberia estar apagado"
            severity error;

        display_mode_tb <= "01";
        negative_tb <= '1';
        value_cs_tb <= std_logic_vector(to_unsigned(123, WIDTH));

        wait for 1 ns;

        assert an_tb = "1110"
            report "Error: digit_sel 00 deberia activar el digito derecho"
            severity error;

        assert seg_tb = "0110000"
            report "Error: para 1.23, el digito derecho deberia mostrar 3"
            severity error;

        assert dp_tb = '1'
            report "Error: en las centesimas, dp deberia estar apagado"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert an_tb = "1101"
            report "Error: digit_sel 01 deberia activar el segundo digito"
            severity error;

        assert seg_tb = "0100100"
            report "Error: para 1.23, el segundo digito deberia mostrar 2"
            severity error;

        assert dp_tb = '1'
            report "Error: en las decimas, dp deberia estar apagado"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert an_tb = "1011"
            report "Error: digit_sel 10 deberia activar el tercer digito"
            severity error;

        assert seg_tb = "1111001"
            report "Error: para 1.23, el tercer digito deberia mostrar 1"
            severity error;

        assert dp_tb = '0'
            report "Error: en el digito de segundos, dp deberia estar encendido"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert an_tb = "0111"
            report "Error: digit_sel 11 deberia activar el digito izquierdo"
            severity error;

        assert seg_tb = "0111111"
            report "Error: con negative = 1, el digito izquierdo deberia mostrar signo menos"
            severity error;

        assert dp_tb = '1'
            report "Error: en el signo menos, dp deberia estar apagado"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        display_mode_tb <= "10";
        negative_tb <= '0';

        wait for 1 ns;

        assert an_tb = "1110"
            report "Error: en FAIL, digit_sel 00 deberia activar el digito derecho"
            severity error;

        assert seg_tb = "1000111"
            report "Error: en FAIL, el digito derecho deberia mostrar L"
            severity error;

        assert dp_tb = '1'
            report "Error: en FAIL, dp deberia estar apagado"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert an_tb = "1101"
            report "Error: en FAIL, digit_sel 01 deberia activar el segundo digito"
            severity error;

        assert seg_tb = "1111001"
            report "Error: en FAIL, el segundo digito deberia mostrar I"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert an_tb = "1011"
            report "Error: en FAIL, digit_sel 10 deberia activar el tercer digito"
            severity error;

        assert seg_tb = "0001000"
            report "Error: en FAIL, el tercer digito deberia mostrar A"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert an_tb = "0111"
            report "Error: en FAIL, digit_sel 11 deberia activar el digito izquierdo"
            severity error;

        assert seg_tb = "0001110"
            report "Error: en FAIL, el digito izquierdo deberia mostrar F"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        display_mode_tb <= "01";
        negative_tb <= '0';
        value_cs_tb <= std_logic_vector(to_unsigned(45, WIDTH));

        wait for 1 ns;

        assert an_tb = "1110"
            report "Error: para 0.45, digit_sel 00 deberia activar el digito derecho"
            severity error;

        assert seg_tb = "0010010"
            report "Error: para 0.45, el digito derecho deberia mostrar 5"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert an_tb = "1101"
            report "Error: para 0.45, digit_sel 01 deberia activar el segundo digito"
            severity error;

        assert seg_tb = "0011001"
            report "Error: para 0.45, el segundo digito deberia mostrar 4"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert an_tb = "1011"
            report "Error: para 0.45, digit_sel 10 deberia activar el tercer digito"
            severity error;

        assert seg_tb = "1000000"
            report "Error: para 0.45, el tercer digito deberia mostrar 0"
            severity error;

        assert dp_tb = '0'
            report "Error: para 0.45, el punto decimal deberia estar encendido en el digito de segundos"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert an_tb = "0111"
            report "Error: para 0.45, digit_sel 11 deberia activar el digito izquierdo"
            severity error;

        assert seg_tb = "1111111"
            report "Error: con negative = 0, el digito izquierdo deberia estar apagado"
            severity error;

        display_mode_tb <= "00";

        wait for 1 ns;

        assert an_tb = "1111"
            report "Error: al volver a display_mode = 00, todos los anodos deberian apagarse"
            severity error;

        assert seg_tb = "1111111"
            report "Error: al volver a display_mode = 00, los segmentos deberian apagarse"
            severity error;

        report "Testbench de display_7seg_R finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;