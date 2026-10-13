library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_vga_screen is
end tb_vga_screen;

architecture Behavioral of tb_vga_screen is

    constant WIDTH    : integer := 16;
    constant SCREEN_W : integer := 40;
    constant SCREEN_H : integer := 480;
    constant TRACK_X0 : integer := 0;
    constant TRACK_X1 : integer := 30;
    constant TRACK_H  : integer := 130;
    constant BALL_R   : integer := 2;

    constant BALL_START_X : integer := TRACK_X0 + BALL_R;
    constant BALL_END_X   : integer := SCREEN_W - BALL_R;
    constant BALL_Y       : integer := SCREEN_H / 2;

    constant TEXT_X0    : integer := 245;
    constant TEXT_Y0    : integer := 160;
    constant TEXT_ROW_H : integer := 70;

    signal clk_tb          : std_logic := '0';
    signal reset_all_tb    : std_logic := '0';
    signal start_game_tb   : std_logic := '0';
    signal running_tb      : std_logic := '0';
    signal move_tick_tb    : std_logic := '0';
    signal frame_end_tb    : std_logic := '0';
    signal final_screen_tb : std_logic := '0';

    signal h_count_tb : integer range 0 to 799 := 0;
    signal v_count_tb : integer range 0 to 524 := 0;
    signal visible_tb : std_logic := '0';

    signal result0_tb : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal result1_tb : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal result2_tb : std_logic_vector(WIDTH-1 downto 0) := (others => '0');

    signal neg0_tb : std_logic := '0';
    signal neg1_tb : std_logic := '0';
    signal neg2_tb : std_logic := '0';

    signal fail0_tb : std_logic := '0';
    signal fail1_tb : std_logic := '0';
    signal fail2_tb : std_logic := '0';

    signal ball_done_tb : std_logic;

    signal vgaRed_tb   : std_logic_vector(3 downto 0);
    signal vgaGreen_tb : std_logic_vector(3 downto 0);
    signal vgaBlue_tb  : std_logic_vector(3 downto 0);

begin

    uut : entity work.vga_screen
        generic map(
            WIDTH    => WIDTH,
            SCREEN_W => SCREEN_W,
            SCREEN_H => SCREEN_H,
            TRACK_X0 => TRACK_X0,
            TRACK_X1 => TRACK_X1,
            TRACK_H  => TRACK_H,
            BALL_R   => BALL_R
        )
        port map(
            clk          => clk_tb,
            reset_all    => reset_all_tb,
            start_game   => start_game_tb,
            running      => running_tb,
            move_tick    => move_tick_tb,
            frame_end    => frame_end_tb,
            final_screen => final_screen_tb,

            h_count      => h_count_tb,
            v_count      => v_count_tb,
            visible      => visible_tb,

            result0      => result0_tb,
            result1      => result1_tb,
            result2      => result2_tb,

            neg0         => neg0_tb,
            neg1         => neg1_tb,
            neg2         => neg2_tb,

            fail0        => fail0_tb,
            fail1        => fail1_tb,
            fail2        => fail2_tb,

            ball_done    => ball_done_tb,

            vgaRed       => vgaRed_tb,
            vgaGreen     => vgaGreen_tb,
            vgaBlue      => vgaBlue_tb
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

        result0_tb <= std_logic_vector(to_unsigned(123, WIDTH));
        result1_tb <= std_logic_vector(to_unsigned(45, WIDTH));
        result2_tb <= std_logic_vector(to_unsigned(7, WIDTH));

        neg0_tb <= '1';
        neg1_tb <= '0';
        neg2_tb <= '0';

        fail0_tb <= '0';
        fail1_tb <= '1';
        fail2_tb <= '0';

        visible_tb <= '1';
        final_screen_tb <= '0';

        reset_all_tb <= '1';
        start_game_tb <= '0';
        running_tb <= '0';
        move_tick_tb <= '0';
        frame_end_tb <= '0';

        h_count_tb <= BALL_START_X;
        v_count_tb <= BALL_Y;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert ball_done_tb = '0'
            report "Error: con reset_all, ball_done deberia valer 0"
            severity error;

        reset_all_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        start_game_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert ball_done_tb = '0'
            report "Error: con start_game, ball_done deberia valer 0"
            severity error;

        start_game_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        h_count_tb <= 10;
        v_count_tb <= BALL_Y;

        wait for 10 ns;

        assert vgaRed_tb = "1111" and vgaGreen_tb = "1111" and vgaBlue_tb = "1111"
            report "Error: un pixel dentro del carril y fuera de la bola deberia ser blanco"
            severity error;

        h_count_tb <= BALL_START_X;
        v_count_tb <= BALL_Y;

        wait for 10 ns;

        assert vgaRed_tb = "1111" and vgaGreen_tb = "1000" and vgaBlue_tb = "0000"
            report "Error: un pixel de la bola deberia ser naranja"
            severity error;

        h_count_tb <= 35;
        v_count_tb <= BALL_Y;

        wait for 10 ns;

        assert vgaRed_tb = "1111" and vgaGreen_tb = "1000" and vgaBlue_tb = "0000"
            report "Error: fuera del carril, el fondo deberia ser naranja"
            severity error;

        visible_tb <= '0';

        wait for 10 ns;

        assert vgaRed_tb = "0000" and vgaGreen_tb = "0000" and vgaBlue_tb = "0000"
            report "Error: con visible = 0, la salida VGA deberia ser negro"
            severity error;

        visible_tb <= '1';

        wait for 10 ns;

        running_tb <= '1';

        move_tick_tb <= '1';
        frame_end_tb <= '0';

        wait until rising_edge(clk_tb);
        wait until rising_edge(clk_tb);
        wait until rising_edge(clk_tb);
        wait for 1 ns;

        move_tick_tb <= '0';

        h_count_tb <= BALL_START_X + 3;
        v_count_tb <= BALL_Y;

        wait for 10 ns;

        assert vgaRed_tb = "1111" and vgaGreen_tb = "1111" and vgaBlue_tb = "1111"
            report "Error: antes de frame_end, la bola no deberia haber avanzado"
            severity error;

        frame_end_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        frame_end_tb <= '0';

        h_count_tb <= BALL_START_X + 3;
        v_count_tb <= BALL_Y;

        wait for 10 ns;

        assert vgaRed_tb = "1111" and vgaGreen_tb = "1000" and vgaBlue_tb = "0000"
            report "Error: despues de frame_end, la bola deberia haber avanzado 3 pixeles"
            severity error;

        for i in 1 to 50 loop

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

        assert ball_done_tb = '1'
            report "Error: la bola deberia llegar al final y activar ball_done"
            severity error;

        start_game_tb <= '1';
        running_tb <= '0';
        move_tick_tb <= '0';
        frame_end_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert ball_done_tb = '0'
            report "Error: start_game deberia reiniciar ball_done"
            severity error;

        start_game_tb <= '0';

        final_screen_tb <= '1';
        visible_tb <= '1';

        h_count_tb <= TEXT_X0;
        v_count_tb <= TEXT_Y0 + 15;

        wait for 10 ns;

        assert vgaRed_tb = "0000" and vgaGreen_tb = "0000" and vgaBlue_tb = "0000"
            report "Error: en pantalla final, el texto deberia ser negro"
            severity error;

        h_count_tb <= 100;
        v_count_tb <= 100;

        wait for 10 ns;

        assert vgaRed_tb = "1111" and vgaGreen_tb = "1000" and vgaBlue_tb = "0000"
            report "Error: en pantalla final, el fondo deberia ser naranja"
            severity error;

        final_screen_tb <= '0';

        report "Testbench de vga_screen finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;