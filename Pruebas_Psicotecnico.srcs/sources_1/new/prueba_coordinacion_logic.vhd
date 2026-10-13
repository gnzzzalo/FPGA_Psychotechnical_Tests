library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.psicotecnico_pkg.all;
use work.prueba_coordinacion_pkg.all;
use work.coord_tracks_pkg.all;

entity prueba_coordinacion_logic is
    Port (
        clk25      : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        locked     : in  STD_LOGIC;
        enable     : in  STD_LOGIC;

        start_btn  : in  STD_LOGIC;
        JC         : in  STD_LOGIC_VECTOR(7 downto 0);
        frame_tick : in  STD_LOGIC;

        left_path_id  : in path_id_t;
        right_path_id : in path_id_t;

        ball1_x_o  : out integer range 0 to 639;
        ball2_x_o  : out integer range 0 to 639;
        scroll_y_o : out integer range 0 to 511;

        danger_o   : out STD_LOGIC;

        test_state_o : out test_state_type;

        seg_ss_tens_o  : out seg_t;
        seg_ss_units_o : out seg_t;
        seg_cs_tens_o  : out seg_t;
        seg_cs_units_o : out seg_t
    );
end prueba_coordinacion_logic;

architecture Behavioral of prueba_coordinacion_logic is

    signal test_state : test_state_type := IDLE;

    signal ball1_x  : integer range 0 to 639 := 160;
    signal ball2_x  : integer range 0 to 639 := 480;
    signal scroll_y : integer range 0 to 511 := 0;

    signal danger : STD_LOGIC := '0';

    signal centi_cnt  : integer range 0 to COORD_CENTI_MAX_CYC-1 := 0;
    signal centi_tick : STD_LOGIC := '0';

    signal test_cs : integer range 0 to COORD_TEST_CS_MAX := 0;

    signal ss_tens  : integer range 0 to 9 := 0;
    signal ss_units : integer range 0 to 9 := 0;
    signal cs_tens  : integer range 0 to 9 := 0;
    signal cs_units : integer range 0 to 9 := 0;

    signal player_frame_cnt : integer range 0 to PLAYER_FRAME_DIV-1 := 0;
    signal player_tick      : STD_LOGIC := '0';

    signal jc_sync0 : STD_LOGIC_VECTOR(7 downto 0) := (others => '1');
    signal jc_sync1 : STD_LOGIC_VECTOR(7 downto 0) := (others => '1');

    signal joy1_left  : STD_LOGIC;
    signal joy1_right : STD_LOGIC;
    signal joy2_left  : STD_LOGIC;
    signal joy2_right : STD_LOGIC;

