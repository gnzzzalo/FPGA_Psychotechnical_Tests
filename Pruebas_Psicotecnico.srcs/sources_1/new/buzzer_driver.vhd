library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.psicotecnico_pkg.all;

entity buzzer_driver is
    Port (
        clk25      : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        locked     : in  STD_LOGIC;

        danger     : in  STD_LOGIC;
        test_state : in  test_state_type;

        buzzer_out : out STD_LOGIC
    );
end buzzer_driver;

architecture Behavioral of buzzer_driver is

    signal tone_cnt   : integer range 0 to TONE_HALF_CYC-1 := 0;
    signal buzzer_reg : STD_LOGIC := '0';

begin

    process(clk25)
    begin
        if rising_edge(clk25) then

            if rst = '1' or locked = '0' then
                tone_cnt   <= 0;
                buzzer_reg <= '0';

            else

                if danger = '1' and test_state = RUNNING then

                    if tone_cnt = TONE_HALF_CYC - 1 then
                        tone_cnt   <= 0;
                        buzzer_reg <= not buzzer_reg;
                    else
                        tone_cnt <= tone_cnt + 1;
                    end if;

                else
                    tone_cnt   <= 0;
                    buzzer_reg <= '0';
                end if;

            end if;
        end if;
    end process;

    buzzer_out <= buzzer_reg;

end Behavioral;