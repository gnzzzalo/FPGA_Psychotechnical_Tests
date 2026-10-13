library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_control_attemp is
end tb_control_attemp;

architecture Behavioral of tb_control_attemp is

    constant CLK_FREQ_HZ : integer := 5;
    constant WIDTH       : integer := 16;

    signal clk_tb       : std_logic := '0';
    signal reset_all_tb : std_logic := '0';

    signal btnC_edge_tb : std_logic := '0';

    signal done1_tb : std_logic := '0';
    signal done2_tb : std_logic := '0';

    signal result_in_tb : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal negative_tb  : std_logic := '0';
    signal in_range_tb  : std_logic := '0';

    signal start_attempt_tb : std_logic;
    signal reset_attempt_tb : std_logic;

    signal running_tb      : std_logic;
    signal final_screen_tb : std_logic;
    signal show_result_tb  : std_logic;
    signal accept_btnU_tb  : std_logic;

    signal result0_tb : std_logic_vector(WIDTH-1 downto 0);
    signal result1_tb : std_logic_vector(WIDTH-1 downto 0);
    signal result2_tb : std_logic_vector(WIDTH-1 downto 0);

    signal neg0_tb : std_logic;
    signal neg1_tb : std_logic;
    signal neg2_tb : std_logic;

    signal fail0_tb : std_logic;
    signal fail1_tb : std_logic;
    signal fail2_tb : std_logic;

