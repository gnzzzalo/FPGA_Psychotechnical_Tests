library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_7seg_R is
    generic(
        CLK_FREQ_HZ : integer := 100000000;
        WIDTH       : integer := 16
    );
    port(
        clk          : in  std_logic;
        value_cs     : in  std_logic_vector(WIDTH-1 downto 0);
        display_mode : in  std_logic_vector(1 downto 0);
        negative     : in  std_logic;

        seg          : out std_logic_vector(6 downto 0);
        an           : out std_logic_vector(3 downto 0);
        dp           : out std_logic
    );
end display_7seg_R;

architecture Behavioral of display_7seg_R is

    constant REFRESH_COUNT : integer := CLK_FREQ_HZ / 4000;

    signal refresh_counter : integer range 0 to REFRESH_COUNT-1 := 0;
    signal digit_sel       : unsigned(1 downto 0) := (others => '0');

    signal value_u : unsigned(WIDTH-1 downto 0);

    signal seconds_digit    : integer range 0 to 9 := 0;
    signal tenths_digit     : integer range 0 to 9 := 0;
    signal hundredths_digit : integer range 0 to 9 := 0;

    signal current_digit : integer range 0 to 9 := 0;
    signal current_char  : std_logic_vector(2 downto 0) := "000";

begin

    value_u <= unsigned(value_cs);

    process(value_u)
        variable aux : integer;
    begin
        aux := to_integer(value_u);

        seconds_digit    <= (aux / 100) mod 10;
        tenths_digit     <= (aux / 10) mod 10;
        hundredths_digit <= aux mod 10;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if refresh_counter = REFRESH_COUNT - 1 then
                refresh_counter <= 0;
                digit_sel <= digit_sel + 1;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;

    process(digit_sel, display_mode, negative, seconds_digit, tenths_digit, hundredths_digit)
    begin
        an <= "1111";
        dp <= '1';

        current_digit <= 0;
        current_char  <= "000";

        case display_mode is

            when "00" =>
                an <= "1111";
                current_char <= "000";

            when "01" =>
                case digit_sel is

                    when "00" =>
                        an <= "1110";
                        current_digit <= hundredths_digit;
                        current_char <= "001";
                        dp <= '1';

                    when "01" =>
                        an <= "1101";
                        current_digit <= tenths_digit;
                        current_char <= "001";
                        dp <= '1';

                    when "10" =>
                        an <= "1011";
                        current_digit <= seconds_digit;
                        current_char <= "001";
                        dp <= '0';

                    when others =>
                        an <= "0111";

                        if negative = '1' then
                            current_char <= "010";
                        else
                            current_char <= "000";
                        end if;

                        dp <= '1';

                end case;

            when others =>
                case digit_sel is

                    when "00" =>
                        an <= "1110";
                        current_char <= "110";
                    when "01" =>
                        an <= "1101";
                        current_char <= "101";
                    when "10" =>
                        an <= "1011";
                        current_char <= "100";
                    when others =>
                        an <= "0111";
                        current_char <= "011";
                end case;

                dp <= '1';

        end case;
    end process;

    process(current_digit, current_char)
    begin
        case current_char is

            when "000" =>
                seg <= "1111111";

            when "001" =>
                case current_digit is
                    when 0 => seg <= "1000000";
                    when 1 => seg <= "1111001";
                    when 2 => seg <= "0100100";
                    when 3 => seg <= "0110000";
                    when 4 => seg <= "0011001";
                    when 5 => seg <= "0010010";
                    when 6 => seg <= "0000010";
                    when 7 => seg <= "1111000";
                    when 8 => seg <= "0000000";
                    when 9 => seg <= "0010000";
                    when others => seg <= "1111111";
                end case;

            when "010" =>
                seg <= "0111111";
            when "011" =>
                seg <= "0001110";
            when "100" =>
                seg <= "0001000";
            when "101" =>
                seg <= "1111001";
            when "110" =>
                seg <= "1000111";
            when others =>
                seg <= "1111111";

        end case;
    end process;

end Behavioral;