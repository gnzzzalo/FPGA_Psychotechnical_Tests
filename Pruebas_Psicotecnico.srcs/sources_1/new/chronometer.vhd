library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chronometer is
    generic(
        CLK_FREQ_HZ : integer := 100_000_000;
        OUT_WIDTH   : integer := 16
    );
    port(
        clk       : in  std_logic;
        ini       : in  std_logic;
        fin       : in  std_logic;
        count_out : out std_logic_vector(OUT_WIDTH-1 downto 0);
        limit_out : out std_logic;
        done_out  : out std_logic
    );
end chronometer;

architecture Behavioral of chronometer is

    constant COUNT : integer := CLK_FREQ_HZ / 100;

    constant MAX_COUNT_CS : unsigned(OUT_WIDTH-1 downto 0) := to_unsigned(30000, OUT_WIDTH);

    signal clk_count  : integer range 0 to COUNT-1 := 0;
    signal count_aux  : unsigned(OUT_WIDTH-1 downto 0) := (others => '0');

    signal limit_aux : std_logic := '0';
    signal done_aux  : std_logic := '0';
    signal starter   : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then

            if ini = '1' then
                clk_count <= 0;
                count_aux <= (others => '0');
                limit_aux <= '0';
                done_aux  <= '0';
                starter   <= '1';

            elsif fin = '1' then
                starter  <= '0';
                done_aux <= '1';

            elsif starter = '1' then

                if clk_count = COUNT - 1 then
                    clk_count <= 0;

                    if count_aux = MAX_COUNT_CS - 1 then
                        count_aux <= MAX_COUNT_CS;
                        limit_aux <= '1';
                        done_aux  <= '1';
                        starter   <= '0';
                    else
                        count_aux <= count_aux + 1;
                    end if;

                else
                    clk_count <= clk_count + 1;
                end if;

            end if;

        end if;
    end process;

    count_out <= std_logic_vector(count_aux);
    limit_out <= limit_aux;
    done_out  <= done_aux;

end Behavioral;