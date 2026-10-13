library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_screen is
    generic(
        WIDTH    : integer := 16;
        SCREEN_W : integer := 640;
        SCREEN_H : integer := 480;
        TRACK_X0 : integer := 0;
        TRACK_X1 : integer := 520;
        TRACK_H  : integer := 130;
        BALL_R   : integer := 14
    );
    port(
        clk          : in  std_logic;
        reset_all    : in  std_logic;
        start_game   : in  std_logic;
        running      : in  std_logic;
        move_tick    : in  std_logic;
        frame_end    : in  std_logic;
        final_screen : in  std_logic;

        h_count      : in  integer range 0 to 799;
        v_count      : in  integer range 0 to 524;
        visible      : in  std_logic;

        result0      : in  std_logic_vector(WIDTH-1 downto 0);
        result1      : in  std_logic_vector(WIDTH-1 downto 0);
        result2      : in  std_logic_vector(WIDTH-1 downto 0);

        neg0         : in  std_logic;
        neg1         : in  std_logic;
        neg2         : in  std_logic;

        fail0        : in  std_logic;
        fail1        : in  std_logic;
        fail2        : in  std_logic;

        ball_done    : out std_logic;

        vgaRed       : out std_logic_vector(3 downto 0);
        vgaGreen     : out std_logic_vector(3 downto 0);
        vgaBlue      : out std_logic_vector(3 downto 0)
    );
end vga_screen;

architecture Structural of vga_screen is

    signal ball_x_s     : integer range 0 to 799;
    signal in_ball_s    : std_logic;
    signal in_track_s   : std_logic;
    signal text_pixel_s : std_logic;

begin

    motion : entity work.ball_motion
        generic map(
            SCREEN_W => SCREEN_W,
            TRACK_X0 => TRACK_X0,
            TRACK_X1 => TRACK_X1,
            BALL_R   => BALL_R
        )
        port map(
            clk       => clk,
            reset_all => reset_all,
            start     => start_game,
            running   => running,
            move_tick => move_tick,
            frame_end => frame_end,
            ball_x    => ball_x_s,
            ball_done => ball_done
        );

    ball_pixels : entity work.ball_draw
        generic map(
            SCREEN_H => SCREEN_H,
            BALL_R   => BALL_R
        )
        port map(
            h_count => h_count,
            v_count => v_count,
            ball_x  => ball_x_s,
            in_ball => in_ball_s
        );

    track_pixels : entity work.track_draw
        generic map(
            SCREEN_H => SCREEN_H,
            TRACK_X0 => TRACK_X0,
            TRACK_X1 => TRACK_X1,
            TRACK_H  => TRACK_H
        )
        port map(
            h_count  => h_count,
            v_count  => v_count,
            in_track => in_track_s
        );

    results_pixels : entity work.vga_results_draw
        generic map(
            WIDTH => WIDTH
        )
        port map(
            h_count      => h_count,
            v_count      => v_count,
            visible      => visible,
            final_screen => final_screen,

            result0      => result0,
            result1      => result1,
            result2      => result2,

            neg0         => neg0,
            neg1         => neg1,
            neg2         => neg2,

            fail0        => fail0,
            fail1        => fail1,
            fail2        => fail2,

            text_pixel   => text_pixel_s
        );

    color_selector : entity work.vga_color_mux
        port map(
            visible      => visible,
            final_screen => final_screen,
            in_ball      => in_ball_s,
            in_track     => in_track_s,
            text_pixel   => text_pixel_s,
            vgaRed       => vgaRed,
            vgaGreen     => vgaGreen,
            vgaBlue      => vgaBlue
        );

end Structural;