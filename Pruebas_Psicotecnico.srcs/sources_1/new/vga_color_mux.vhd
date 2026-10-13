library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_color_mux is
    port(
        visible      : in  std_logic;
        final_screen : in  std_logic;

        in_ball      : in  std_logic;
        in_track     : in  std_logic;
        text_pixel   : in  std_logic;

        vgaRed       : out std_logic_vector(3 downto 0);
        vgaGreen     : out std_logic_vector(3 downto 0);
        vgaBlue      : out std_logic_vector(3 downto 0)
    );
end vga_color_mux;

architecture Behavioral of vga_color_mux is
begin

    process(visible, final_screen, in_ball, in_track, text_pixel)
    begin

        if visible = '0' then
        --negro
            vgaRed   <= "0000";
            vgaGreen <= "0000";
            vgaBlue  <= "0000";

        elsif final_screen = '1' then

            if text_pixel = '1' then
            -- Texto negro
                vgaRed   <= "0000";
                vgaGreen <= "0000";
                vgaBlue  <= "0000";
            else
            -- Fondo naranja
                vgaRed   <= "1111";
                vgaGreen <= "1000";
                vgaBlue  <= "0000";
            end if;

        else

            if in_ball = '1' then
            --naranja
                vgaRed   <= "1111";
                vgaGreen <= "1000";
                vgaBlue  <= "0000";

            elsif in_track = '1' then
            --blanco
                vgaRed   <= "1111";
                vgaGreen <= "1111";
                vgaBlue  <= "1111";

            else
            --naranja
                vgaRed   <= "1111";
                vgaGreen <= "1000";
                vgaBlue  <= "0000";
            end if;

        end if;

    end process;

end Behavioral;