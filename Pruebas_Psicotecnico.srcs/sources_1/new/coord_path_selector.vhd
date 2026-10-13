library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.coord_tracks_pkg.all;

entity coord_path_selector is
    Port (
        clk25      : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        locked     : in  STD_LOGIC;
        enable     : in  STD_LOGIC;

        start_btn  : in  STD_LOGIC;

        left_path_id_o  : out path_id_t;
        right_path_id_o : out path_id_t
    );
end coord_path_selector;

architecture Behavioral of coord_path_selector is

    signal lfsr : unsigned(15 downto 0) := x"ACE1";

    signal start_sync0 : STD_LOGIC := '0';
    signal start_sync1 : STD_LOGIC := '0';
    signal start_prev  : STD_LOGIC := '0';
    signal start_edge  : STD_LOGIC := '0';

    signal left_id_reg  : path_id_t := 0;
    signal right_id_reg : path_id_t := 17;

begin

    process(clk25)
        variable feedback : STD_LOGIC;
        variable left_tmp  : integer;
        variable right_tmp : integer;
    begin
        if rising_edge(clk25) then

            if rst = '1' or locked = '0' or enable = '0' then
                lfsr <= x"ACE1";

                start_sync0 <= '0';
                start_sync1 <= '0';
                start_prev  <= '0';
                start_edge  <= '0';

                left_id_reg  <= 0;
                right_id_reg <= 17;

            else
                --------------------------------------------------------
                -- Sincronización de start
                --------------------------------------------------------
                start_sync0 <= start_btn;
                start_sync1 <= start_sync0;
                start_prev  <= start_sync1;
                start_edge  <= start_sync1 and not start_prev;

                --------------------------------------------------------
                -- LFSR siempre moviéndose mientras la prueba está activa
                --------------------------------------------------------
                feedback := lfsr(15) xor lfsr(13) xor lfsr(12) xor lfsr(10);
                lfsr <= lfsr(14 downto 0) & feedback;

                --------------------------------------------------------
                -- Al iniciar, se fijan dos caminos distintos
                --------------------------------------------------------
                if start_edge = '1' then
                    left_tmp  := to_integer(lfsr(4 downto 0));
                    right_tmp := (to_integer(lfsr(9 downto 5)) + 13) mod 32;

                    left_id_reg  <= left_tmp;
                    right_id_reg <= right_tmp;
                end if;

            end if;

        end if;
    end process;

    left_path_id_o  <= left_id_reg;
    right_path_id_o <= right_id_reg;

end Behavioral;