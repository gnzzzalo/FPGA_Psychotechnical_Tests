library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_control is
    generic(
        DEBOUNCE_STABLE_COUNT : integer := 1_000_000
    );
    port(
        clk : in std_logic;

        btnC : in std_logic;
        btnU : in std_logic;
        swt  : in std_logic_vector(0 downto 0);

        reset_all : out std_logic;
        btnC_edge : out std_logic;
        btnU_edge : out std_logic
    );
end input_control;

architecture Structural of input_control is

    signal btnC_clean : std_logic;
    signal btnU_clean : std_logic;
    signal sw0_clean  : std_logic;

    signal btnC_prev : std_logic := '0';
    signal btnU_prev : std_logic := '0';

    signal btnC_edge_s : std_logic := '0';
    signal btnU_edge_s : std_logic := '0';

begin

    debounce_btnC : entity work.debounce
        generic map(
            STABLE_COUNT => DEBOUNCE_STABLE_COUNT
        )
        port map(
            clk     => clk,
            btn_in  => btnC,
            btn_out => btnC_clean
        );

    debounce_btnU : entity work.debounce
        generic map(
            STABLE_COUNT => DEBOUNCE_STABLE_COUNT
        )
        port map(
            clk     => clk,
            btn_in  => btnU,
            btn_out => btnU_clean
        );

    debounce_sw0 : entity work.debounce
        generic map(
            STABLE_COUNT => DEBOUNCE_STABLE_COUNT
        )
        port map(
            clk     => clk,
            btn_in  => swt(0),
            btn_out => sw0_clean
        );

    process(clk)
    begin
        if rising_edge(clk) then
            btnC_prev <= btnC_clean;
            btnU_prev <= btnU_clean;

            btnC_edge_s <= btnC_clean and not btnC_prev;
            btnU_edge_s <= btnU_clean and not btnU_prev;
        end if;
    end process;

    reset_all <= sw0_clean;

    btnC_edge <= btnC_edge_s;
    btnU_edge <= btnU_edge_s;

end Structural;