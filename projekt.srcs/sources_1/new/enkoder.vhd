----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.06.2025 15:14:16
-- Design Name: 
-- Module Name: enkoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity enkoder is
    Port (
        clk         : in  STD_LOGIC;  
        Dreset       : in  STD_LOGIC;  
        Encoder_A   : in  STD_LOGIC;  
        Encoder_B   : in  STD_LOGIC; 
        --LEDS   : out STD_LOGIC_VECTOR(3 downto 0);
        --VGA_B : out STD_LOGIC; 
        --VGA_G : out STD_LOGIC;
        --VGA_R : out STD_LOGIC; 
        --VGA_HS : out STD_LOGIC; 
        position : out std_logic_vector(2 downto 0);
        change : out std_logic
    );
end enkoder;

architecture Behavioral of enkoder is
signal buffor: std_logic;
signal Aout : std_logic;
signal Bout : std_logic;
signal sampledA, sampledB : std_logic;
signal sclk : std_logic_vector(6 downto 0);
signal pos : std_logic_vector(2 downto 0) := (others => '0');
signal counter : unsigned(27 downto 0) := (others => '0');
constant DELAY_11MS : integer := 1100000; --(2mil=20ms, 900k =9ms, 90k=0.9ms)
begin
    process(clk, Encoder_A)
    begin
        if (rising_edge(clk)) then
            buffor <= Encoder_A;
        end if;
    end process;
    
    process(clk, Encoder_A, Encoder_B)
		begin 
			if clk'event and clk = '1' then
				sampledA <= Encoder_A;
				sampledB <= Encoder_B;
				if sclk = "1100100" then--co 1 uS zeby sie ogarnely te sygnaly
					if sampledA = Encoder_A then 
						Aout <= Encoder_A;
					end if;
					if sampledB = Encoder_B then 
						Bout <= Encoder_B;
					end if;
					sclk <="0000000";
				else
					sclk <= sclk +'1';
				end if;
			end if;
	end process;
    
    process(clk, Aout, Bout)
    begin
        if (rising_edge(clk)) then 
           -- pos <= 0;
            if (buffor = '1' AND Aout = '0') then
                if(Bout = '1') then
                    pos <= "001";
                    change <= '1';
                else 
                    pos <= "100";
                    change <= '1';
                end if;
            end if;
            if counter < DELAY_11MS then
                counter <= counter + 1;
            else
                change <= '0';
                counter <= (others => '0');
            end if;
       end if;
    end process;
    position <= pos;
end Behavioral;
