library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_selector is
    Port (
        test_sel : in STD_LOGIC;

        coord_vgaRed   : in STD_LOGIC_VECTOR(3 downto 0);
        coord_vgaGreen : in STD_LOGIC_VECTOR(3 downto 0);
        coord_vgaBlue  : in STD_LOGIC_VECTOR(3 downto 0);
        coord_Hsync    : in STD_LOGIC;
        coord_Vsync    : in STD_LOGIC;
        coord_buzzer   : in STD_LOGIC;
        coord_led_fail : in STD_LOGIC;

        ant_vgaRed     : in STD_LOGIC_VECTOR(3 downto 0);
        ant_vgaGreen   : in STD_LOGIC_VECTOR(3 downto 0);
        ant_vgaBlue    : in STD_LOGIC_VECTOR(3 downto 0);
        ant_Hsync      : in STD_LOGIC;
        ant_Vsync      : in STD_LOGIC;
        ant_seg        : in STD_LOGIC_VECTOR(6 downto 0);
        ant_an         : in STD_LOGIC_VECTOR(3 downto 0);
        ant_dp         : in STD_LOGIC;

        vgaRed     : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen   : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue    : out STD_LOGIC_VECTOR(3 downto 0);
        Hsync      : out STD_LOGIC;
        Vsync      : out STD_LOGIC;

        seg        : out STD_LOGIC_VECTOR(6 downto 0);
        an         : out STD_LOGIC_VECTOR(3 downto 0);
        dp         : out STD_LOGIC;

        buzzer_out : out STD_LOGIC;
        led_fail   : out STD_LOGIC
    );
end test_selector;

architecture Behavioral of test_selector is
begin

    process(
        test_sel,

        coord_vgaRed, coord_vgaGreen, coord_vgaBlue,
        coord_Hsync, coord_Vsync,
        coord_buzzer, coord_led_fail,

        ant_vgaRed, ant_vgaGreen, ant_vgaBlue,
        ant_Hsync, ant_Vsync,
        ant_seg, ant_an, ant_dp
    )
    begin

        if test_sel = '0' then

            -- Coordinación activa
            vgaRed   <= coord_vgaRed;
            vgaGreen <= coord_vgaGreen;
            vgaBlue  <= coord_vgaBlue;
            Hsync    <= coord_Hsync;
            Vsync    <= coord_Vsync;

            -- Display apagado durante coordinación
            seg <= "1111111";
            an  <= "1111";
            dp  <= '1';

            buzzer_out <= coord_buzzer;
            led_fail   <= coord_led_fail;

        else

            -- Anticipación original activa
            vgaRed   <= ant_vgaRed;
            vgaGreen <= ant_vgaGreen;
            vgaBlue  <= ant_vgaBlue;
            Hsync    <= ant_Hsync;
            Vsync    <= ant_Vsync;

            seg <= ant_seg;
            an  <= ant_an;
            dp  <= ant_dp;

            -- Tu prueba de anticipación original no usa buzzer
            buzzer_out <= '0';
            led_fail   <= '0';

        end if;

    end process;

end Behavioral;