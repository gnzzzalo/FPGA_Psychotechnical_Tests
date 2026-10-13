library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_leds is
end tb_leds;

architecture Behavioral of tb_leds is

    constant CLK_FREQ_HZ           : integer := 4000;
    constant WIDTH                 : integer := 16;
    constant DEBOUNCE_STABLE_COUNT : integer := 2;
    constant MIN_COUNT             : integer := 1;
    constant MAX_COUNT             : integer := 31;

    signal clk_tb  : std_logic := '0';
    signal btnC_tb : std_logic := '0';
    signal btnU_tb : std_logic := '0';
    signal swt_tb  : std_logic_vector(0 downto 0) := "0";

    signal vgaRed_tb   : std_logic_vector(3 downto 0);
    signal vgaGreen_tb : std_logic_vector(3 downto 0);
    signal vgaBlue_tb  : std_logic_vector(3 downto 0);
    signal Hsync_tb    : std_logic;
    signal Vsync_tb    : std_logic;

    signal seg_tb : std_logic_vector(6 downto 0);
    signal an_tb  : std_logic_vector(3 downto 0);
    signal dp_tb  : std_logic;

begin

    uut : entity work.leds
        generic map(
            CLK_FREQ_HZ           => CLK_FREQ_HZ,
            WIDTH                 => WIDTH,
            DEBOUNCE_STABLE_COUNT => DEBOUNCE_STABLE_COUNT,
            MIN_COUNT             => MIN_COUNT,
            MAX_COUNT             => MAX_COUNT
        )
        port map(
            clk      => clk_tb,
            btnC     => btnC_tb,
            btnU     => btnU_tb,
            swt      => swt_tb,

            vgaRed   => vgaRed_tb,
            vgaGreen => vgaGreen_tb,
            vgaBlue  => vgaBlue_tb,
            Hsync    => Hsync_tb,
            Vsync    => Vsync_tb,

            seg      => seg_tb,
            an       => an_tb,
            dp       => dp_tb
        );

    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for 5 ns;
            clk_tb <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_process : process
        variable hsync_low_seen : boolean := false;
        variable color_seen     : boolean := false;
    begin

        swt_tb(0) <= '1';
        btnC_tb <= '0';
        btnU_tb <= '0';

        for i in 1 to 30 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert vgaRed_tb = "0000" and vgaGreen_tb = "0000" and vgaBlue_tb = "0000"
            report "Error: con swt(0)=1, la salida VGA deberia estar en negro"
            severity error;

        assert an_tb = "1111"
            report "Error: en reset/reposo, los anodos del display deberian estar apagados"
            severity error;

        assert seg_tb = "1111111"
            report "Error: en reset/reposo, los segmentos deberian estar apagados"
            severity error;

        hsync_low_seen := false;

        for i in 1 to 4000 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            assert vgaRed_tb = "0000" and vgaGreen_tb = "0000" and vgaBlue_tb = "0000"
                report "Error: durante reset, la pantalla deberia mantenerse negra"
                severity error;

            if Hsync_tb = '0' then
                hsync_low_seen := true;
            end if;
        end loop;

        assert hsync_low_seen = true
            report "Error: Hsync deberia seguir funcionando aunque swt(0)=1"
            severity error;

        swt_tb(0) <= '0';

        for i in 1 to 30 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        color_seen := false;

        for i in 1 to 3000 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if vgaRed_tb /= "0000" or vgaGreen_tb /= "0000" or vgaBlue_tb /= "0000" then
                color_seen := true;
            end if;
        end loop;

        assert color_seen = true
            report "Error: al quitar reset, deberia aparecer color VGA en algun momento"
            severity error;

        assert an_tb = "1111"
            report "Error: antes de mostrar resultado, el display deberia seguir apagado"
            severity error;

        btnC_tb <= '1';

        for i in 1 to 20 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        btnC_tb <= '0';

        for i in 1 to 20 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert vgaRed_tb /= "UUUU" and vgaGreen_tb /= "UUUU" and vgaBlue_tb /= "UUUU"
            report "Error: despues de pulsar btnC, las salidas VGA no deberian quedar indefinidas"
            severity error;

        btnU_tb <= '1';

        for i in 1 to 20 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        btnU_tb <= '0';

        for i in 1 to 20 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert an_tb = "1111"
            report "Error: pulsar btnU fuera de un resultado no deberia encender el display"
            severity error;

        swt_tb(0) <= '1';

        for i in 1 to 30 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert vgaRed_tb = "0000" and vgaGreen_tb = "0000" and vgaBlue_tb = "0000"
            report "Error: al volver a activar reset, VGA deberia volver a negro"
            severity error;

        assert an_tb = "1111"
            report "Error: al volver a activar reset, el display deberia apagarse"
            severity error;

        report "Testbench de leds finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;