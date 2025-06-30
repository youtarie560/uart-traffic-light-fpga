library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity baud_rate_generator_behavior is

    port (
        clk       : in  std_logic;
        reset_n   : in  std_logic;
        enable    : in  std_logic;
        FINAL_VALUE : in  std_logic_vector(4 - 1 downto 0);
        s_tick      : out std_logic
    );
end entity baud_rate_generator_behavior;

architecture behavioral of baud_rate_generator_behavior is
    signal Q_reg, Q_next : unsigned(4 - 1 downto 0);
    signal done_internal : std_logic;  -- Internal signal

begin

    process (clk, reset_n)
    begin
        if reset_n = '0' then
            Q_reg <= to_unsigned(0, 4);
        elsif rising_edge(clk) then
            if enable = '1' then
                Q_reg <= Q_next;
            end if;
        end if;
    end process;

    -- Assign the output to the internal signal
    done_internal <= '1' when Q_reg = unsigned(FINAL_VALUE) else '0';

    -- Use done_internal in your logic
    process (Q_reg, FINAL_VALUE)  -- Combinational process for Q_next
    begin
        if done_internal = '1' then 
            Q_next <= to_unsigned(0, 4);
        else
            Q_next <= Q_reg + 1;
        end if;
    end process;

    -- Finally, assign the internal signal to the output port
    s_tick <= done_internal; 

end architecture behavioral;