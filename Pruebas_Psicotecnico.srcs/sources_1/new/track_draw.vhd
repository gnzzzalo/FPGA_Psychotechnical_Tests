library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity track_draw is
    generic(
        SCREEN_H : integer := 480;
        TRACK_X0 : integer := 0;
        TRACK_X1 : integer := 520;
        TRACK_H  : integer := 130
    );
    port(
        h_count  : in  integer range 0 to 799;
        v_count  : in  integer range 0 to 524;

        in_track : out std_logic
    );
end track_draw;

architecture Behavioral of track_draw is

    constant TRACK_Y0 : integer := (SCREEN_H - TRACK_H) / 2;
    constant TRACK_Y1 : integer := TRACK_Y0 + TRACK_H;

begin

    process(h_count, v_count)
    begin

        if h_count >= TRACK_X0 and h_count < TRACK_X1 and
           v_count >= TRACK_Y0 and v_count < TRACK_Y1 then
            in_track <= '1';
        else
            in_track <= '0';
        end if;

    end process;

end Behavioral;