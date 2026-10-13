library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fuentes is
    port(
        char_code : in  integer range 0 to 16;
        row       : in  integer range 0 to 6;
        col       : in  integer range 0 to 4;
        pixel     : out std_logic
    );
end fuentes;

architecture Behavioral of fuentes is
begin

    process(char_code, row, col)
        variable bits : std_logic_vector(4 downto 0);
    begin

        bits := "00000";

        case char_code is
--(vacio)
            when 0 =>
                bits := "00000";
--0
            when 1 =>
                case row is
                    when 0 => bits := "01110";
                    when 1 => bits := "10001";
                    when 2 => bits := "10011";
                    when 3 => bits := "10101";
                    when 4 => bits := "11001";
                    when 5 => bits := "10001";
                    when 6 => bits := "01110";
                    when others => bits := "00000";
                end case;
--1
            when 2 =>
                case row is
                    when 0 => bits := "00100";
                    when 1 => bits := "01100";
                    when 2 => bits := "00100";
                    when 3 => bits := "00100";
                    when 4 => bits := "00100";
                    when 5 => bits := "00100";
                    when 6 => bits := "01110";
                    when others => bits := "00000";
                end case;
--2
            when 3 =>
                case row is
                    when 0 => bits := "01110";
                    when 1 => bits := "10001";
                    when 2 => bits := "00001";
                    when 3 => bits := "00010";
                    when 4 => bits := "00100";
                    when 5 => bits := "01000";
                    when 6 => bits := "11111";
                    when others => bits := "00000";
                end case;
--3
            when 4 =>
                case row is
                    when 0 => bits := "11110";
                    when 1 => bits := "00001";
                    when 2 => bits := "00001";
                    when 3 => bits := "01110";
                    when 4 => bits := "00001";
                    when 5 => bits := "00001";
                    when 6 => bits := "11110";
                    when others => bits := "00000";
                end case;
--4
            when 5 =>
                case row is
                    when 0 => bits := "10010";
                    when 1 => bits := "10010";
                    when 2 => bits := "10010";
                    when 3 => bits := "11111";
                    when 4 => bits := "00010";
                    when 5 => bits := "00010";
                    when 6 => bits := "00010";
                    when others => bits := "00000";
                end case;
--5
            when 6 =>
                case row is
                    when 0 => bits := "11111";
                    when 1 => bits := "10000";
                    when 2 => bits := "10000";
                    when 3 => bits := "11110";
                    when 4 => bits := "00001";
                    when 5 => bits := "00001";
                    when 6 => bits := "11110";
                    when others => bits := "00000";
                end case;
--6
            when 7 =>
                case row is
                    when 0 => bits := "01110";
                    when 1 => bits := "10000";
                    when 2 => bits := "10000";
                    when 3 => bits := "11110";
                    when 4 => bits := "10001";
                    when 5 => bits := "10001";
                    when 6 => bits := "01110";
                    when others => bits := "00000";
                end case;
--7
            when 8 =>
                case row is
                    when 0 => bits := "11111";
                    when 1 => bits := "00001";
                    when 2 => bits := "00010";
                    when 3 => bits := "00100";
                    when 4 => bits := "01000";
                    when 5 => bits := "01000";
                    when 6 => bits := "01000";
                    when others => bits := "00000";
                end case;
--8
            when 9 =>
                case row is
                    when 0 => bits := "01110";
                    when 1 => bits := "10001";
                    when 2 => bits := "10001";
                    when 3 => bits := "01110";
                    when 4 => bits := "10001";
                    when 5 => bits := "10001";
                    when 6 => bits := "01110";
                    when others => bits := "00000";
                end case;
--9
            when 10 =>
                case row is
                    when 0 => bits := "01110";
                    when 1 => bits := "10001";
                    when 2 => bits := "10001";
                    when 3 => bits := "01111";
                    when 4 => bits := "00001";
                    when 5 => bits := "00001";
                    when 6 => bits := "01110";
                    when others => bits := "00000";
                end case;
---
            when 11 =>
                case row is
                    when 3 => bits := "11111";
                    when others => bits := "00000";
                end case;
--.
            when 12 =>
                case row is
                    when 6 => bits := "00100";
                    when others => bits := "00000";
                end case;
--F
            when 13 =>
                case row is
                    when 0 => bits := "11111";
                    when 1 => bits := "10000";
                    when 2 => bits := "10000";
                    when 3 => bits := "11110";
                    when 4 => bits := "10000";
                    when 5 => bits := "10000";
                    when 6 => bits := "10000";
                    when others => bits := "00000";
                end case;
--A
            when 14 =>
                case row is
                    when 0 => bits := "01110";
                    when 1 => bits := "10001";
                    when 2 => bits := "10001";
                    when 3 => bits := "11111";
                    when 4 => bits := "10001";
                    when 5 => bits := "10001";
                    when 6 => bits := "10001";
                    when others => bits := "00000";
                end case;
--I
            when 15 =>
                case row is
                    when 0 => bits := "11111";
                    when 1 => bits := "00100";
                    when 2 => bits := "00100";
                    when 3 => bits := "00100";
                    when 4 => bits := "00100";
                    when 5 => bits := "00100";
                    when 6 => bits := "11111";
                    when others => bits := "00000";
                end case;
--L
            when 16 =>
                case row is
                    when 0 => bits := "10000";
                    when 1 => bits := "10000";
                    when 2 => bits := "10000";
                    when 3 => bits := "10000";
                    when 4 => bits := "10000";
                    when 5 => bits := "10000";
                    when 6 => bits := "11111";
                    when others => bits := "00000";
                end case;

            when others =>
                bits := "00000";

        end case;

        if bits(4 - col) = '1' then
            pixel <= '1';
        else
            pixel <= '0';
        end if;

    end process;

end Behavioral;