library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_track_draw is
end tb_track_draw;

architecture Behavioral of tb_track_draw is

    constant SCREEN_H : integer := 480;
    constant TRACK_X0 : integer := 0;
    constant TRACK_X1 : integer := 520;
    constant TRACK_H  : integer := 130;

    signal h_count_tb  : integer range 0 to 799 := 0;
    signal v_count_tb  : integer range 0 to 524 := 0;
    signal in_track_tb : std_logic;

begin

    uut : entity work.track_draw
        generic map(
            SCREEN_H => SCREEN_H,
            TRACK_X0 => TRACK_X0,
            TRACK_X1 => TRACK_X1,
            TRACK_H  => TRACK_H
        )
        port map(
            h_count  => h_count_tb,
            v_count  => v_count_tb,
            in_track => in_track_tb
        );

    stim_process : process
    begin

        h_count_tb <= 100;
        v_count_tb <= 240;

        wait for 10 ns;

        assert in_track_tb = '1'
            report "Error: el pixel deberia estar dentro del carril"
            severity error;

        h_count_tb <= 0;
        v_count_tb <= 175;

        wait for 10 ns;

        assert in_track_tb = '1'
            report "Error: borde superior izquierdo deberia estar dentro del carril"
            severity error;

        h_count_tb <= 519;
        v_count_tb <= 304;

        wait for 10 ns;

        assert in_track_tb = '1'
            report "Error: borde inferior derecho valido deberia estar dentro del carril"
            severity error;

        h_count_tb <= 520;
        v_count_tb <= 240;

        wait for 10 ns;

        assert in_track_tb = '0'
            report "Error: h_count = TRACK_X1 deberia estar fuera del carril"
            severity error;

        h_count_tb <= 100;
        v_count_tb <= 174;

        wait for 10 ns;

        assert in_track_tb = '0'
            report "Error: pixel por encima del carril deberia estar fuera"
            severity error;

        h_count_tb <= 100;
        v_count_tb <= 305;

        wait for 10 ns;

        assert in_track_tb = '0'
            report "Error: v_count = TRACK_Y1 deberia estar fuera del carril"
            severity error;

        h_count_tb <= 600;
        v_count_tb <= 240;

        wait for 10 ns;

        assert in_track_tb = '0'
            report "Error: pixel a la derecha del carril deberia estar fuera"
            severity error;

        h_count_tb <= 100;
        v_count_tb <= 100;

        wait for 10 ns;

        assert in_track_tb = '0'
            report "Error: pixel fuera verticalmente deberia estar fuera del carril"
            severity error;

        report "Testbench de track_draw finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;