begin

    --------------------------------------------------------------------
    -- Tick de centésimas
    --------------------------------------------------------------------
    process(clk25)
    begin
        if rising_edge(clk25) then
            if rst = '1' or locked = '0' or enable = '0' then
                centi_cnt  <= 0;
                centi_tick <= '0';

            else
                centi_tick <= '0';

                if centi_cnt = COORD_CENTI_MAX_CYC - 1 then
                    centi_cnt  <= 0;
                    centi_tick <= '1';
                else
                    centi_cnt <= centi_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Tick de movimiento del jugador
    --------------------------------------------------------------------
    process(clk25)
    begin
        if rising_edge(clk25) then
            if rst = '1' or locked = '0' or enable = '0' then
                player_frame_cnt <= 0;
                player_tick <= '0';

            else
                player_tick <= '0';

                if frame_tick = '1' then
                    if player_frame_cnt = PLAYER_FRAME_DIV - 1 then
                        player_frame_cnt <= 0;
                        player_tick <= '1';
                    else
                        player_frame_cnt <= player_frame_cnt + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Sincronización del joystick
    --------------------------------------------------------------------
    process(clk25)
    begin
        if rising_edge(clk25) then
            if rst = '1' or locked = '0' or enable = '0' then
                jc_sync0 <= (others => '1');
                jc_sync1 <= (others => '1');
            else
                jc_sync0 <= JC;
                jc_sync1 <= jc_sync0;
            end if;
        end if;
    end process;

    joy1_left  <= not jc_sync1(2);
    joy1_right <= not jc_sync1(3);

    joy2_left  <= not jc_sync1(6);
    joy2_right <= not jc_sync1(7);

    --------------------------------------------------------------------
    -- Lógica principal
    --------------------------------------------------------------------
    process(clk25)
        variable next_scroll : integer;

        variable yw1 : integer;
        variable yw2 : integer;
        variable c1  : integer;
        variable c2  : integer;

        variable next_ball1_x : integer;
        variable next_ball2_x : integer;

        variable outside_now : boolean;
    begin
        if rising_edge(clk25) then

            if rst = '1' or locked = '0' or enable = '0' then
                test_state <= IDLE;

                scroll_y <= 0;
                ball1_x <= path_left_center_x(left_path_id, BALL1_Y_FIXED);
                ball2_x <= path_right_center_x(right_path_id, BALL2_Y_FIXED);

                danger <= '0';

                test_cs <= 0;

                ss_tens  <= 0;
                ss_units <= 0;
                cs_tens  <= 0;
                cs_units <= 0;

            else

                case test_state is

                    when IDLE =>
                        scroll_y <= 0;

                        ball1_x <= path_left_center_x(left_path_id, BALL1_Y_FIXED);
                        ball2_x <= path_right_center_x(right_path_id, BALL2_Y_FIXED);

                        danger <= '0';

                        test_cs <= 0;

                        ss_tens  <= 0;
                        ss_units <= 0;
                        cs_tens  <= 0;
                        cs_units <= 0;

                        if start_btn = '1' then
                            test_state <= RUNNING;
                        end if;

                    when RUNNING =>

                        if frame_tick = '1' then
                            if scroll_y >= 512 - SCROLL_STEP then
                                next_scroll := scroll_y + SCROLL_STEP - 512;
                            else
                                next_scroll := scroll_y + SCROLL_STEP;
                            end if;

                            scroll_y <= next_scroll;
                        else
                            next_scroll := scroll_y;
                        end if;

                        next_ball1_x := ball1_x;
                        next_ball2_x := ball2_x;

                        if player_tick = '1' then

                            if joy1_left = '1' and ball1_x > LEFT_MIN + 4 then
                                next_ball1_x := ball1_x - 4;
                            elsif joy1_right = '1' and ball1_x < LEFT_MAX - 4 then
                                next_ball1_x := ball1_x + 4;
                            end if;

                            if joy2_left = '1' and ball2_x > RIGHT_MIN + 4 then
                                next_ball2_x := ball2_x - 4;
                            elsif joy2_right = '1' and ball2_x < RIGHT_MAX - 4 then
                                next_ball2_x := ball2_x + 4;
                            end if;

                            ball1_x <= next_ball1_x;
                            ball2_x <= next_ball2_x;
                        end if;

                        yw1 := wrap512(BALL1_Y_FIXED - next_scroll);
                        yw2 := wrap512(BALL2_Y_FIXED - next_scroll);

                        c1 := path_left_center_x(left_path_id, yw1);
                        c2 := path_right_center_x(right_path_id, yw2);

                        outside_now :=
                            (next_ball1_x < c1 - (PATH_HALF - BALL_R)) or
                            (next_ball1_x > c1 + (PATH_HALF - BALL_R)) or
                            (next_ball2_x < c2 - (PATH_HALF - BALL_R)) or
                            (next_ball2_x > c2 + (PATH_HALF - BALL_R));

                        if outside_now then
                            danger <= '1';
                        else
                            danger <= '0';
                        end if;

                        if centi_tick = '1' then

                            if test_cs = COORD_TEST_CS_MAX then
                                test_state <= FINISHED;
                            else
                                test_cs <= test_cs + 1;
                            end if;

                            if outside_now then

                                if cs_units = 9 then
                                    cs_units <= 0;

                                    if cs_tens = 9 then
                                        cs_tens <= 0;

                                        if ss_units = 9 then
                                            ss_units <= 0;

                                            if ss_tens < 9 then
                                                ss_tens <= ss_tens + 1;
                                            end if;

                                        else
                                            ss_units <= ss_units + 1;
                                        end if;

                                    else
                                        cs_tens <= cs_tens + 1;
                                    end if;

                                else
                                    cs_units <= cs_units + 1;
                                end if;

                            end if;

                        end if;

                    when FINISHED =>
                        danger <= '0';

                        if start_btn = '1' then
                            test_state <= IDLE;
                        end if;

                end case;
            end if;
        end if;
    end process;

    ball1_x_o  <= ball1_x;
    ball2_x_o  <= ball2_x;
    scroll_y_o <= scroll_y;

    danger_o <= danger;

    test_state_o <= test_state;

    seg_ss_tens_o  <= seg_decode(ss_tens);
    seg_ss_units_o <= seg_decode(ss_units);
    seg_cs_tens_o  <= seg_decode(cs_tens);
    seg_cs_units_o <= seg_decode(cs_units);

end Behavioral;