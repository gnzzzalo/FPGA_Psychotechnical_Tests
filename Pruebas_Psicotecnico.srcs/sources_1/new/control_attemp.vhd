library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_attemp is
    generic(
        CLK_FREQ_HZ : integer := 100000000;
        WIDTH       : integer := 16
    );
    port(
        clk       : in std_logic;
        reset_all : in std_logic;

        btnC_edge : in std_logic;

        done1 : in std_logic;
        done2 : in std_logic;

        result_in : in std_logic_vector(WIDTH-1 downto 0);
        negative  : in std_logic;
        in_range  : in std_logic;

        start_attempt : out std_logic;
        reset_attempt : out std_logic;

        running       : out std_logic;
        final_screen  : out std_logic;
        show_result   : out std_logic;
        accept_btnU   : out std_logic;

        result0 : out std_logic_vector(WIDTH-1 downto 0);
        result1 : out std_logic_vector(WIDTH-1 downto 0);
        result2 : out std_logic_vector(WIDTH-1 downto 0);

        neg0 : out std_logic;
        neg1 : out std_logic;
        neg2 : out std_logic;

        fail0 : out std_logic;
        fail1 : out std_logic;
        fail2 : out std_logic
    );
end control_attemp;

architecture Behavioral of control_attemp is

    type state_type is (
        T_WAIT_START,
        T_START_ATTEMPT,
        T_RUNNING_ATTEMPT,
        T_WAIT_BOTH_DONE,
        T_STORE_RESULT,
        T_SHOW_RESULT_1S,
        T_RESET_ATTEMPT,
        T_SHOW_FINAL
    );

    type result_array is array (0 to 2) of std_logic_vector(WIDTH-1 downto 0);
    type bit_array    is array (0 to 2) of std_logic;

    constant RESULT_WAIT_COUNT : integer := CLK_FREQ_HZ - 1;

    signal state : state_type := T_WAIT_START;

    signal attempt_index : integer range 0 to 2 := 0;
    signal result_wait_counter : integer range 0 to RESULT_WAIT_COUNT := 0;

    signal stored_result : result_array := (others => (others => '0'));
    signal stored_neg    : bit_array := (others => '0');
    signal stored_fail   : bit_array := (others => '0');

    signal start_attempt_s : std_logic := '0';
    signal reset_attempt_s : std_logic := '0';
    signal running_s       : std_logic := '0';
    signal final_screen_s  : std_logic := '0';

begin

    start_attempt <= start_attempt_s;
    reset_attempt <= reset_attempt_s;

    running      <= running_s;
    final_screen <= final_screen_s;

    show_result <= '1' when state = T_SHOW_RESULT_1S else '0';

    accept_btnU <= '1' when state = T_RUNNING_ATTEMPT or state = T_WAIT_BOTH_DONE else '0';

    result0 <= stored_result(0);
    result1 <= stored_result(1);
    result2 <= stored_result(2);

    neg0 <= stored_neg(0);
    neg1 <= stored_neg(1);
    neg2 <= stored_neg(2);

    fail0 <= stored_fail(0);
    fail1 <= stored_fail(1);
    fail2 <= stored_fail(2);

    process(clk)
    begin
        if rising_edge(clk) then

            start_attempt_s <= '0';
            reset_attempt_s <= '0';

            if reset_all = '1' then

                state <= T_WAIT_START;

                running_s <= '0';
                final_screen_s <= '0';

                attempt_index <= 0;
                result_wait_counter <= 0;

                stored_result <= (others => (others => '0'));
                stored_neg    <= (others => '0');
                stored_fail   <= (others => '0');

            else

                case state is

                    when T_WAIT_START =>

                        running_s <= '0';
                        final_screen_s <= '0';

                        if btnC_edge = '1' then
                            start_attempt_s <= '1';
                            running_s <= '0';
                            state <= T_START_ATTEMPT;
                        end if;

                    when T_START_ATTEMPT =>

                        running_s <= '1';
                        state <= T_RUNNING_ATTEMPT;

                    when T_RUNNING_ATTEMPT =>

                        if done1 = '1' then
                            running_s <= '0';

                            if done2 = '1' then
                                state <= T_STORE_RESULT;
                            else
                                state <= T_WAIT_BOTH_DONE;
                            end if;

                        else
                            running_s <= '1';
                        end if;

                    when T_WAIT_BOTH_DONE =>

                        running_s <= '0';

                        if done1 = '1' and done2 = '1' then
                            state <= T_STORE_RESULT;
                        end if;

                    when T_STORE_RESULT =>

                        stored_result(attempt_index) <= result_in;
                        stored_neg(attempt_index)    <= negative;

                        if in_range = '1' then
                            stored_fail(attempt_index) <= '0';
                        else
                            stored_fail(attempt_index) <= '1';
                        end if;

                        result_wait_counter <= 0;
                        state <= T_SHOW_RESULT_1S;

                    when T_SHOW_RESULT_1S =>

                        running_s <= '0';

                        if result_wait_counter = RESULT_WAIT_COUNT then
                            result_wait_counter <= 0;

                            if attempt_index = 2 then
                                state <= T_SHOW_FINAL;
                                final_screen_s <= '1';
                            else
                                attempt_index <= attempt_index + 1;
                                state <= T_RESET_ATTEMPT;
                            end if;

                        else
                            result_wait_counter <= result_wait_counter + 1;
                        end if;

                    when T_RESET_ATTEMPT =>

                        reset_attempt_s <= '1';
                        running_s <= '0';
                        final_screen_s <= '0';

                        state <= T_WAIT_START;

                    when T_SHOW_FINAL =>

                        running_s <= '0';
                        final_screen_s <= '1';

                    when others =>

                        state <= T_WAIT_START;

                end case;

            end if;

        end if;
    end process;

end Behavioral;