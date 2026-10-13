library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.psicotecnico_pkg.all;
use work.prueba_coordinacion_pkg.all;
use work.coord_tracks_pkg.all;

entity prueba_coordinacion_renderer is
    Port (
        h_count    : in integer range 0 to HT-1;
        v_count    : in integer range 0 to VT-1;
        video_on   : in STD_LOGIC;

        left_path_id  : in path_id_t;
        right_path_id : in path_id_t;

        ball1_x    : in integer range 0 to 639;
        ball2_x    : in integer range 0 to 639;
        scroll_y   : in integer range 0 to 511;

        danger     : in STD_LOGIC;
        test_state : in test_state_type;

        seg_ss_tens  : in seg_t;
        seg_ss_units : in seg_t;
        seg_cs_tens  : in seg_t;
        seg_cs_units : in seg_t;

        vgaRed    : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen  : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end prueba_coordinacion_renderer;

architecture Behavioral of prueba_coordinacion_renderer is
begin

    process(h_count, v_count, video_on,
            left_path_id, right_path_id,
            ball1_x, ball2_x, scroll_y, danger, test_state,
            seg_ss_tens, seg_ss_units, seg_cs_tens, seg_cs_units)

        variable yw : integer;

        variable c1 : integer;
        variable c2 : integer;

        variable path1_on : boolean;
        variable path2_on : boolean;

        variable ball1_on : boolean;
        variable ball2_on : boolean;

        variable top_on   : boolean;
        variable final_on : boolean;

    begin

        yw := wrap512(v_count - scroll_y);

        c1 := path_left_center_x(left_path_id, yw);
        c2 := path_right_center_x(right_path_id, yw);

        path1_on :=
            video_on = '1' and
            h_count >= c1 - PATH_HALF and
            h_count <= c1 + PATH_HALF;

        path2_on :=
            video_on = '1' and
            h_count >= c2 - PATH_HALF and
            h_count <= c2 + PATH_HALF;

        ball1_on :=
            video_on = '1' and
            h_count >= ball1_x - BALL_R and
            h_count <= ball1_x + BALL_R and
            v_count >= BALL1_Y_FIXED - BALL_R and
            v_count <= BALL1_Y_FIXED + BALL_R;

        ball2_on :=
            video_on = '1' and
            h_count >= ball2_x - BALL_R and
            h_count <= ball2_x + BALL_R and
            v_count >= BALL2_Y_FIXED - BALL_R and
            v_count <= BALL2_Y_FIXED + BALL_R;

        top_on :=
            test_state = RUNNING and video_on = '1' and (
                (
                    h_count >= 250 and h_count < 274 and
                    v_count >= 20 and v_count < 60 and
                    seg_on(seg_ss_tens, h_count - 250, v_count - 20, 24, 40, 4)
                ) or (
                    h_count >= 280 and h_count < 304 and
                    v_count >= 20 and v_count < 60 and
                    seg_on(seg_ss_units, h_count - 280, v_count - 20, 24, 40, 4)
                ) or (
                    h_count >= 312 and h_count < 318 and
                    v_count >= 54 and v_count < 60
                ) or (
                    h_count >= 326 and h_count < 350 and
                    v_count >= 20 and v_count < 60 and
                    seg_on(seg_cs_tens, h_count - 326, v_count - 20, 24, 40, 4)
                ) or (
                    h_count >= 356 and h_count < 380 and
                    v_count >= 20 and v_count < 60 and
                    seg_on(seg_cs_units, h_count - 356, v_count - 20, 24, 40, 4)
                )
            );

        final_on :=
            test_state = FINISHED and video_on = '1' and (
                (
                    h_count >= 170 and h_count < 230 and
                    v_count >= 185 and v_count < 285 and
                    seg_on(seg_ss_tens, h_count - 170, v_count - 185, 60, 100, 10)
                ) or (
                    h_count >= 245 and h_count < 305 and
                    v_count >= 185 and v_count < 285 and
                    seg_on(seg_ss_units, h_count - 245, v_count - 185, 60, 100, 10)
                ) or (
                    h_count >= 318 and h_count < 332 and
                    v_count >= 270 and v_count < 285
                ) or (
                    h_count >= 345 and h_count < 405 and
                    v_count >= 185 and v_count < 285 and
                    seg_on(seg_cs_tens, h_count - 345, v_count - 185, 60, 100, 10)
                ) or (
                    h_count >= 420 and h_count < 480 and
                    v_count >= 185 and v_count < 285 and
                    seg_on(seg_cs_units, h_count - 420, v_count - 185, 60, 100, 10)
                )
            );

        if video_on = '0' then
            vgaRed   <= "0000";
            vgaGreen <= "0000";
            vgaBlue  <= "0000";

        elsif test_state = FINISHED then

            if final_on then
                vgaRed   <= "1111";
                vgaGreen <= "1111";
                vgaBlue  <= "1111";
            else
                vgaRed   <= "0000";
                vgaGreen <= "0000";
                vgaBlue  <= "0000";
            end if;

        elsif top_on then

            vgaRed   <= "1111";
            vgaGreen <= "1111";
            vgaBlue  <= "1111";

        elsif ball1_on then

            vgaRed   <= "1111";
            vgaGreen <= "1111";
            vgaBlue  <= "1111";

        elsif ball2_on then

            vgaRed   <= "0000";
            vgaGreen <= "0000";
            vgaBlue  <= "1111";

        elsif path1_on or path2_on then

            vgaRed   <= "0000";
            vgaGreen <= "1111";
            vgaBlue  <= "0000";

        else

            if test_state = RUNNING and danger = '1' then
                vgaRed   <= "1111";
                vgaGreen <= "0000";
                vgaBlue  <= "0000";
            else
                vgaRed   <= "0000";
                vgaGreen <= "0000";
                vgaBlue  <= "0000";
            end if;

        end if;

    end process;

end Behavioral;