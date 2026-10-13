library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package prueba_coordinacion_pkg is

    --------------------------------------------------------------------
    -- Parámetros de la prueba de coordinación
    --------------------------------------------------------------------
    constant PATH_HALF : integer := 44;
    constant BALL_R    : integer := 7;

    constant BALL1_Y_FIXED : integer := 380;
    constant BALL2_Y_FIXED : integer := 380;

    --------------------------------------------------------------------
    -- Límites para que cada bola no pueda cruzar a la otra mitad
    --------------------------------------------------------------------
    constant LEFT_MIN  : integer := BALL_R;
    constant LEFT_MAX  : integer := 319 - BALL_R;
    constant RIGHT_MIN : integer := 320 + BALL_R;
    constant RIGHT_MAX : integer := 639 - BALL_R;

    --------------------------------------------------------------------
    -- Temporizador
    -- clk25 = 25 MHz
    -- 0.01 s = 250000 ciclos
    --------------------------------------------------------------------
    constant COORD_CENTI_MAX_CYC : integer := 250_000;
    constant COORD_TEST_CS_MAX   : integer := 3000; -- 30.00 segundos

    --------------------------------------------------------------------
    -- Velocidad de la prueba
    --------------------------------------------------------------------
    constant SCROLL_STEP      : integer := 2;
    constant PLAYER_FRAME_DIV : integer := 2;

    --------------------------------------------------------------------
    -- Utilidad
    --------------------------------------------------------------------
    function wrap512(x : integer) return integer;

end package;


package body prueba_coordinacion_pkg is

    function wrap512(x : integer) return integer is
    begin
        if x < 0 then
            return x + 512;
        elsif x >= 512 then
            return x - 512;
        else
            return x;
        end if;
    end function;

end package body;