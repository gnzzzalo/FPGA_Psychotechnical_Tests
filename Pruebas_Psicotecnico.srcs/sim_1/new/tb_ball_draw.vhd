library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ball_draw is
end tb_ball_draw;

architecture Behavioral of tb_ball_draw is

    constant SCREEN_H : integer := 480;
    constant BALL_R   : integer := 14;

    signal h_count_tb : integer range 0 to 799 := 0;
    signal v_count_tb : integer range 0 to 524 := 0;
    signal ball_x_tb  : integer range 0 to 799 := 100;

    signal in_ball_tb : std_logic;

begin

    uut : entity work.ball_draw
        generic map(
            SCREEN_H => SCREEN_H,
            BALL_R   => BALL_R
        )
        port map(
            h_count => h_count_tb,
            v_count => v_count_tb,
            ball_x  => ball_x_tb,
            in_ball => in_ball_tb
        );

    stim_process : process
    begin

        ball_x_tb <= 100;

        h_count_tb <= 100;
        v_count_tb <= 240;

        wait for 10 ns;

        assert in_ball_tb = '1'
            report "Error: el centro de la bola deberia estar dentro"
            severity error;

        h_count_tb <= 110;
        v_count_tb <= 245;

        wait for 10 ns;

        assert in_ball_tb = '1'
            report "Error: pixel cercano al centro deberia estar dentro de la bola"
            severity error;

        h_count_tb <= 86;
        v_count_tb <= 240;

        wait for 10 ns;

        assert in_ball_tb = '1'
            report "Error: borde izquierdo de la bola deberia estar dentro"
            severity error;

        h_count_tb <= 114;
        v_count_tb <= 240;

        wait for 10 ns;

        assert in_ball_tb = '1'
            report "Error: borde derecho de la bola deberia estar dentro"
            severity error;

        h_count_tb <= 100;
        v_count_tb <= 226;

        wait for 10 ns;

        assert in_ball_tb = '1'
            report "Error: borde superior de la bola deberia estar dentro"
            severity error;

        h_count_tb <= 100;
        v_count_tb <= 254;

        wait for 10 ns;

        assert in_ball_tb = '1'
            report "Error: borde inferior de la bola deberia estar dentro"
            severity error;

        h_count_tb <= 114;
        v_count_tb <= 254;

        wait for 10 ns;

        assert in_ball_tb = '0'
            report "Error: esquina inferior derecha deberia estar fuera por recorte"
            severity error;

        h_count_tb <= 86;
        v_count_tb <= 226;

        wait for 10 ns;

        assert in_ball_tb = '0'
            report "Error: esquina superior izquierda deberia estar fuera por recorte"
            severity error;

        h_count_tb <= 115;
        v_count_tb <= 240;

        wait for 10 ns;

        assert in_ball_tb = '0'
            report "Error: pixel fuera por la derecha deberia estar fuera"
            severity error;

        h_count_tb <= 100;
        v_count_tb <= 255;

        wait for 10 ns;

        assert in_ball_tb = '0'
            report "Error: pixel fuera por abajo deberia estar fuera"
            severity error;

        h_count_tb <= 121;
        v_count_tb <= 240;

        wait for 10 ns;

        assert in_ball_tb = '0'
            report "Error: pixel demasiado lejos horizontalmente deberia estar fuera"
            severity error;

        h_count_tb <= 100;
        v_count_tb <= 220;

        wait for 10 ns;

        assert in_ball_tb = '0'
            report "Error: pixel demasiado lejos verticalmente deberia estar fuera"
            severity error;

        ball_x_tb <= 200;

        h_count_tb <= 200;
        v_count_tb <= 240;

        wait for 10 ns;

        assert in_ball_tb = '1'
            report "Error: al mover ball_x, el nuevo centro deberia estar dentro"
            severity error;

        h_count_tb <= 100;
        v_count_tb <= 240;

        wait for 10 ns;

        assert in_ball_tb = '0'
            report "Error: el antiguo centro deberia quedar fuera despues de mover ball_x"
            severity error;

        report "Testbench de ball_draw finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;