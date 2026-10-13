library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity leds is
    generic(
        CLK_FREQ_HZ           : integer := 100000000;
        WIDTH                 : integer := 16;
        DEBOUNCE_STABLE_COUNT : integer := 1_000_000;
        MIN_COUNT             : integer := 326797  - 1;
        MAX_COUNT             : integer := 1470588 - 1
    );
    Port (
        clk  : in  std_logic;
        btnC : in  std_logic;
        btnU : in  std_logic;
        swt  : in  std_logic_vector(0 downto 0);

        vgaRed   : out std_logic_vector(3 downto 0);
        vgaGreen : out std_logic_vector(3 downto 0);
        vgaBlue  : out std_logic_vector(3 downto 0);
        Hsync    : out std_logic;
        Vsync    : out std_logic;

        seg  : out std_logic_vector(6 downto 0);
        an   : out std_logic_vector(3 downto 0);
        dp   : out std_logic
    );
end leds;

architecture Structural of leds is

    signal reset_all_s : std_logic;
    signal btnC_edge_s : std_logic;
    signal btnU_edge_s : std_logic;

    signal h_count_s   : integer range 0 to 799;
    signal v_count_s   : integer range 0 to 524;
    signal visible_s   : std_logic;
    signal frame_end_s : std_logic;

    signal tick_ball_s : std_logic;
    signal move_tick_s : std_logic;

    signal running_s      : std_logic;
    signal final_screen_s : std_logic;
    signal show_result_s  : std_logic;
    signal accept_btnU_s  : std_logic;

    signal start_attempt_s     : std_logic;
    signal reset_attempt_s     : std_logic;
    signal start_or_reset_game : std_logic;

    signal ball_done_s : std_logic;

    signal count1_s : std_logic_vector(WIDTH-1 downto 0);
    signal count2_s : std_logic_vector(WIDTH-1 downto 0);

    signal limit1_s : std_logic;
    signal limit2_s : std_logic;

    signal done1_s : std_logic;
    signal done2_s : std_logic;

    signal fin1_s : std_logic;
    signal fin2_s : std_logic;

    signal result_s  : std_logic_vector(WIDTH-1 downto 0);
    signal pos_neg_s : std_logic;
    signal zero_s    : std_logic;

    signal in_range_s     : std_logic;
    signal negative_s     : std_logic;
    signal display_mode_s : std_logic_vector(1 downto 0);

    signal stored_result0 : std_logic_vector(WIDTH-1 downto 0);
    signal stored_result1 : std_logic_vector(WIDTH-1 downto 0);
    signal stored_result2 : std_logic_vector(WIDTH-1 downto 0);

    signal stored_neg0 : std_logic;
    signal stored_neg1 : std_logic;
    signal stored_neg2 : std_logic;

    signal stored_fail0 : std_logic;
    signal stored_fail1 : std_logic;
    signal stored_fail2 : std_logic;

    signal vgaRed_s   : std_logic_vector(3 downto 0);
    signal vgaGreen_s : std_logic_vector(3 downto 0);
    signal vgaBlue_s  : std_logic_vector(3 downto 0);

