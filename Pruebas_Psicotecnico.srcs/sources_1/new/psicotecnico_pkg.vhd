library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package psicotecnico_pkg is

    --------------------------------------------------------------------
    -- VGA 640x480 @ 60 Hz
    --------------------------------------------------------------------
    constant HD : integer := 640;
    constant HF : integer := 16;
    constant HS : integer := 96;
    constant HB : integer := 48;
    constant HT : integer := 800;

    constant VD : integer := 480;
    constant VF : integer := 10;
    constant VS : integer := 2;
    constant VB : integer := 33;
    constant VT : integer := 525;

    --------------------------------------------------------------------
    -- Estado común de cualquier prueba
    --------------------------------------------------------------------
    type test_state_type is (
        IDLE,
        RUNNING,
        FINISHED
    );

    --------------------------------------------------------------------
    -- Segmentos para dibujar números en VGA
    -- Orden: a b c d e f g = bits 6 downto 0
    --------------------------------------------------------------------
    subtype seg_t is STD_LOGIC_VECTOR(6 downto 0);

    --------------------------------------------------------------------
    -- Buzzer común
    -- 25 MHz / (2 * 2000 Hz) = 6250
    --------------------------------------------------------------------
    constant TONE_HALF_CYC : integer := 6250;

    function seg_decode(d : integer) return seg_t;

    function seg_on(
        seg : seg_t;
        px  : integer;
        py  : integer;
        w   : integer;
        h   : integer;
        t   : integer
    ) return boolean;

end package;


package body psicotecnico_pkg is

    function seg_decode(d : integer) return seg_t is
    begin
        case d is
            when 0 => return "1111110";
            when 1 => return "0110000";
            when 2 => return "1101101";
            when 3 => return "1111001";
            when 4 => return "0110011";
            when 5 => return "1011011";
            when 6 => return "1011111";
            when 7 => return "1110000";
            when 8 => return "1111111";
            when 9 => return "1111011";
            when others => return "0000000";
        end case;
    end function;

    function seg_on(
        seg : seg_t;
        px  : integer;
        py  : integer;
        w   : integer;
        h   : integer;
        t   : integer
    ) return boolean is
        variable a_area : boolean;
        variable b_area : boolean;
        variable c_area : boolean;
        variable d_area : boolean;
        variable e_area : boolean;
        variable f_area : boolean;
        variable g_area : boolean;
    begin
        a_area := py >= 0         and py < t          and px >= t     and px < w - t;
        b_area := px >= w - t     and px < w          and py >= t     and py < h / 2;
        c_area := px >= w - t     and px < w          and py >= h / 2 and py < h - t;
        d_area := py >= h - t     and py < h          and px >= t     and px < w - t;
        e_area := px >= 0         and px < t          and py >= h / 2 and py < h - t;
        f_area := px >= 0         and px < t          and py >= t     and py < h / 2;
        g_area := py >= h/2 - t/2 and py < h/2 + t/2  and px >= t     and px < w - t;

        return (seg(6) = '1' and a_area) or
               (seg(5) = '1' and b_area) or
               (seg(4) = '1' and c_area) or
               (seg(3) = '1' and d_area) or
               (seg(2) = '1' and e_area) or
               (seg(1) = '1' and f_area) or
               (seg(0) = '1' and g_area);
    end function;

end package body;