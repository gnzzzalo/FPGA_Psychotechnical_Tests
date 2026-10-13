library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_sync is
    port(
        clk       : in  std_logic;
        reset     : in  std_logic;

        h_count   : out integer range 0 to 799;
        v_count   : out integer range 0 to 524;

        visible   : out std_logic;
        frame_end : out std_logic;

        Hsync     : out std_logic;
        Vsync     : out std_logic
    );
end vga_sync;

architecture Behavioral of vga_sync is

    signal div_cnt  : unsigned(1 downto 0) := (others => '0');
    signal pixel_ce : std_logic := '0';

    signal h_aux : integer range 0 to 799 := 0;
    signal v_aux : integer range 0 to 524 := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                div_cnt <= (others => '0');
                pixel_ce <= '0';
            else
                div_cnt <= div_cnt + 1;

                if div_cnt = "11" then
                    pixel_ce <= '1';
                else
                    pixel_ce <= '0';
                end if;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                h_aux <= 0;
                v_aux <= 0;

            elsif pixel_ce = '1' then

                if h_aux = 799 then
                    h_aux <= 0;

                    if v_aux = 524 then
                        v_aux <= 0;
                    else
                        v_aux <= v_aux + 1;
                    end if;

                else
                    h_aux <= h_aux + 1;
                end if;

            end if;
        end if;
    end process;

    h_count <= h_aux;
    v_count <= v_aux;

    visible <= '1' when h_aux < 640 and v_aux < 480 else '0';

    frame_end <= '1' when pixel_ce = '1' and h_aux = 799 and v_aux = 524 else '0';

    Hsync <= '0' when h_aux >= 656 and h_aux < 752 else '1';
    Vsync <= '0' when v_aux >= 490 and v_aux < 492 else '1';

end Behavioral;