library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Vhdl1 is
    Port (
        clk     : in  STD_LOGIC;       -- Clock input
        reset   : in  STD_LOGIC;       -- Asynchronous reset
        NS_red  : out STD_LOGIC;       -- North-South Red
        NS_yel  : out STD_LOGIC;       -- North-South Yellow
        NS_grn  : out STD_LOGIC;       -- North-South Green
        EW_red  : out STD_LOGIC;       -- East-West Red
        EW_yel  : out STD_LOGIC;       -- East-West Yellow
        EW_grn  : out STD_LOGIC        -- East-West Green
    );
end Vhdl1;

architecture Behavioral of Vhdl1 is

    type state_type is (NS_Green, NS_Yellow, EW_Green, EW_Yellow);
    signal state, next_state : state_type;
    signal counter : integer range 0 to 15 := 0; -- timer counter

begin

    -- Sequential process: state transition
    process(clk, reset)
    begin
        if reset = '1' then
            state <= NS_Green;
            counter <= 0;
        elsif rising_edge(clk) then
            if counter = 15 then
                state <= next_state;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Combinational process: next state logic
    process(state)
    begin
        case state is
            when NS_Green =>
                next_state <= NS_Yellow;
            when NS_Yellow =>
                next_state <= EW_Green;
            when EW_Green =>
                next_state <= EW_Yellow;
            when EW_Yellow =>
                next_state <= NS_Green;
            when others =>
                next_state <= NS_Green;
        end case;
    end process;

    -- Output logic for lights
    process(state)
    begin
        -- Default all lights off
        NS_red <= '0';
        NS_yel <= '0';
        NS_grn <= '0';
        EW_red <= '0';
        EW_yel <= '0';
        EW_grn <= '0';

        case state is
            when NS_Green =>
                NS_grn <= '1';
                EW_red <= '1';
            when NS_Yellow =>
                NS_yel <= '1';
                EW_red <= '1';
            when EW_Green =>
                EW_grn <= '1';
                NS_red <= '1';
            when EW_Yellow =>
                EW_yel <= '1';
                NS_red <= '1';
            when others =>
                NS_red <= '1';
                EW_red <= '1';
        end case;
    end process;

end Behavioral;
