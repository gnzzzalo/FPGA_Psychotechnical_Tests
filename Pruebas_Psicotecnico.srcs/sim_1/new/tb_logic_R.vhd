library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_logic_R is
end tb_logic_R;

architecture Behavioral of tb_logic_R is

    constant WIDTH : integer := 16;

    signal count1_tb : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal count2_tb : std_logic_vector(WIDTH-1 downto 0) := (others => '0');

    signal done1_tb : std_logic := '0';
    signal done2_tb : std_logic := '0';

    signal pos_neg_tb  : std_logic := '0';
    signal zero_out_tb : std_logic := '0';

    signal show_result_tb : std_logic := '0';

    signal in_range_tb     : std_logic;
    signal negative_tb     : std_logic;
    signal display_mode_tb : std_logic_vector(1 downto 0);

begin

    uut : entity work.logic_R
        generic map(
            WIDTH => WIDTH
        )
        port map(
            count1       => count1_tb,
            count2       => count2_tb,
            done1        => done1_tb,
            done2        => done2_tb,
            pos_neg      => pos_neg_tb,
            zero_out     => zero_out_tb,
            show_result  => show_result_tb,
            in_range     => in_range_tb,
            negative     => negative_tb,
            display_mode => display_mode_tb
        );

    stim_process : process
    begin

        count1_tb <= std_logic_vector(to_unsigned(250, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(250, WIDTH));
        done1_tb <= '0';
        done2_tb <= '0';
        pos_neg_tb <= '0';
        zero_out_tb <= '0';
        show_result_tb <= '0';

        wait for 10 ns;

        assert in_range_tb = '0'
            report "Error: si done1 y done2 no valen 1, in_range deberia valer 0"
            severity error;

        assert negative_tb = '0'
            report "Error: si done1 y done2 no valen 1, negative deberia valer 0"
            severity error;

        assert display_mode_tb = "00"
            report "Error: si show_result = 0, display_mode deberia ser 00"
            severity error;

        done1_tb <= '1';
        done2_tb <= '0';
        show_result_tb <= '1';

        wait for 10 ns;

        assert in_range_tb = '0'
            report "Error: si solo done1 vale 1, in_range deberia valer 0"
            severity error;

        assert display_mode_tb = "10"
            report "Error: si show_result = 1 pero no esta en rango, display_mode deberia ser 10"
            severity error;

        done1_tb <= '0';
        done2_tb <= '1';

        wait for 10 ns;

        assert in_range_tb = '0'
            report "Error: si solo done2 vale 1, in_range deberia valer 0"
            severity error;

        assert display_mode_tb = "10"
            report "Error: si show_result = 1 pero no esta en rango, display_mode deberia ser 10"
            severity error;

        count1_tb <= std_logic_vector(to_unsigned(250, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(250, WIDTH));
        done1_tb <= '1';
        done2_tb <= '1';
        pos_neg_tb <= '0';
        zero_out_tb <= '1';
        show_result_tb <= '1';

        wait for 10 ns;

        assert in_range_tb = '1'
            report "Error: count1=250 y count2=250 deberia estar en rango"
            severity error;

        assert negative_tb = '0'
            report "Error: si zero_out = 1, negative deberia valer 0"
            severity error;

        assert display_mode_tb = "01"
            report "Error: si esta en rango y show_result = 1, display_mode deberia ser 01"
            severity error;

        count1_tb <= std_logic_vector(to_unsigned(250, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(200, WIDTH));
        done1_tb <= '1';
        done2_tb <= '1';
        pos_neg_tb <= '1';
        zero_out_tb <= '0';
        show_result_tb <= '1';

        wait for 10 ns;

        assert in_range_tb = '1'
            report "Error: count2=200 es el 80 por ciento de count1=250, deberia estar en rango"
            severity error;

        assert negative_tb = '0'
            report "Error: con pos_neg = 1, negative deberia valer 0"
            severity error;

        assert display_mode_tb = "01"
            report "Error: en el limite inferior valido, display_mode deberia ser 01"
            severity error;

        count1_tb <= std_logic_vector(to_unsigned(250, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(300, WIDTH));
        done1_tb <= '1';
        done2_tb <= '1';
        pos_neg_tb <= '0';
        zero_out_tb <= '0';
        show_result_tb <= '1';

        wait for 10 ns;

        assert in_range_tb = '1'
            report "Error: count2=300 es el 120 por ciento de count1=250, deberia estar en rango"
            severity error;

        assert negative_tb = '1'
            report "Error: con pos_neg = 0 y zero_out = 0, negative deberia valer 1"
            severity error;

        assert display_mode_tb = "01"
            report "Error: en el limite superior valido, display_mode deberia ser 01"
            severity error;

        count1_tb <= std_logic_vector(to_unsigned(250, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(199, WIDTH));
        done1_tb <= '1';
        done2_tb <= '1';
        pos_neg_tb <= '1';
        zero_out_tb <= '0';
        show_result_tb <= '1';

        wait for 10 ns;

        assert in_range_tb = '0'
            report "Error: count2=199 esta por debajo del 80 por ciento, in_range deberia valer 0"
            severity error;

        assert display_mode_tb = "10"
            report "Error: fuera de rango y show_result = 1, display_mode deberia ser 10"
            severity error;

        count1_tb <= std_logic_vector(to_unsigned(250, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(301, WIDTH));
        done1_tb <= '1';
        done2_tb <= '1';
        pos_neg_tb <= '0';
        zero_out_tb <= '0';
        show_result_tb <= '1';

        wait for 10 ns;

        assert in_range_tb = '0'
            report "Error: count2=301 esta por encima del 120 por ciento, in_range deberia valer 0"
            severity error;

        assert negative_tb = '1'
            report "Error: aunque este fuera de rango, con pos_neg = 0 y zero_out = 0, negative deberia valer 1"
            severity error;

        assert display_mode_tb = "10"
            report "Error: fuera de rango y show_result = 1, display_mode deberia ser 10"
            severity error;

        show_result_tb <= '0';

        wait for 10 ns;

        assert display_mode_tb = "00"
            report "Error: si show_result = 0, display_mode deberia ser 00 aunque este fuera de rango"
            severity error;

        count1_tb <= std_logic_vector(to_unsigned(500, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(450, WIDTH));
        done1_tb <= '1';
        done2_tb <= '1';
        pos_neg_tb <= '1';
        zero_out_tb <= '0';
        show_result_tb <= '1';

        wait for 10 ns;

        assert in_range_tb = '1'
            report "Error: count2=450 deberia estar dentro del rango de count1=500"
            severity error;

        assert negative_tb = '0'
            report "Error: con pos_neg = 1, negative deberia valer 0"
            severity error;

        assert display_mode_tb = "01"
            report "Error: si esta en rango y show_result = 1, display_mode deberia ser 01"
            severity error;

        report "Testbench de logic_R finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;