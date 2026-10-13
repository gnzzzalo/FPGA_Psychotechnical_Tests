library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity subtractor is
    generic(
        WIDTH : integer := 16
    );
    port(
        count1 : in  std_logic_vector(WIDTH-1 downto 0);
        count2 : in  std_logic_vector(WIDTH-1 downto 0);
        done1  : in  std_logic;
        done2  : in  std_logic;

        result : out std_logic_vector(WIDTH-1 downto 0);
        pos_neg        : out std_logic;
        zero_out       : out std_logic
    );
end subtractor;

architecture Behavioral of subtractor is

    signal count1_aux : unsigned(WIDTH-1 downto 0);
    signal count2_aux : unsigned(WIDTH-1 downto 0);

    signal result_aux  : unsigned(WIDTH-1 downto 0);

begin

    count1_aux <= unsigned(count1);
    count2_aux <= unsigned(count2);

    process(count1_aux, count2_aux, done1, done2)
    begin

        result_aux <= (others => '0');
        pos_neg        <= '0';
        zero_out       <= '0';

        if done1 = '1' and done2 = '1' then

            if count1_aux > count2_aux then
                result_aux <= count1_aux - count2_aux;
                pos_neg    <= '1';
                zero_out   <= '0';

            elsif count1_aux < count2_aux then
                result_aux <= count2_aux - count1_aux;
                pos_neg    <= '0';
                zero_out   <= '0';

            else
                result_aux <= (others => '0');
                pos_neg    <= '0';
                zero_out   <= '1';
            end if;

        end if;

    end process;

    result <= std_logic_vector(result_aux);

end Behavioral;