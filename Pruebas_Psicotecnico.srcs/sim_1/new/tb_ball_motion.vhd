library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ball_motion is
end tb_ball_motion;

architecture Behavioral of tb_ball_motion is

    constant SCREEN_W : integer := 40;
    constant TRACK_X0 : integer := 0;
    constant TRACK_X1 : integer := 30;
    constant BALL_R   : integer := 2;

    constant BALL_START_X : integer := TRACK_X0 + BALL_R;
    constant BALL_END_X   : integer := SCREEN_W - BALL_R;

    signal clk_tb       : std_logic := '0';
    signal reset_all_tb : std_logic := '0';
    signal start_tb     : std_logic := '0';
    signal running_tb   : std_logic := '0';
    signal move_tick_tb : std_logic := '0';
    signal frame_end_tb : std_logic := '0';

    signal ball_x_tb    : integer range 0 to 799;
    signal ball_done_tb : std_logic;

begin

    uut : entity work.ball_motion
        generic map(
            SCREEN_W => SCREEN_W,
            TRACK_X0 => TRACK_X0,
            TRACK_X1 => TRACK_X1,
            BALL_R   => BALL_R
        )
        port map(
            clk       => clk_tb,
            reset_all => reset_all_tb,
            start     => start_tb,
            running   => running_tb,
            move_tick => move_tick_tb,
            frame_end => frame_end_tb,
            ball_x    => ball_x_tb,
            ball_done => ball_done_tb
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

        reset_all_tb <= '1';
        start_tb     <= '0';
        running_tb   <= '0';
        move_tick_tb <= '0';
        frame_end_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert ball_x_tb = BALL_START_X
            report "Error: con reset_all, ball_x deberia estar en BALL_START_X"
            severity error;

        assert ball_done_tb = '0'
            report "Error: con reset_all, ball_done deberia valer 0"
            severity error;

        reset_all_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        start_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert ball_x_tb = BALL_START_X
            report "Error: con start, ball_x deberia volver al inicio"
            severity error;

        assert ball_done_tb = '0'
            report "Error: con start, ball_done deberia valer 0"
            severity error;

        start_tb <= '0';

        running_tb   <= '0';
        move_tick_tb <= '1';
        frame_end_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert ball_x_tb = BALL_START_X
            report "Error: si running = 0, la bola no deberia moverse"
            severity error;

        move_tick_tb <= '0';
        frame_end_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        running_tb <= '1';

        move_tick_tb <= '1';
        frame_end_tb <= '0';

        wait until rising_edge(clk_tb);
        wait until rising_edge(clk_tb);
        wait until rising_edge(clk_tb);

        move_tick_tb <= '0';

        wait for 1 ns;

        assert ball_x_tb = BALL_START_X
            report "Error: antes de frame_end, ball_x no deberia actualizarse"
            severity error;

        frame_end_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert ball_x_tb = BALL_START_X + 3
            report "Error: con 3 move_tick pendientes, ball_x deberia avanzar 3 pixeles"
            severity error;

        frame_end_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        running_tb <= '0';
        move_tick_tb <= '1';
        frame_end_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert ball_x_tb = BALL_START_X + 3
            report "Error: si running = 0, no deberia avanzar aunque haya move_tick y frame_end"
            severity error;

        move_tick_tb <= '0';
        frame_end_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        running_tb <= '1';

        for i in 1 to 40 loop

            move_tick_tb <= '1';
            frame_end_tb <= '1';

            wait until rising_edge(clk_tb);
            wait for 1 ns;

            move_tick_tb <= '0';
            frame_end_tb <= '0';

            wait until rising_edge(clk_tb);
            wait for 1 ns;

            exit when ball_done_tb = '1';

        end loop;

        assert ball_x_tb = BALL_END_X
            report "Error: al terminar, ball_x deberia quedar en BALL_END_X"
            severity error;

        assert ball_done_tb = '1'
            report "Error: al llegar al final, ball_done deberia valer 1"
            severity error;

        move_tick_tb <= '1';
        frame_end_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert ball_x_tb = BALL_END_X
            report "Error: despues de ball_done, la bola no deberia seguir avanzando"
            severity error;

        move_tick_tb <= '0';
        frame_end_tb <= '0';

        start_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert ball_x_tb = BALL_START_X
            report "Error: start deberia reiniciar la bola despues de terminar"
            severity error;

        assert ball_done_tb = '0'
            report "Error: start deberia poner ball_done a 0 despues de terminar"
            severity error;

        start_tb <= '0';

        report "Testbench de ball_motion finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;