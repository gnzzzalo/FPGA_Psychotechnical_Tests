library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.psicotecnico_pkg.all;
use work.prueba_coordinacion_pkg.all;
use work.coord_tracks_pkg.all;

entity coordinacion is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        enable    : in  STD_LOGIC;

        start_btn : in  STD_LOGIC;
        JC        : in  STD_LOGIC_VECTOR(7 downto 0);

        vgaRed    : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen  : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue   : out STD_LOGIC_VECTOR(3 downto 0);
        Hsync     : out STD_LOGIC;
        Vsync     : out STD_LOGIC;

        buzzer_out : out STD_LOGIC;
        led_fail   : out STD_LOGIC
    );
end coordinacion;

architecture Structural of coordinacion is

    signal clk25_coord  : STD_LOGIC;
    signal locked_coord : STD_LOGIC;

    signal h_count_s    : integer range 0 to HT-1;
    signal v_count_s    : integer range 0 to VT-1;
    signal video_on_s   : STD_LOGIC;
    signal frame_tick_s : STD_LOGIC;

    signal left_path_id_s  : path_id_t;
    signal right_path_id_s : path_id_t;

    signal ball1_x_s  : integer range 0 to 639;
    signal ball2_x_s  : integer range 0 to 639;
    signal scroll_y_s : integer range 0 to 511;

    signal danger_s : STD_LOGIC;
    signal state_s  : test_state_type;

    signal seg_ss_tens_s  : seg_t;
    signal seg_ss_units_s : seg_t;
    signal seg_cs_tens_s  : seg_t;
    signal seg_cs_units_s : seg_t;

begin

    clk25_block : entity work.clk25_generator
        port map (
            clk100 => clk,
            rst    => rst,
            clk25  => clk25_coord,
            locked => locked_coord
        );

    vga_block : entity work.vga_sync_coord
        port map (
            clk25      => clk25_coord,
            rst        => rst,
            locked     => locked_coord,

            h_count    => h_count_s,
            v_count    => v_count_s,

            video_on   => video_on_s,
            frame_tick => frame_tick_s,

            Hsync      => Hsync,
            Vsync      => Vsync
        );

    path_selector_block : entity work.coord_path_selector
        port map (
            clk25      => clk25_coord,
            rst        => rst,
            locked     => locked_coord,
            enable     => enable,

            start_btn  => start_btn,

            left_path_id_o  => left_path_id_s,
            right_path_id_o => right_path_id_s
        );

    logic_block : entity work.prueba_coordinacion_logic
        port map (
            clk25      => clk25_coord,
            rst        => rst,
            locked     => locked_coord,
            enable     => enable,

            start_btn  => start_btn,
            JC         => JC,
            frame_tick => frame_tick_s,

            left_path_id  => left_path_id_s,
            right_path_id => right_path_id_s,

            ball1_x_o  => ball1_x_s,
            ball2_x_o  => ball2_x_s,
            scroll_y_o => scroll_y_s,

            danger_o   => danger_s,

            test_state_o => state_s,

            seg_ss_tens_o  => seg_ss_tens_s,
            seg_ss_units_o => seg_ss_units_s,
            seg_cs_tens_o  => seg_cs_tens_s,
            seg_cs_units_o => seg_cs_units_s
        );

    renderer_block : entity work.prueba_coordinacion_renderer
        port map (
            h_count    => h_count_s,
            v_count    => v_count_s,
            video_on   => video_on_s,

            left_path_id  => left_path_id_s,
            right_path_id => right_path_id_s,

            ball1_x    => ball1_x_s,
            ball2_x    => ball2_x_s,
            scroll_y   => scroll_y_s,

            danger     => danger_s,
            test_state => state_s,

            seg_ss_tens  => seg_ss_tens_s,
            seg_ss_units => seg_ss_units_s,
            seg_cs_tens  => seg_cs_tens_s,
            seg_cs_units => seg_cs_units_s,

            vgaRed    => vgaRed,
            vgaGreen  => vgaGreen,
            vgaBlue   => vgaBlue
        );

    buzzer_block : entity work.buzzer_driver
        port map (
            clk25      => clk25_coord,
            rst        => rst,
            locked     => locked_coord,

            danger     => danger_s,
            test_state => state_s,

            buzzer_out => buzzer_out
        );

    led_fail <= danger_s;

end Structural;