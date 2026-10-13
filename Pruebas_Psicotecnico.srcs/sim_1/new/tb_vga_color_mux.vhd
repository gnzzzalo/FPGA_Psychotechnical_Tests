library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_vga_color_mux is
end tb_vga_color_mux;

architecture Behavioral of tb_vga_color_mux is

    signal visible_tb      : std_logic := '0';
    signal final_screen_tb : std_logic := '0';

    signal in_ball_tb    : std_logic := '0';
    signal in_track_tb   : std_logic := '0';
    signal text_pixel_tb : std_logic := '0';

    signal vgaRed_tb   : std_logic_vector(3 downto 0);
    signal vgaGreen_tb : std_logic_vector(3 downto 0);
    signal vgaBlue_tb  : std_logic_vector(3 downto 0);

begin

    uut : entity work.vga_color_mux
        port map(
            visible      => visible_tb,
            final_screen => final_screen_tb,

            in_ball      => in_ball_tb,
            in_track     => in_track_tb,
            text_pixel   => text_pixel_tb,

            vgaRed       => vgaRed_tb,
            vgaGreen     => vgaGreen_tb,
            vgaBlue      => vgaBlue_tb
        );

    stim_process : process
    begin

        visible_tb      <= '0';
        final_screen_tb <= '0';
        in_ball_tb      <= '0';
        in_track_tb     <= '0';
        text_pixel_tb   <= '0';

        wait for 10 ns;

        assert vgaRed_tb = "0000" and vgaGreen_tb = "0000" and vgaBlue_tb = "0000"
            report "Error: con visible = 0 el color debe ser negro"
            severity error;

        visible_tb      <= '1';
        final_screen_tb <= '1';
        text_pixel_tb   <= '1';
        in_ball_tb      <= '0';
        in_track_tb     <= '0';

        wait for 10 ns;

        assert vgaRed_tb = "0000" and vgaGreen_tb = "0000" and vgaBlue_tb = "0000"
            report "Error: en pantalla final, text_pixel = 1 debe ser texto negro"
            severity error;

        visible_tb      <= '1';
        final_screen_tb <= '1';
        text_pixel_tb   <= '0';
        in_ball_tb      <= '0';
        in_track_tb     <= '0';

        wait for 10 ns;

        assert vgaRed_tb = "1111" and vgaGreen_tb = "1000" and vgaBlue_tb = "0000"
            report "Error: en pantalla final, sin texto debe ser fondo naranja"
            severity error;

        visible_tb      <= '1';
        final_screen_tb <= '0';
        text_pixel_tb   <= '0';
        in_ball_tb      <= '1';
        in_track_tb     <= '0';

        wait for 10 ns;

        assert vgaRed_tb = "1111" and vgaGreen_tb = "1000" and vgaBlue_tb = "0000"
            report "Error: la bola debe ser naranja"
            severity error;

        visible_tb      <= '1';
        final_screen_tb <= '0';
        text_pixel_tb   <= '0';
        in_ball_tb      <= '0';
        in_track_tb     <= '1';

        wait for 10 ns;

        assert vgaRed_tb = "1111" and vgaGreen_tb = "1111" and vgaBlue_tb = "1111"
            report "Error: el carril debe ser blanco"
            severity error;

        visible_tb      <= '1';
        final_screen_tb <= '0';
        text_pixel_tb   <= '0';
        in_ball_tb      <= '0';
        in_track_tb     <= '0';

        wait for 10 ns;

        assert vgaRed_tb = "1111" and vgaGreen_tb = "1000" and vgaBlue_tb = "0000"
            report "Error: el fondo normal debe ser naranja"
            severity error;

        visible_tb      <= '1';
        final_screen_tb <= '0';
        text_pixel_tb   <= '0';
        in_ball_tb      <= '1';
        in_track_tb     <= '1';

        wait for 10 ns;

        assert vgaRed_tb = "1111" and vgaGreen_tb = "1000" and vgaBlue_tb = "0000"
            report "Error: si bola y carril coinciden, debe ganar la bola naranja"
            severity error;

        report "Testbench de vga_color_mux finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;