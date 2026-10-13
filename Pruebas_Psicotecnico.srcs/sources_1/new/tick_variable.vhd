library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tick_variable is
    generic(
        MIN_COUNT : integer := 326797  - 1;
        MAX_COUNT : integer := 1470588 - 1
    );
    port(
        clk       : in  std_logic;
        reset     : in  std_logic;
        randomize : in  std_logic;
        tick      : out std_logic
    );
end tick_variable;

architecture Behavioral of tick_variable is

    constant RANGE_COUNT : integer := MAX_COUNT - MIN_COUNT;
    constant STEP_COUNT  : integer := RANGE_COUNT / 31;

    type speed_array_t is array (0 to 31) of integer range 0 to MAX_COUNT;

    constant SPEED_TABLE : speed_array_t := (
         0 => MIN_COUNT,
         1 => MIN_COUNT + STEP_COUNT * 1,
         2 => MIN_COUNT + STEP_COUNT * 2,
         3 => MIN_COUNT + STEP_COUNT * 3,
         4 => MIN_COUNT + STEP_COUNT * 4,
         5 => MIN_COUNT + STEP_COUNT * 5,
         6 => MIN_COUNT + STEP_COUNT * 6,
         7 => MIN_COUNT + STEP_COUNT * 7,
         8 => MIN_COUNT + STEP_COUNT * 8,
         9 => MIN_COUNT + STEP_COUNT * 9,
        10 => MIN_COUNT + STEP_COUNT * 10,
        11 => MIN_COUNT + STEP_COUNT * 11,
        12 => MIN_COUNT + STEP_COUNT * 12,
        13 => MIN_COUNT + STEP_COUNT * 13,
        14 => MIN_COUNT + STEP_COUNT * 14,
        15 => MIN_COUNT + STEP_COUNT * 15,
        16 => MIN_COUNT + STEP_COUNT * 16,
        17 => MIN_COUNT + STEP_COUNT * 17,
        18 => MIN_COUNT + STEP_COUNT * 18,
        19 => MIN_COUNT + STEP_COUNT * 19,
        20 => MIN_COUNT + STEP_COUNT * 20,
        21 => MIN_COUNT + STEP_COUNT * 21,
        22 => MIN_COUNT + STEP_COUNT * 22,
        23 => MIN_COUNT + STEP_COUNT * 23,
        24 => MIN_COUNT + STEP_COUNT * 24,
        25 => MIN_COUNT + STEP_COUNT * 25,
        26 => MIN_COUNT + STEP_COUNT * 26,
        27 => MIN_COUNT + STEP_COUNT * 27,
        28 => MIN_COUNT + STEP_COUNT * 28,
        29 => MIN_COUNT + STEP_COUNT * 29,
        30 => MIN_COUNT + STEP_COUNT * 30,
        31 => MAX_COUNT
    );

    signal count     : integer range 0 to MAX_COUNT := 0;
    signal count_max : integer range 0 to MAX_COUNT := MAX_COUNT;

    signal tick_s : std_logic := '0';

    signal lfsr : std_logic_vector(26 downto 0) := "101011001010110010101100101";

begin

    tick <= tick_s;

    process(clk)
        variable speed_index : integer range 0 to 31;
    begin
        if rising_edge(clk) then

            tick_s <= '0';

            lfsr <= lfsr(25 downto 0) & (lfsr(26) xor lfsr(4));

            if reset = '1' then
                count <= 0;
                count_max <= MAX_COUNT;

            elsif randomize = '1' then

                count <= 0;

                speed_index := to_integer(unsigned(lfsr(4 downto 0)));
                count_max <= SPEED_TABLE(speed_index);

            else

                if count >= count_max then
                    count <= 0;
                    tick_s <= '1';
                else
                    count <= count + 1;
                end if;

            end if;

        end if;
    end process;

end Behavioral;