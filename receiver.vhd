library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity receiver is
    generic (
        DBIT    : integer := 8;
        SB_TICK : integer := 16
    );
    port (
        clk         : in  std_logic;
        reset_n     : in  std_logic;
        rx          : in  std_logic;
        s_tick      : in  std_logic;
        rx_done_tick : out std_logic;
        rx_dout     : out std_logic_vector(DBIT - 1 downto 0)
    );
end entity receiver;

architecture behavioral of receiver is

    type state_type is (idle, start, data, stop);
    signal state_reg, state_next : state_type;
    signal s_reg, s_next : unsigned(3 downto 0);   
    signal b_reg, b_next : std_logic_vector(DBIT - 1 downto 0);

    -- Calculate log2 of DBIT
    function log2 (x : integer) return integer is
        variable temp : integer := x;
        variable log : integer := 0;
    begin
        while temp > 1 loop
            temp := temp / 2;
            log := log + 1;
        end loop;
        return log;
    end function;
	     signal n_reg, n_next : unsigned(log2(DBIT) - 1 downto 0);  -- keep track of the number of data bits received


begin

    process (clk, reset_n)
    begin
        if reset_n = '0' then
            state_reg <= idle;
            s_reg <= to_unsigned(0, 4);
            n_reg <= to_unsigned(0, log2(DBIT));
            b_reg <= (others => '0');
        elsif rising_edge(clk) then
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end if;
    end process;

    -- Next state logic
    process (rx, s_tick, s_reg, n_reg, state_reg)
    begin
        state_next <= state_reg;
        s_next <= s_reg;
        n_next <= n_reg;
        b_next <= b_reg;
        rx_done_tick <= '0';

        case state_reg is
            when idle =>
                if rx = '0' then
                    s_next <= to_unsigned(0, 4);
                    state_next <= start;
                end if;

            when start =>
                if s_tick = '1' then
                    if s_reg = to_unsigned(7, 4) then
                        s_next <= to_unsigned(0, 4);
                        n_next <= to_unsigned(0, log2(DBIT));
                        state_next <= data;
                    else
                        s_next <= s_reg + 1;
                    end if;
                end if;

            when data =>
                if s_tick = '1' then
                    if s_reg = to_unsigned(15, 4) then
                        s_next <= to_unsigned(0, 4);
                        b_next <= rx & b_reg(DBIT - 1 downto 1);  -- Right shift
                        if n_reg = to_unsigned(DBIT - 1, log2(DBIT)) then
                            state_next <= stop;
                        else
                            n_next <= n_reg + 1;
                        end if;
                    else
                        s_next <= s_reg + 1;
                    end if;
                end if;

            when stop =>
                if s_tick = '1' then
                    if s_reg = to_unsigned(SB_TICK - 1, 4) then
                        rx_done_tick <= '1';
                        state_next <= idle;
                    else
                        s_next <= s_reg + 1;
                    end if;
                end if;

            when others =>
                state_next <= idle;
        end case;
    end process;

    -- Output logic
    rx_dout <= b_reg;

end architecture behavioral;