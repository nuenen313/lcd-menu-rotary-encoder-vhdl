----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.06.2025 13:23:44
-- Design Name: 
-- Module Name: lcd_char_package - Behavioral
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

package lcd_chars is
    constant CHAR_I : STD_LOGIC_VECTOR(7 downto 0) :=  "01001001"; -- I
    constant CHAR_M : STD_LOGIC_VECTOR(7 downto 0) := "01001101"; --M
    constant CHAR_E : STD_LOGIC_VECTOR(7 downto 0) := "01000101"; --E
    constant CHAR_DWUKROP : STD_LOGIC_VECTOR(7 downto 0) := "00111010"; -- dwukropek
    constant CHAR_SPACJA : STD_LOGIC_VECTOR(7 downto 0) := "00100000"; -- spacja
    constant CHAR_A : STD_LOGIC_VECTOR(7 downto 0) := "01000001"; --A
    constant CHAR_R : STD_LOGIC_VECTOR(7 downto 0) := "01010010"; -- R
    constant CHAR_T : STD_LOGIC_VECTOR(7 downto 0) := "01010100"; --T
    constant CHAR_N : STD_LOGIC_VECTOR(7 downto 0) := "01001110"; --N
    constant CHAR_D : STD_LOGIC_VECTOR(7 downto 0) := "01000100"; --D
    constant CHAR_K : STD_LOGIC_VECTOR(7 downto 0) := "01001011"; --K
    constant CHAR_S : STD_LOGIC_VECTOR(7 downto 0) := "01010011"; --S
    constant CHAR_2 : STD_LOGIC_VECTOR(7 downto 0) := "00110010"; --2
    constant CHAR_5 : STD_LOGIC_VECTOR(7 downto 0) := "00110101"; --5
    constant CHAR_6 : STD_LOGIC_VECTOR(7 downto 0) := "00110110"; --6
    constant CHAR_7 : STD_LOGIC_VECTOR(7 downto 0) := "00110111"; --7
    constant CHAR_Z : STD_LOGIC_VECTOR(7 downto 0) := "01011010"; 
    constant CHAR_W : STD_LOGIC_VECTOR(7 downto 0) := "01010111";
    constant CHAR_O : STD_LOGIC_VECTOR(7 downto 0) := "01001111";
    constant CHAR_C : STD_LOGIC_VECTOR(7 downto 0) := "01000011";
    constant CHAR_a_male : STD_LOGIC_VECTOR(7 downto 0) := "01100001";
    constant CHAR_P : STD_LOGIC_VECTOR(7 downto 0) := "01010000";
    constant CHAR_r_male : STD_LOGIC_VECTOR(7 downto 0) := "01110010";
    constant CHAR_t_male : STD_LOGIC_VECTOR(7 downto 0) := "01110100";
    constant CHAR_o_male : STD_LOGIC_VECTOR(7 downto 0) := "01101111";
    constant CHAR_s_male : STD_LOGIC_VECTOR(7 downto 0) := "01110011";
    constant CHAR_w_male : STD_LOGIC_VECTOR(7 downto 0) := "01110111";
    constant CHAR_k_male : STD_LOGIC_VECTOR(7 downto 0) := "01101011";
end package lcd_chars;