begin

    start_or_reset_game <= start_attempt_s or reset_attempt_s or reset_all_s;

    move_tick_s <= tick_ball_s and running_s;

    vgaRed   <= (others => '0') when reset_all_s = '1' else vgaRed_s;
    vgaGreen <= (others => '0') when reset_all_s = '1' else vgaGreen_s;
    vgaBlue  <= (others => '0') when reset_all_s = '1' else vgaBlue_s;

    inputs : entity work.input_control
        generic map(
            DEBOUNCE_STABLE_COUNT => DEBOUNCE_STABLE_COUNT
        )
        port map(
            clk       => clk,
            btnC      => btnC,
            btnU      => btnU,
            swt       => swt,
            reset_all => reset_all_s,
            btnC_edge => btnC_edge_s,
            btnU_edge => btnU_edge_s
        );

    vga_controller : entity work.vga_sync
        port map(
            clk       => clk,
            reset     => '0',
            h_count   => h_count_s,
            v_count   => v_count_s,
            visible   => visible_s,
            frame_end => frame_end_s,
            Hsync     => Hsync,
            Vsync     => Vsync
        );

    tick_rndm_speed : entity work.tick_variable
        generic map(
            MIN_COUNT => MIN_COUNT,
            MAX_COUNT => MAX_COUNT
        )
        port map(
            clk       => clk,
            reset     => reset_all_s,
            randomize => start_attempt_s,
            tick      => tick_ball_s
        );

    vga_screen : entity work.vga_screen
        generic map(
            WIDTH    => WIDTH,
            SCREEN_W => 640,
            SCREEN_H => 480,
            TRACK_X0 => 0,
            TRACK_X1 => 520,
            TRACK_H  => 130,
            BALL_R   => 14
        )
        port map(
            clk          => clk,
            reset_all    => reset_all_s,
            start_game   => start_or_reset_game,
            running      => running_s,
            move_tick    => move_tick_s,
            frame_end    => frame_end_s,
            final_screen => final_screen_s,

            h_count      => h_count_s,
            v_count      => v_count_s,
            visible      => visible_s,

            result0      => stored_result0,
            result1      => stored_result1,
            result2      => stored_result2,

            neg0         => stored_neg0,
            neg1         => stored_neg1,
            neg2         => stored_neg2,

            fail0        => stored_fail0,
            fail1        => stored_fail1,
            fail2        => stored_fail2,

            ball_done    => ball_done_s,

            vgaRed       => vgaRed_s,
            vgaGreen     => vgaGreen_s,
            vgaBlue      => vgaBlue_s
        );

    fin1_s <= ball_done_s;
    fin2_s <= btnU_edge_s when accept_btnU_s = '1' else '0';

    chrono_count1 : entity work.chronometer
        generic map(
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            OUT_WIDTH   => WIDTH
        )
        port map(
            clk       => clk,
            ini       => start_attempt_s,
            fin       => fin1_s,
            count_out => count1_s,
            limit_out => limit1_s,
            done_out  => done1_s
        );

    chrono_count2 : entity work.chronometer
        generic map(
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            OUT_WIDTH   => WIDTH
        )
        port map(
            clk       => clk,
            ini       => start_attempt_s,
            fin       => fin2_s,
            count_out => count2_s,
            limit_out => limit2_s,
            done_out  => done2_s
        );

    restador : entity work.subtractor
        generic map(
            WIDTH => WIDTH
        )
        port map(
            count1   => count2_s,
            count2   => count1_s,
            done1    => done1_s,
            done2    => done2_s,
            result   => result_s,
            pos_neg  => pos_neg_s,
            zero_out => zero_s
        );

    result_block : entity work.logic_R
        generic map(
            WIDTH => WIDTH
        )
        port map(
            count1       => count1_s,
            count2       => count2_s,
            done1        => done1_s,
            done2        => done2_s,
            pos_neg      => pos_neg_s,
            zero_out     => zero_s,
            show_result  => show_result_s,
            in_range     => in_range_s,
            negative     => negative_s,
            display_mode => display_mode_s
        );

    fsm : entity work.control_attemp
        generic map(
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            WIDTH       => WIDTH
        )
        port map(
            clk       => clk,
            reset_all => reset_all_s,

            btnC_edge => btnC_edge_s,

            done1 => done1_s,
            done2 => done2_s,

            result_in => result_s,
            negative  => negative_s,
            in_range  => in_range_s,

            start_attempt => start_attempt_s,
            reset_attempt => reset_attempt_s,

            running      => running_s,
            final_screen => final_screen_s,
            show_result  => show_result_s,
            accept_btnU  => accept_btnU_s,

            result0 => stored_result0,
            result1 => stored_result1,
            result2 => stored_result2,

            neg0 => stored_neg0,
            neg1 => stored_neg1,
            neg2 => stored_neg2,

            fail0 => stored_fail0,
            fail1 => stored_fail1,
            fail2 => stored_fail2
        );

    display_resultado : entity work.display_7seg_R
        generic map(
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            WIDTH       => WIDTH
        )
        port map(
            clk          => clk,
            value_cs     => result_s,
            display_mode => display_mode_s,
            negative     => negative_s,
            seg          => seg,
            an           => an,
            dp           => dp
        );

end Structural;