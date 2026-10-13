library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ball_motion is
    generic(
        SCREEN_W : integer := 640;
        TRACK_X0 : integer := 0;
        TRACK_X1 : integer := 520;
        BALL_R   : integer := 14
    );
    port(
        clk       : in  std_logic;
        reset_all : in  std_logic;
        start     : in  std_logic;
        running   : in  std_logic;
        move_tick : in  std_logic;
        frame_end : in  std_logic;

        ball_x    : out integer range 0 to 799;
        ball_done : out std_logic
    );
end ball_motion;

architecture Behavioral of ball_motion is

    constant BALL_START_X : integer := TRACK_X0 + BALL_R;

    constant BALL_END_X : integer := SCREEN_W - BALL_R;

    signal ball_x_s : integer range 0 to 799 := BALL_START_X;
    signal done_s   : std_logic := '0';

    signal pending_move : integer range 0 to 20 := 0;

begin

    process(clk)
        variable next_pending : integer range 0 to 20;
        variable next_x       : integer;
    begin
        if rising_edge(clk) then

            next_pending := pending_move;

            if reset_all = '1' then
                ball_x_s <= BALL_START_X;
                done_s <= '0';
                pending_move <= 0;

            elsif start = '1' then
                ball_x_s <= BALL_START_X;
                done_s <= '0';
                pending_move <= 0;

            else

                if running = '1' and done_s = '0' and move_tick = '1' then
                    if next_pending < 20 then
                        next_pending := next_pending + 1;
                    end if;
                end if;

                if frame_end = '1' then
                    if next_pending > 0 and running = '1' and done_s = '0' then

                        next_x := ball_x_s + next_pending;

                        if next_x >= BALL_END_X then
                            ball_x_s <= BALL_END_X;
                            done_s <= '1';
                        else
                            ball_x_s <= next_x;
                        end if;

                        next_pending := 0;
                    end if;
                end if;

                pending_move <= next_pending;

            end if;

        end if;
    end process;

    ball_x <= ball_x_s;
    ball_done <= done_s;

end Behavioral;