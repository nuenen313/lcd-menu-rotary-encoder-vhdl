----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.06.2025 15:31:28
-- Design Name: 
-- Module Name: projekt_main - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity projekt_main is
 Port (clk : in STD_LOGIC; 
        Encoder_A : in STD_LOGIC; 
        Encoder_B : in STD_LOGIC;
        Dreset : in STD_LOGIC; 
        Button       : in STD_LOGIC;
        Button2 : in STD_LOGIC;
        LCD_RS      : out STD_LOGIC;
        LCD_E       : out STD_LOGIC;
        LCD_DB    : out STD_LOGIC_VECTOR (3 DOWNTO 0);
        LED0_B : OUT STD_LOGIC;
        LEDS : out STD_LOGIC_VECTOR(3 downto 0) );
end projekt_main;

architecture Behavioral of projekt_main is
component enkoder is 
Port (
        clk         : in  STD_LOGIC;  
        Dreset       : in  STD_LOGIC;  
        Encoder_A   : in  STD_LOGIC;  
        Encoder_B   : in  STD_LOGIC; 
        position : out std_logic_vector(2 downto 0);
        change : out std_logic
    );
end component;
component lcd_menu is
    PORT(
        position : in std_logic_vector(2 downto 0);
        change : in STD_LOGIC;
        Dreset       : in  STD_LOGIC;
        Button       : in STD_LOGIC;
        Button2 : in STD_LOGIC;
        clk  : in  STD_LOGIC;
        LCD_RS      : out STD_LOGIC;
        LCD_E       : out STD_LOGIC;
        LCD_DB    : out STD_LOGIC_VECTOR (3 DOWNTO 0);
        LEDS : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

signal pos : std_logic_vector(2 downto 0); 
signal chg : std_logic;
begin
    blok1: enkoder port map (clk => clk, Dreset => Dreset, Encoder_A => Encoder_A,
        Encoder_B => Encoder_B,  position => pos, change => chg);
    blok2 : lcd_menu port map( position => pos, change => chg, Dreset => Dreset, Button => Button, Button2 => Button2,
            clk => clk, LCD_RS => LCD_RS, LCD_E => LCD_E, LCD_DB => LCD_DB, LEDS => LEDS);
    --blok2 : lcd_menu port map (position => pos, change => chg, Dreset => Dreset, Button => Button, Button2 => Button2,
        --clk => clk, LCD_RS => LCD_RS, LCD_E => LCD_E, LCD_DB => LCD_DB, LED0_B => LED0_B, LEDS => LEDS, 
        --VGA_B => VGA_B, VGA_G => VGA_G, VGA_R => VGA_R, Segment_A => Segment_A, Segment_B => Segment_B, Segment_C => Segment_C);
end Behavioral;
