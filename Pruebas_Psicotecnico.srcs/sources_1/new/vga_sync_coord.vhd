library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.psicotecnico_pkg.all;

entity vga_sync_coord is
    Port (
        clk25      : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        locked     : in  STD_LOGIC;

        h_count    : out integer range 0 to HT-1;
        v_count    : out integer range 0 to VT-1;

        video_on   : out STD_LOGIC;
        frame_tick : out STD_LOGIC;

        Hsync      : out STD_LOGIC;
        Vsync      : out STD_LOGIC
    );
end vga_sync_coord;

architecture Behavioral of vga_sync_coord is

    signal h_reg : integer range 0 to HT-1 := 0;
    signal v_reg : integer range 0 to VT-1 := 0;

begin

    process(clk25)
    begin
        if rising_edge(clk25) then
            if rst = '1' or locked = '0' then
                h_reg <= 0;
                v_reg <= 0;

            else
                if h_reg = HT - 1 then
                    h_reg <= 0;

                    if v_reg = VT - 1 then
                        v_reg <= 0;
                    else
                        v_reg <= v_reg + 1;
                    end if;

                else
                    h_reg <= h_reg + 1;
                end if;
            end if;
        end if;
    end process;

    h_count <= h_reg;
    v_count <= v_reg;

    video_on <= '1' when h_reg < HD and v_reg < VD else '0';

    Hsync <= '0' when h_reg >= HD + HF and h_reg < HD + HF + HS else '1';
    Vsync <= '0' when v_reg >= VD + VF and v_reg < VD + VF + VS else '1';

    frame_tick <= '1' when h_reg = 0 and v_reg = 0 else '0';

end Behavioral;