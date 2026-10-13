library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fuentes is
end tb_fuentes;

architecture Behavioral of tb_fuentes is

    signal char_code_tb : integer range 0 to 16 := 0;
    signal row_tb       : integer range 0 to 6 := 0;
    signal col_tb       : integer range 0 to 4 := 0;
    signal pixel_tb     : std_logic;

begin

    uut : entity work.fuentes
        port map(
            char_code => char_code_tb,
            row       => row_tb,
            col       => col_tb,
            pixel     => pixel_tb
        );

    stim_process : process
    begin

        char_code_tb <= 0;
        row_tb <= 0;
        col_tb <= 0;
        wait for 10 ns;
        assert pixel_tb = '0'
            report "Error: espacio deberia dar pixel 0"
            severity error;

        char_code_tb <= 1;
        row_tb <= 0;
        col_tb <= 0;
        wait for 10 ns;
        assert pixel_tb = '0'
            report "Error: numero 0, fila 0, col 0 deberia ser 0"
            severity error;

        char_code_tb <= 1;
        row_tb <= 0;
        col_tb <= 1;
        wait for 10 ns;
        assert pixel_tb = '1'
            report "Error: numero 0, fila 0, col 1 deberia ser 1"
            severity error;

        char_code_tb <= 1;
        row_tb <= 0;
        col_tb <= 2;
        wait for 10 ns;
        assert pixel_tb = '1'
            report "Error: numero 0, fila 0, col 2 deberia ser 1"
            severity error;

        char_code_tb <= 1;
        row_tb <= 0;
        col_tb <= 3;
        wait for 10 ns;
        assert pixel_tb = '1'
            report "Error: numero 0, fila 0, col 3 deberia ser 1"
            severity error;

        char_code_tb <= 1;
        row_tb <= 0;
        col_tb <= 4;
        wait for 10 ns;
        assert pixel_tb = '0'
            report "Error: numero 0, fila 0, col 4 deberia ser 0"
            severity error;

        char_code_tb <= 2;
        row_tb <= 0;
        col_tb <= 2;
        wait for 10 ns;
        assert pixel_tb = '1'
            report "Error: numero 1, fila 0, col 2 deberia ser 1"
            severity error;

        char_code_tb <= 2;
        row_tb <= 0;
        col_tb <= 0;
        wait for 10 ns;
        assert pixel_tb = '0'
            report "Error: numero 1, fila 0, col 0 deberia ser 0"
            severity error;

        char_code_tb <= 11;
        row_tb <= 3;
        col_tb <= 0;
        wait for 10 ns;
        assert pixel_tb = '1'
            report "Error: signo menos, fila 3, col 0 deberia ser 1"
            severity error;

        char_code_tb <= 11;
        row_tb <= 2;
        col_tb <= 0;
        wait for 10 ns;
        assert pixel_tb = '0'
            report "Error: signo menos, fila 2, col 0 deberia ser 0"
            severity error;

        char_code_tb <= 12;
        row_tb <= 6;
        col_tb <= 2;
        wait for 10 ns;
        assert pixel_tb = '1'
            report "Error: punto, fila 6, col 2 deberia ser 1"
            severity error;

        char_code_tb <= 12;
        row_tb <= 5;
        col_tb <= 2;
        wait for 10 ns;
        assert pixel_tb = '0'
            report "Error: punto, fila 5, col 2 deberia ser 0"
            severity error;

        char_code_tb <= 13;
        row_tb <= 0;
        col_tb <= 0;
        wait for 10 ns;
        assert pixel_tb = '1'
            report "Error: F, fila 0, col 0 deberia ser 1"
            severity error;

        char_code_tb <= 13;
        row_tb <= 1;
        col_tb <= 4;
        wait for 10 ns;
        assert pixel_tb = '0'
            report "Error: F, fila 1, col 4 deberia ser 0"
            severity error;

        char_code_tb <= 14;
        row_tb <= 3;
        col_tb <= 2;
        wait for 10 ns;
        assert pixel_tb = '1'
            report "Error: A, fila 3, col 2 deberia ser 1"
            severity error;

        char_code_tb <= 15;
        row_tb <= 0;
        col_tb <= 0;
        wait for 10 ns;
        assert pixel_tb = '1'
            report "Error: I, fila 0, col 0 deberia ser 1"
            severity error;

        char_code_tb <= 15;
        row_tb <= 3;
        col_tb <= 2;
        wait for 10 ns;
        assert pixel_tb = '1'
            report "Error: I, fila 3, col 2 deberia ser 1"
            severity error;

        char_code_tb <= 16;
        row_tb <= 6;
        col_tb <= 4;
        wait for 10 ns;
        assert pixel_tb = '1'
            report "Error: L, fila 6, col 4 deberia ser 1"
            severity error;

        char_code_tb <= 16;
        row_tb <= 0;
        col_tb <= 4;
        wait for 10 ns;
        assert pixel_tb = '0'
            report "Error: L, fila 0, col 4 deberia ser 0"
            severity error;

        report "Testbench de fuentes finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;