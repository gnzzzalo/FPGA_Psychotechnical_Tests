library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_results_draw is
    generic(
        WIDTH      : integer := 16;
        FONT_SCALE : integer := 5;
        TEXT_X0    : integer := 245;
        TEXT_Y0    : integer := 160;
        TEXT_ROW_H : integer := 70
    );
    port(
        h_count      : in  integer range 0 to 799;
        v_count      : in  integer range 0 to 524;
        visible      : in  std_logic;
        final_screen : in  std_logic;

        result0      : in  std_logic_vector(WIDTH-1 downto 0);
        result1      : in  std_logic_vector(WIDTH-1 downto 0);
        result2      : in  std_logic_vector(WIDTH-1 downto 0);

        neg0         : in  std_logic;
        neg1         : in  std_logic;
        neg2         : in  std_logic;

        fail0        : in  std_logic;
        fail1        : in  std_logic;
        fail2        : in  std_logic;

        text_pixel   : out std_logic
    );
end vga_results_draw;

architecture Structural of vga_results_draw is

    constant FONT_W     : integer := 5;
    constant FONT_H     : integer := 7;
    constant FONT_PITCH : integer := 6 * FONT_SCALE;

    signal char_code_s : integer range 0 to 16 := 0;
    signal row_s : integer range 0 to 6 := 0;
    signal col_s : integer range 0 to 4 := 0;
    signal pixel_s: std_logic;

begin

    font_inst : entity work.fuentes
        port map(
            char_code => char_code_s,
            row       => row_s,
            col       => col_s,
            pixel     => pixel_s
        );

    process(
        h_count, v_count, visible, final_screen,
        result0, result1, result2,
        neg0, neg1, neg2,
        fail0, fail1, fail2,
        pixel_s
    )
        variable local_x    : integer;
        variable local_y    : integer;
        variable row_index  : integer;
        variable char_index : integer;
    
        variable value_int : integer;
        variable sec_d     : integer;
        variable dec_d     : integer;
        variable cent_d    : integer;
    
        variable fail_v : std_logic;
        variable neg_v  : std_logic;
        variable code_v : integer range 0 to 16;
    
        variable in_char_v : std_logic;
    begin
    
        in_char_v := '0';
    
        char_code_s <= 0;
        row_s <= 0;
        col_s <= 0;
    
        code_v := 0;
    
        if final_screen = '1' and visible = '1' then
    
            local_x := h_count - TEXT_X0;
            local_y := v_count - TEXT_Y0;
    
            if local_x >= 0 and local_x < 5 * FONT_PITCH and
               local_y >= 0 and local_y < 3 * TEXT_ROW_H then
    
                row_index := local_y / TEXT_ROW_H;
    
                if (local_y mod TEXT_ROW_H) < FONT_H * FONT_SCALE then
    
                    char_index := local_x / FONT_PITCH;
    
                    if (local_x mod FONT_PITCH) < FONT_W * FONT_SCALE then
    
                        col_s <= (local_x mod FONT_PITCH) / FONT_SCALE;
                        row_s <= (local_y mod TEXT_ROW_H) / FONT_SCALE;
    
                        case row_index is
                            when 0 =>
                                value_int := to_integer(unsigned(result0));
                                fail_v := fail0;
                                neg_v  := neg0;
    
                            when 1 =>
                                value_int := to_integer(unsigned(result1));
                                fail_v := fail1;
                                neg_v  := neg1;
    
                            when others =>
                                value_int := to_integer(unsigned(result2));
                                fail_v := fail2;
                                neg_v  := neg2;
                        end case;
    
                        sec_d  := (value_int / 100) mod 10;
                        dec_d  := (value_int / 10) mod 10;
                        cent_d := value_int mod 10;
    
                        if fail_v = '1' then
    
                            case char_index is
                                when 0 => code_v := 0;
                                when 1 => code_v := 13;
                                when 2 => code_v := 14;
                                when 3 => code_v := 15;
                                when 4 => code_v := 16;
                                when others => code_v := 0;
                            end case;
    
                        else
    
                            case char_index is
                                when 0 =>
                                    if neg_v = '1' then
                                        code_v := 11;
                                    else
                                        code_v := 0;
                                    end if;
    
                                when 1 => code_v := sec_d + 1;
                                when 2 => code_v := 12;
                                when 3 => code_v := dec_d + 1;
                                when 4 => code_v := cent_d + 1;
                                when others => code_v := 0;
                            end case;
    
                        end if;
    
                        char_code_s <= code_v;
                        in_char_v := '1';
    
                    end if;
                end if;
            end if;
        end if;
    
        if in_char_v = '1' and pixel_s = '1' then
            text_pixel <= '1';
        else
            text_pixel <= '0';
        end if;
    
    end process;

end Structural;