begin

    uut : entity work.control_attemp
        generic map(
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            WIDTH       => WIDTH
        )
        port map(
            clk       => clk_tb,
            reset_all => reset_all_tb,

            btnC_edge => btnC_edge_tb,

            done1 => done1_tb,
            done2 => done2_tb,

            result_in => result_in_tb,
            negative  => negative_tb,
            in_range  => in_range_tb,

            start_attempt => start_attempt_tb,
            reset_attempt => reset_attempt_tb,

            running      => running_tb,
            final_screen => final_screen_tb,
            show_result  => show_result_tb,
            accept_btnU  => accept_btnU_tb,

            result0 => result0_tb,
            result1 => result1_tb,
            result2 => result2_tb,

            neg0 => neg0_tb,
            neg1 => neg1_tb,
            neg2 => neg2_tb,

            fail0 => fail0_tb,
            fail1 => fail1_tb,
            fail2 => fail2_tb
        );

    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for 5 ns;
            clk_tb <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_process : process
    begin

        reset_all_tb <= '1';
        btnC_edge_tb <= '0';
        done1_tb <= '0';
        done2_tb <= '0';
        result_in_tb <= (others => '0');
        negative_tb <= '0';
        in_range_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert running_tb = '0'
            report "Error: con reset_all, running deberia valer 0"
            severity error;

        assert final_screen_tb = '0'
            report "Error: con reset_all, final_screen deberia valer 0"
            severity error;

        assert show_result_tb = '0'
            report "Error: con reset_all, show_result deberia valer 0"
            severity error;

        assert unsigned(result0_tb) = 0 and unsigned(result1_tb) = 0 and unsigned(result2_tb) = 0
            report "Error: con reset_all, los resultados guardados deberian estar a 0"
            severity error;

        reset_all_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert running_tb = '0'
            report "Error: en espera inicial, running deberia valer 0"
            severity error;

        assert final_screen_tb = '0'
            report "Error: en espera inicial, final_screen deberia valer 0"
            severity error;

        btnC_edge_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert start_attempt_tb = '1'
            report "Error: al pulsar btnC_edge, start_attempt deberia valer 1"
            severity error;

        assert running_tb = '0'
            report "Error: en el ciclo de start_attempt, running todavia deberia valer 0"
            severity error;

        btnC_edge_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert start_attempt_tb = '0'
            report "Error: start_attempt deberia durar solo un ciclo"
            severity error;

        assert running_tb = '1'
            report "Error: despues de T_START_ATTEMPT, running deberia valer 1"
            severity error;

        assert accept_btnU_tb = '1'
            report "Error: en T_RUNNING_ATTEMPT, accept_btnU deberia valer 1"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert running_tb = '1'
            report "Error: mientras done1 = 0, running deberia mantenerse a 1"
            severity error;

        result_in_tb <= std_logic_vector(to_unsigned(25, WIDTH));
        negative_tb <= '0';
        in_range_tb <= '1';
        done1_tb <= '1';
        done2_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert running_tb = '0'
            report "Error: cuando done1 = 1, running deberia pasar a 0"
            severity error;

        assert accept_btnU_tb = '1'
            report "Error: en T_WAIT_BOTH_DONE, accept_btnU deberia seguir valiendo 1"
            severity error;

        done2_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(result0_tb) = 25
            report "Error: el primer resultado deberia guardarse en result0"
            severity error;

        assert neg0_tb = '0'
            report "Error: neg0 deberia valer 0 en el primer intento"
            severity error;

        assert fail0_tb = '0'
            report "Error: fail0 deberia valer 0 si in_range = 1"
            severity error;

        assert show_result_tb = '1'
            report "Error: despues de guardar resultado, show_result deberia valer 1"
            severity error;

        done1_tb <= '0';
        done2_tb <= '0';

        for i in 1 to CLK_FREQ_HZ loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert reset_attempt_tb = '1'
            report "Error: despues de mostrar resultado, reset_attempt deberia valer 1"
            severity error;

        assert show_result_tb = '0'
            report "Error: en T_RESET_ATTEMPT, show_result deberia valer 0"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert reset_attempt_tb = '0'
            report "Error: reset_attempt deberia durar solo un ciclo"
            severity error;

        assert running_tb = '0'
            report "Error: al volver a espera, running deberia valer 0"
            severity error;

        btnC_edge_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert start_attempt_tb = '1'
            report "Error: en el segundo intento, start_attempt deberia valer 1"
            severity error;

        btnC_edge_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert running_tb = '1'
            report "Error: en el segundo intento, running deberia valer 1"
            severity error;

        result_in_tb <= std_logic_vector(to_unsigned(40, WIDTH));
        negative_tb <= '1';
        in_range_tb <= '0';
        done1_tb <= '1';
        done2_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(result1_tb) = 40
            report "Error: el segundo resultado deberia guardarse en result1"
            severity error;

        assert neg1_tb = '1'
            report "Error: neg1 deberia valer 1 en el segundo intento"
            severity error;

        assert fail1_tb = '1'
            report "Error: fail1 deberia valer 1 si in_range = 0"
            severity error;

        assert show_result_tb = '1'
            report "Error: en el segundo intento, show_result deberia valer 1"
            severity error;

        done1_tb <= '0';
        done2_tb <= '0';

        for i in 1 to CLK_FREQ_HZ loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert reset_attempt_tb = '1'
            report "Error: despues del segundo intento, reset_attempt deberia valer 1"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        btnC_edge_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert start_attempt_tb = '1'
            report "Error: en el tercer intento, start_attempt deberia valer 1"
            severity error;

        btnC_edge_tb <= '0';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        result_in_tb <= std_logic_vector(to_unsigned(10, WIDTH));
        negative_tb <= '0';
        in_range_tb <= '1';
        done1_tb <= '1';
        done2_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert unsigned(result2_tb) = 10
            report "Error: el tercer resultado deberia guardarse en result2"
            severity error;

        assert neg2_tb = '0'
            report "Error: neg2 deberia valer 0 en el tercer intento"
            severity error;

        assert fail2_tb = '0'
            report "Error: fail2 deberia valer 0 si in_range = 1"
            severity error;

        assert show_result_tb = '1'
            report "Error: despues del tercer resultado, show_result deberia valer 1"
            severity error;

        done1_tb <= '0';
        done2_tb <= '0';

        for i in 1 to CLK_FREQ_HZ loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert final_screen_tb = '1'
            report "Error: despues del tercer intento, final_screen deberia valer 1"
            severity error;

        assert running_tb = '0'
            report "Error: en pantalla final, running deberia valer 0"
            severity error;

        assert unsigned(result0_tb) = 25
            report "Error: result0 deberia conservar el primer resultado"
            severity error;

        assert unsigned(result1_tb) = 40
            report "Error: result1 deberia conservar el segundo resultado"
            severity error;

        assert unsigned(result2_tb) = 10
            report "Error: result2 deberia conservar el tercer resultado"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert final_screen_tb = '1'
            report "Error: T_SHOW_FINAL deberia mantener final_screen a 1"
            severity error;

        reset_all_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert final_screen_tb = '0'
            report "Error: reset_all deberia apagar final_screen"
            severity error;

        assert running_tb = '0'
            report "Error: reset_all deberia dejar running a 0"
            severity error;

        assert unsigned(result0_tb) = 0 and unsigned(result1_tb) = 0 and unsigned(result2_tb) = 0
            report "Error: reset_all deberia borrar los resultados guardados"
            severity error;

        assert fail0_tb = '0' and fail1_tb = '0' and fail2_tb = '0'
            report "Error: reset_all deberia borrar los FAIL guardados"
            severity error;

        report "Testbench de control_attemp finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;