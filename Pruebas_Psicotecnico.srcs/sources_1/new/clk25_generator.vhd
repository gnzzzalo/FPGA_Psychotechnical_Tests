library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity clk25_generator is
    Port (
        clk100 : in  STD_LOGIC;
        rst    : in  STD_LOGIC;

        clk25  : out STD_LOGIC;
        locked : out STD_LOGIC
    );
end clk25_generator;

architecture Behavioral of clk25_generator is

    signal clk25_mmcm : STD_LOGIC;
    signal clkfb      : STD_LOGIC;
    signal clkfb_buf  : STD_LOGIC;
    signal locked_int : STD_LOGIC;

begin

    CLKFB_BUFG : BUFG
        port map (
            I => clkfb,
            O => clkfb_buf
        );

    CLK25_BUFG : BUFG
        port map (
            I => clk25_mmcm,
            O => clk25
        );

    MMCM_CLK25 : MMCME2_BASE
        generic map (
            BANDWIDTH          => "OPTIMIZED",
            CLKFBOUT_MULT_F    => 10.0,
            CLKFBOUT_PHASE     => 0.0,
            CLKIN1_PERIOD      => 10.0,

            CLKOUT0_DIVIDE_F   => 40.0,
            CLKOUT0_DUTY_CYCLE => 0.5,
            CLKOUT0_PHASE      => 0.0,

            DIVCLK_DIVIDE      => 1,
            STARTUP_WAIT       => FALSE
        )
        port map (
            CLKIN1    => clk100,
            CLKFBIN   => clkfb_buf,
            CLKFBOUT  => clkfb,

            CLKOUT0   => clk25_mmcm,

            CLKFBOUTB => open,
            CLKOUT0B  => open,
            CLKOUT1   => open,
            CLKOUT1B  => open,
            CLKOUT2   => open,
            CLKOUT2B  => open,
            CLKOUT3   => open,
            CLKOUT3B  => open,
            CLKOUT4   => open,
            CLKOUT5   => open,
            CLKOUT6   => open,

            LOCKED    => locked_int,

            PWRDWN    => '0',
            RST       => rst
        );

    locked <= locked_int;

end Behavioral;