library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package prueba_anticipacion_pkg is

    constant ANT_WIDTH : integer := 16;

    constant ANT_TRACK_X0 : integer := 0;
    constant ANT_TRACK_X1 : integer := 520;
    constant ANT_TRACK_H  : integer := 130;

    constant ANT_BALL_R : integer := 14;
    constant ANT_BALL_Y : integer := 240;

    constant ANT_BALL_START_X : integer := ANT_TRACK_X0 + ANT_BALL_R;
    constant ANT_BALL_END_X   : integer := 640 - ANT_BALL_R;

    --------------------------------------------------------------------
    -- Movimiento de bola.
    -- La bola avanza ANT_BALL_STEP píxeles cada ANT_MOVE_FRAME_DIV frames.
    --------------------------------------------------------------------
    constant ANT_BALL_STEP       : integer := 2;
    constant ANT_MOVE_FRAME_DIV  : integer := 1;

    --------------------------------------------------------------------
    -- Cronómetro en centésimas con clk25
    --------------------------------------------------------------------
    constant ANT_CENTI_MAX_CYC : integer := 250_000;
    constant ANT_MAX_CS        : integer := 3000;

    --------------------------------------------------------------------
    -- Número de intentos
    --------------------------------------------------------------------
    constant ANT_ATTEMPTS : integer := 3;

    --------------------------------------------------------------------
    -- Tiempo mostrando el resultado de un intento: 1 s
    --------------------------------------------------------------------
    constant ANT_RESULT_WAIT_CS : integer := 100;

end package;