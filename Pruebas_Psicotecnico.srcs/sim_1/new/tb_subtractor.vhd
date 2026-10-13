library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_subtractor is
end tb_subtractor;

architecture Behavioral of tb_subtractor is

    constant WIDTH : integer := 16;

    signal count1_tb : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal count2_tb : std_logic_vector(WIDTH-1 downto 0) := (others => '0');

    signal done1_tb : std_logic := '0';
    signal done2_tb : std_logic := '0';

    signal result_tb   : std_logic_vector(WIDTH-1 downto 0);
    signal pos_neg_tb  : std_logic;
    signal zero_out_tb : std_logic;

begin

    uut : entity work.subtractor
        generic map(
            WIDTH => WIDTH
        )
        port map(
            count1   => count1_tb,
            count2   => count2_tb,
            done1    => done1_tb,
            done2    => done2_tb,
            result   => result_tb,
            pos_neg  => pos_neg_tb,
            zero_out => zero_out_tb
        );

    stim_process : process
    begin

        count1_tb <= std_logic_vector(to_unsigned(300, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(250, WIDTH));
        done1_tb <= '0';
        done2_tb <= '0';

        wait for 10 ns;

        assert unsigned(result_tb) = 0
            report "Error: si done1 y done2 no valen 1, result deberia ser 0"
            severity error;

        assert pos_neg_tb = '0'
            report "Error: si done1 y done2 no valen 1, pos_neg deberia ser 0"
            severity error;

        assert zero_out_tb = '0'
            report "Error: si done1 y done2 no valen 1, zero_out deberia ser 0"
            severity error;

        done1_tb <= '1';
        done2_tb <= '0';

        wait for 10 ns;

        assert unsigned(result_tb) = 0
            report "Error: si solo done1 vale 1, result deberia ser 0"
            severity error;

        assert pos_neg_tb = '0'
            report "Error: si solo done1 vale 1, pos_neg deberia ser 0"
            severity error;

        assert zero_out_tb = '0'
            report "Error: si solo done1 vale 1, zero_out deberia ser 0"
            severity error;

        done1_tb <= '0';
        done2_tb <= '1';

        wait for 10 ns;

        assert unsigned(result_tb) = 0
            report "Error: si solo done2 vale 1, result deberia ser 0"
            severity error;

        assert pos_neg_tb = '0'
            report "Error: si solo done2 vale 1, pos_neg deberia ser 0"
            severity error;

        assert zero_out_tb = '0'
            report "Error: si solo done2 vale 1, zero_out deberia ser 0"
            severity error;

        count1_tb <= std_logic_vector(to_unsigned(300, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(250, WIDTH));
        done1_tb <= '1';
        done2_tb <= '1';

        wait for 10 ns;

        assert unsigned(result_tb) = 50
            report "Error: con count1=300 y count2=250, result deberia valer 50"
            severity error;

        assert pos_neg_tb = '1'
            report "Error: con count1 > count2, pos_neg deberia valer 1"
            severity error;

        assert zero_out_tb = '0'
            report "Error: con count1 distinto de count2, zero_out deberia valer 0"
            severity error;

        count1_tb <= std_logic_vector(to_unsigned(250, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(300, WIDTH));
        done1_tb <= '1';
        done2_tb <= '1';

        wait for 10 ns;

        assert unsigned(result_tb) = 50
            report "Error: con count1=250 y count2=300, result deberia valer 50"
            severity error;

        assert pos_neg_tb = '0'
            report "Error: con count1 < count2, pos_neg deberia valer 0"
            severity error;

        assert zero_out_tb = '0'
            report "Error: con count1 distinto de count2, zero_out deberia valer 0"
            severity error;

        count1_tb <= std_logic_vector(to_unsigned(275, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(275, WIDTH));
        done1_tb <= '1';
        done2_tb <= '1';

        wait for 10 ns;

        assert unsigned(result_tb) = 0
            report "Error: con count1 = count2, result deberia valer 0"
            severity error;

        assert pos_neg_tb = '0'
            report "Error: con count1 = count2, pos_neg deberia valer 0"
            severity error;

        assert zero_out_tb = '1'
            report "Error: con count1 = count2, zero_out deberia valer 1"
            severity error;

        count1_tb <= std_logic_vector(to_unsigned(0, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(100, WIDTH));
        done1_tb <= '1';
        done2_tb <= '1';

        wait for 10 ns;

        assert unsigned(result_tb) = 100
            report "Error: con count1=0 y count2=100, result deberia valer 100"
            severity error;

        assert pos_neg_tb = '0'
            report "Error: con count1 < count2, pos_neg deberia valer 0"
            severity error;

        assert zero_out_tb = '0'
            report "Error: con count1 distinto de count2, zero_out deberia valer 0"
            severity error;

        count1_tb <= std_logic_vector(to_unsigned(100, WIDTH));
        count2_tb <= std_logic_vector(to_unsigned(0, WIDTH));
        done1_tb <= '1';
        done2_tb <= '1';

        wait for 10 ns;

        assert unsigned(result_tb) = 100
            report "Error: con count1=100 y count2=0, result deberia valer 100"
            severity error;

        assert pos_neg_tb = '1'
            report "Error: con count1 > count2, pos_neg deberia valer 1"
            severity error;

        assert zero_out_tb = '0'
            report "Error: con count1 distinto de count2, zero_out deberia valer 0"
            severity error;

        report "Testbench de subtractor finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;