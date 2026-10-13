library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity psicotecnico_top is
    Port (
        clk          : in  STD_LOGIC;

        -- Reset general
        rst          : in  STD_LOGIC;

        -- Botón de inicio común
        start_btn    : in  STD_LOGIC;

        -- Botón de reacción para anticipación temporal
        reaction_btn : in  STD_LOGIC;

        -- Selector de prueba:
        -- 0 = coordinación psicomotriz
        -- 1 = anticipación temporal original
        test_sel     : in  STD_LOGIC;

        -- Joysticks de coordinación
        -- Joystick 1: JC(0) a JC(3)
        -- Joystick 2: JC(4) a JC(7)
        JC           : in  STD_LOGIC_VECTOR(7 downto 0);

        -- VGA final
        vgaRed       : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen     : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue      : out STD_LOGIC_VECTOR(3 downto 0);
        Hsync        : out STD_LOGIC;
        Vsync        : out STD_LOGIC;

        -- Display 7 segmentos final
        seg          : out STD_LOGIC_VECTOR(6 downto 0);
        an           : out STD_LOGIC_VECTOR(3 downto 0);
        dp           : out STD_LOGIC;

        -- Salidas extra
        led_fail     : out STD_LOGIC;
        buzzer_out   : out STD_LOGIC
    );
end psicotecnico_top;

architecture Structural of psicotecnico_top is

    --------------------------------------------------------------------
    -- Enables exclusivos
    --------------------------------------------------------------------
    signal coord_enable : STD_LOGIC;
    signal ant_enable   : STD_LOGIC;

    --------------------------------------------------------------------
    -- Señales de coordinación agrupadas
    --------------------------------------------------------------------
    signal coord_vgaRed   : STD_LOGIC_VECTOR(3 downto 0);
    signal coord_vgaGreen : STD_LOGIC_VECTOR(3 downto 0);
    signal coord_vgaBlue  : STD_LOGIC_VECTOR(3 downto 0);

    signal coord_Hsync : STD_LOGIC;
    signal coord_Vsync : STD_LOGIC;

    signal coord_buzzer : STD_LOGIC;
    signal coord_danger : STD_LOGIC;

    --------------------------------------------------------------------
    -- Señales anticipación temporal original
    --------------------------------------------------------------------
    signal ant_vgaRed   : STD_LOGIC_VECTOR(3 downto 0);
    signal ant_vgaGreen : STD_LOGIC_VECTOR(3 downto 0);
    signal ant_vgaBlue  : STD_LOGIC_VECTOR(3 downto 0);

    signal ant_Hsync : STD_LOGIC;
    signal ant_Vsync : STD_LOGIC;

    signal ant_seg : STD_LOGIC_VECTOR(6 downto 0);
    signal ant_an  : STD_LOGIC_VECTOR(3 downto 0);
    signal ant_dp  : STD_LOGIC;

    --------------------------------------------------------------------
    -- Reset para la prueba original de anticipación
    --
    -- En la prueba original, el reset entraba como swt(0).
    -- Cuando test_sel = 0, anticipación se mantiene reseteada.
    -- Cuando rst = 1, también se resetea.
    --------------------------------------------------------------------
    signal ant_swt : STD_LOGIC_VECTOR(0 downto 0);

begin

    --------------------------------------------------------------------
    -- Selección exclusiva
    --------------------------------------------------------------------
    coord_enable <= not test_sel;
    ant_enable   <= test_sel;

    --------------------------------------------------------------------
    -- Reset interno de anticipación original
    --------------------------------------------------------------------
    ant_swt(0) <= rst or (not ant_enable);

    --------------------------------------------------------------------
    -- Bloque completo de coordinación psicomotriz
    --------------------------------------------------------------------
    U_COORDINACION : entity work.coordinacion
        port map (
            clk       => clk,
            rst       => rst,
            enable    => coord_enable,

            start_btn => start_btn,
            JC        => JC,

            vgaRed    => coord_vgaRed,
            vgaGreen  => coord_vgaGreen,
            vgaBlue   => coord_vgaBlue,
            Hsync     => coord_Hsync,
            Vsync     => coord_Vsync,

            buzzer_out => coord_buzzer,
            led_fail   => coord_danger
        );

    --------------------------------------------------------------------
    -- Prueba de anticipación temporal original
    --
    -- Esta parte usa directamente el top original "leds".
    -- No se modifica su lógica interna.
    --------------------------------------------------------------------
    U_ANTICIPACION : entity work.leds
        generic map (
            CLK_FREQ_HZ           => 100000000,
            WIDTH                 => 16,
            DEBOUNCE_STABLE_COUNT => 1_000_000,
            MIN_COUNT             => 326797  - 1,
            MAX_COUNT             => 1470588 - 1
        )
        port map (
            clk  => clk,

            -- En la prueba original:
            -- btnC = inicio
            -- btnU = reacción
            -- swt(0) = reset
            btnC => start_btn,
            btnU => reaction_btn,
            swt  => ant_swt,

            vgaRed   => ant_vgaRed,
            vgaGreen => ant_vgaGreen,
            vgaBlue  => ant_vgaBlue,
            Hsync    => ant_Hsync,
            Vsync    => ant_Vsync,

            seg => ant_seg,
            an  => ant_an,
            dp  => ant_dp
        );

    --------------------------------------------------------------------
    -- Selector final de salidas
    --------------------------------------------------------------------
    U_SELECTOR : entity work.test_selector
        port map (
            test_sel => test_sel,

            coord_vgaRed   => coord_vgaRed,
            coord_vgaGreen => coord_vgaGreen,
            coord_vgaBlue  => coord_vgaBlue,
            coord_Hsync    => coord_Hsync,
            coord_Vsync    => coord_Vsync,
            coord_buzzer   => coord_buzzer,
            coord_led_fail => coord_danger,

            ant_vgaRed   => ant_vgaRed,
            ant_vgaGreen => ant_vgaGreen,
            ant_vgaBlue  => ant_vgaBlue,
            ant_Hsync    => ant_Hsync,
            ant_Vsync    => ant_Vsync,
            ant_seg      => ant_seg,
            ant_an       => ant_an,
            ant_dp       => ant_dp,

            vgaRed   => vgaRed,
            vgaGreen => vgaGreen,
            vgaBlue  => vgaBlue,
            Hsync    => Hsync,
            Vsync    => Vsync,

            seg => seg,
            an  => an,
            dp  => dp,

            buzzer_out => buzzer_out,
            led_fail   => led_fail
        );

end Structural;