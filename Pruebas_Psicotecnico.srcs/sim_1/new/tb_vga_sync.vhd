library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_vga_sync is
end tb_vga_sync;

architecture Behavioral of tb_vga_sync is

    signal clk_tb       : std_logic := '0';
    signal reset_tb     : std_logic := '0';

    signal h_count_tb   : integer range 0 to 799;
    signal v_count_tb   : integer range 0 to 524;

    signal visible_tb   : std_logic;
    signal frame_end_tb : std_logic;

    signal Hsync_tb     : std_logic;
    signal Vsync_tb     : std_logic;

begin

    uut : entity work.vga_sync
        port map(
            clk       => clk_tb,
            reset     => reset_tb,
            h_count   => h_count_tb,
            v_count   => v_count_tb,
            visible   => visible_tb,
            frame_end => frame_end_tb,
            Hsync     => Hsync_tb,
            Vsync     => Vsync_tb
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
        variable frame_end_count : integer := 0;
    begin

        reset_tb <= '1';

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        assert h_count_tb = 0
            report "Error: con reset, h_count deberia ser 0"
            severity error;

        assert v_count_tb = 0
            report "Error: con reset, v_count deberia ser 0"
            severity error;

        reset_tb <= '0';

        for i in 1 to 10 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert h_count_tb > 0
            report "Error: h_count deberia empezar a avanzar despues del reset"
            severity error;

        while not (h_count_tb = 100 and v_count_tb = 0) loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert visible_tb = '1'
            report "Error: h=100, v=0 deberia estar en zona visible"
            severity error;

        while not (h_count_tb = 640 and v_count_tb = 0) loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert visible_tb = '0'
            report "Error: h=640 ya deberia estar fuera de zona visible"
            severity error;

        while not (h_count_tb = 656 and v_count_tb = 0) loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert Hsync_tb = '0'
            report "Error: en h=656, Hsync deberia valer 0"
            severity error;

        while not (h_count_tb = 752 and v_count_tb = 0) loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert Hsync_tb = '1'
            report "Error: en h=752, Hsync deberia volver a 1"
            severity error;

        while not (h_count_tb = 0 and v_count_tb = 1) loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert h_count_tb = 0 and v_count_tb = 1
            report "Error: al terminar una linea, h_count deberia volver a 0 y v_count aumentar"
            severity error;

        while not (h_count_tb = 0 and v_count_tb = 480) loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert visible_tb = '0'
            report "Error: en v=480 ya deberia estar fuera de zona visible"
            severity error;

        while not (h_count_tb = 0 and v_count_tb = 490) loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert Vsync_tb = '0'
            report "Error: en v=490, Vsync deberia valer 0"
            severity error;

        while not (h_count_tb = 0 and v_count_tb = 492) loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert Vsync_tb = '1'
            report "Error: en v=492, Vsync deberia volver a 1"
            severity error;

        frame_end_count := 0;

        while frame_end_count = 0 loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;

            if frame_end_tb = '1' then
                frame_end_count := frame_end_count + 1;
            end if;
        end loop;

        assert h_count_tb = 799 and v_count_tb = 524
            report "Error: frame_end deberia ocurrir en h=799 y v=524"
            severity error;

        wait until rising_edge(clk_tb);
        wait for 1 ns;

        while not (h_count_tb = 0 and v_count_tb = 0) loop
            wait until rising_edge(clk_tb);
            wait for 1 ns;
        end loop;

        assert h_count_tb = 0 and v_count_tb = 0
            report "Error: despues del final de frame, los contadores deberian volver a 0"
            severity error;

        report "Testbench de vga_sync finalizado correctamente"
            severity note;

        wait;

    end process;

end Behavioral;