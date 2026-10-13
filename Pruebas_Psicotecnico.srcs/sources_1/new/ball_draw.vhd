library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ball_draw is
    generic(
        SCREEN_H : integer := 480;
        BALL_R   : integer := 14
    );
    port(
        h_count : in  integer range 0 to 799;
        v_count : in  integer range 0 to 524;
        ball_x  : in  integer range 0 to 799;

        in_ball : out std_logic
    );
end ball_draw;

architecture Behavioral of ball_draw is

    constant BALL_Y : integer := SCREEN_H / 2;

begin

    process(h_count, v_count, ball_x)
        variable dx_abs : integer;
        variable dy_abs : integer;
    begin

        if h_count >= ball_x then
            dx_abs := h_count - ball_x;
        else
            dx_abs := ball_x - h_count;
        end if;

        if v_count >= BALL_Y then
            dy_abs := v_count - BALL_Y;
        else
            dy_abs := BALL_Y - v_count;
        end if;

        if dx_abs <= BALL_R and
           dy_abs <= BALL_R and
           dx_abs + dy_abs <= BALL_R + (BALL_R / 2) then
            in_ball <= '1';
        else
            in_ball <= '0';
        end if;

    end process;

end Behavioral;