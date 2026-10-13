library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_vga_results_draw is
end tb_vga_results_draw;

architecture Behavioral of tb_vga_results_draw is

    constant WIDTH      : integer := 16;
    constant FONT_SCALE : integer := 5;
    constant TEXT_X0    : integer := 245;
    constant TEXT_Y0    : integer := 160;
    constant TEXT_ROW_H : integer := 70;

    signal h_count_tb      : integer range 0 to 799 := 0;
    signal v_count_tb      : integer range 0 to 524 := 0;
    signal visible_tb      : std_logic := '0';
    signal final_screen_tb : std_logic := '0';

    signal result0_tb : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal result1_tb : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal result2_tb : std_logic_vector(WIDTH-1 downto 0) := (others => '0');

    signal neg0_tb : std_logic := '0';
    signal neg1_tb : std_logic := '0';
    signal neg2_tb : std_logic := '0';

    signal fail0_tb : std_logic := '0';
    signal fail1_tb : std_logic := '0';
    signal fail2_tb : std_logic := '0';

    signal text_pixel_tb : std_logic;

begin

    uut : entity work.vga_results_draw
        generic map(
            WIDTH      => WIDTH,
            FONT_SCALE => FONT_SCALE,
            TEXT_X0    => TEXT_X0,
            TEXT_Y0    => TEXT_Y0,
            TEXT_ROW_H => TEXT_ROW_H
        )
        port map(
            h_count      => h_count_tb,
            v_count      => v_count_tb,
            visible      => visible_tb,
            final_screen => final_screen_tb,

            result0      => result0_tb,
            result1      => result1_tb,
            result2      => result2_tb,

            neg0         => neg0_tb,
            neg1         => neg1_tb,
            neg2         => neg2_tb,

            fail0        => fail0_tb,
            fail1        => fail1_tb,
            fail2        => fail2_tb,

            text_pixel   => text_pixel_tb
        );

    stim_process : process
    begin

        result0_tb <= std_logic_vector(to_unsigned(123, WIDTH));
        result1_tb <= std_logic_vector(to_unsigned(45, WIDTH));
        result2_tb <= std_logic_vector(to_unsigned(7, WIDTH));

        neg0_tb <= '1';
        neg1_tb <= '0';
        neg2_tb <= '0';

        fail0_tb <= '0';
        fail1_tb <= '1';
        fail2_tb <= '0';

        visible_tb <= '1';
        final_screen_tb <= '0';

        h_count_tb <= TEXT_X0;
        v_count_tb <= TEXT_Y0;

        wait for 10 ns;

        assert text_pixel_tb = '0'
            report "Error: con final_screen = 0 no deberia dibujar texto"
            severity error;

        final_screen_tb <= '1';
        visible_tb <= '0';

        wait for 10 ns;

        assert text_pixel_tb = '0'
            report "Error: con visible = 0 no deberia dibujar texto"
            severity error;

        visible_tb <= '1';

        wait for 10 ns;

        h_count_tb <= TEXT_X0;
        v_count_tb <= TEXT_Y0 + 15;

        wait for 10 ns;

        assert text_pixel_tb = '1'
            report "Error: result0 negativo deberia dibujar signo menos"
            severity error;

        h_count_tb <= TEXT_X0 + 30;
        v_count_tb <= TEXT_Y0;

        wait for 10 ns;

        assert text_pixel_tb = '0'
            report "Error: primer pixel de la fila superior del numero 1 deberia ser 0"
            severity error;

        h_count_tb <= TEXT_X0 + 30 + 10;
        v_count_tb <= TEXT_Y0;

        wait for 10 ns;

        assert text_pixel_tb = '1'
            report "Error: pixel central superior del numero 1 deberia ser 1"
            severity error;

        h_count_tb <= TEXT_X0 + 60 + 10;
        v_count_tb <= TEXT_Y0 + 30;

        wait for 10 ns;

        assert text_pixel_tb = '1'
            report "Error: el punto decimal de result0 deberia dibujarse"
            severity error;

        h_count_tb <= TEXT_X0 + 30;
        v_count_tb <= TEXT_Y0 + TEXT_ROW_H;

        wait for 10 ns;

        assert text_pixel_tb = '1'
            report "Error: fail1 deberia dibujar la F en la segunda linea"
            severity error;

        h_count_tb <= TEXT_X0 + 60;
        v_count_tb <= TEXT_Y0 + TEXT_ROW_H;

        wait for 10 ns;

        assert text_pixel_tb = '0'
            report "Error: primer pixel superior de la A deberia ser 0"
            severity error;

        h_count_tb <= TEXT_X0 + 60 + 5;
        v_count_tb <= TEXT_Y0 + TEXT_ROW_H;

        wait for 10 ns;

        assert text_pixel_tb = '1'
            report "Error: zona superior de la A deberia dibujarse"
            severity error;

        h_count_tb <= TEXT_X0 + 120;
        v_count_tb <= TEXT_Y0 + (2 * TEXT_ROW_H);

        wait for 10 ns;

        assert text_pixel_tb = '1'
            report "Error: result2 deberia dibujar la cifra de centesimas"
            severity error;

        h_count_tb <= TEXT_X0 + 200;
        v_count_tb <= TEXT_Y0;

        wait for 10 ns;

        assert text_pixel_tb = '0'
            report "Error: fuera de la zona horizontal del texto no deberia dibujar"
            severity error;

        h_count_tb <= TEXT_X0;
        v_count_tb <= TEXT_Y0 + 250;

        wait for 10 ns;

        assert text_pixel_tb = '0'
            report "Error: fuera de la zona vertical del texto no deberia dibujar"
            severity error;

        report "Testbench de vga_results_draw finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;