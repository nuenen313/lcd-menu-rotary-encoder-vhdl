----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2025 15:57:18
-- Design Name: 
-- Module Name: lcdmenu - Behavioral
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
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.lcd_chars.all;

entity lcd_menu is
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
end lcd_menu;

architecture Behavioral of lcd_menu is
    TYPE STATE_TYPE IS (
        HOLD, FUNC_SET, DISPLAY_ON, MODE_SET, WRITE_CHAR,
        RETURN_HOME, SEND_UPPER, SEND_LOWER, TOGGLE_E, TOGGLE_E2,
        INIT1, INIT2, INIT3, INIT4,
        DISP_OFF, DISP_CLEAR
    );
    TYPE MENU_STATE IS (DANE, IMIE, NAZWISKO, INDEKS, WROC, EKRAN2, PODEKRAN1);
    signal state         : STATE_TYPE := INIT1;
    signal next_command  : STATE_TYPE := INIT2;
    signal lcd_menu_state : MENU_STATE := DANE;
    signal actual_lcd_state : MENU_STATE := DANE;
    signal DATA_BUS_VALUE: STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    signal clk_3ms    : STD_LOGIC := '0';
    signal clk_3msCNT : integer range 0 to 250000 := 0;
    signal char_cnt       : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal DOUT          : STD_LOGIC_VECTOR (7 DOWNTO 0);
    shared variable line : STD_LOGIC := '0';
    signal reset_cnt     : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal znak          : STD_LOGIC_VECTOR (7 DOWNTO 0) := "10000001";
    signal ready         : boolean := true;
    constant DELAY_20MS : integer := 2000000;
    constant DELAY_100MS : integer := 20000000;
    signal counter_100ms : unsigned(27 downto 0) := (others => '0'); 
    signal done_writing :std_logic := '0';

begin
    DOUT <= znak;
    process(clk)
    begin
        if rising_edge(clk) then
            if Dreset = '1' then
                clk_3msCNT <= 0;
                clk_3ms <= '0';
            else
                clk_3msCNT <= clk_3msCNT + 1;
                if clk_3msCNT = 250000 then
                    clk_3msCNT <= 0;
                    clk_3ms <= not clk_3ms;
                end if;
            end if;
        end if;
    end process;
    process(clk, clk_3ms, Dreset, lcd_menu_state, actual_lcd_state, position, change, Button, Button2, done_writing)
    begin
        LEDS(3 downto 1) <= position(2 downto 0);
        LEDS(0) <= change;
        if Dreset = '1' then
           DATA_BUS_VALUE <= "00000011";
           LCD_E <= '1';
           LCD_RS <= '0';
           line := '0';
           char_cnt <= (others => '0');
           state <= INIT1;
           next_command <= INIT2;
           lcd_menu_state <= DANE;
           actual_lcd_state <= DANE;
        elsif rising_edge(clk_3ms) then
            if state = HOLD then
            case lcd_menu_state is
                when DANE =>
                    if done_writing = '1' then
                    if Button = '1' then
                       lcd_menu_state <= IMIE;
                       state <= DISP_CLEAR;
                       LCD_E <= '1';
                       LCD_RS <= '0';
                       line := '0';
                       char_cnt <= (others => '0');
                    end if;
                    if change ='1' then
                        if position = "100" then
                                lcd_menu_state <= EKRAN2;
                                state <= DISP_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_cnt <= (others => '0');
                         end if;
                    END IF;
                    end if;
                when IMIE =>
                    if done_writing = '1' then
                    if change='1' then
                        if position = "100" then
                                lcd_menu_state <= NAZWISKO;
                                state <= DISP_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_cnt <= (others => '0');
                         end if;
                     end if;
                     end if;
                 when NAZWISKO =>
                    if done_writing = '1' then
                    if change = '1' then
                        if position = "100" then
                                lcd_menu_state <= INDEKS;
                                state <= DISP_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_cnt <= (others => '0');
                         elsif position = "001" then
                                lcd_menu_state <= IMIE;
                                state <= DISP_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_cnt <= (others => '0');
                         end if;
                     end if;
                    end if;
                 when INDEKS => 
                  if done_writing = '1' then
                    if change = '1' then
                        if position = "100" then
                                lcd_menu_state <= WROC;
                                state <= DISP_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_cnt <= (others => '0');    
                         elsif position = "001" then
                                lcd_menu_state <= NAZWISKO;
                                state <= DISP_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_cnt <= (others => '0');
                         end if;
                     end if;
                   end if;
                 when WROC =>
                 if done_writing = '1' then
                    if change = '1' then
                        if position = "001" then
                                lcd_menu_state <= INDEKS;
                                state <= DISP_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_cnt <= (others => '0');    
                         end if;
                         elsif Button2 = '1' then
                                lcd_menu_state <= DANE;
                                state <= DISP_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_cnt <= (others => '0');
                        end if;
                   end if;
                 when EKRAN2 => 
                 if done_writing = '1' then
                    if Button = '1' then
                        lcd_menu_state <= PODEKRAN1;
                        state <= DISP_CLEAR;
                        LCD_E <= '1';
                        LCD_RS <= '0';
                        line := '0';
                        char_cnt <= (others => '0');
                    end if;
                    if change = '1' then
                        if position ="001" then
                            lcd_menu_state <= DANE;
                                state <= DISP_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_cnt <= (others => '0');
                       end if;
                    end if;
                 end if;
                 when PODEKRAN1 =>
                   if done_writing = '1' then
                    if Button2 = '1' then
                        lcd_menu_state <= EKRAN2;
                        state <= DISP_CLEAR;
                        LCD_E <= '1';
                        LCD_RS <= '0';
                        line := '0';
                        char_cnt <= (others => '0');
                    end if;
                   end if;
                 when others =>
                    lcd_menu_state <= INDEKS;
            end case;
            end if;
            case state is
                when INIT1 =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00000011";
                    reset_cnt <= reset_cnt + 1;
                    if reset_cnt = "1001" then
                        next_command <= INIT2;
                        state <= SEND_LOWER;
                    end if;
                when INIT2 =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00000011";
                    reset_cnt <= reset_cnt + 1;
                    if reset_cnt = "1011" then
                        next_command <= INIT3;
                        state <= SEND_LOWER;
                    end if;
                when INIT3 =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00000011";
                    reset_cnt <= reset_cnt + 1;
                    if reset_cnt = "1100" then --DELAY30ms
                        next_command <= INIT4;
                        state <= SEND_LOWER;
                    end if;
                when INIT4 =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00000010";
                    next_command <= FUNC_SET;
                    state <= SEND_LOWER;
                when FUNC_SET =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00101000";
                    next_command <= DISP_OFF;
                    state <= SEND_UPPER;
                when DISP_OFF =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00001000";
                    next_command <= DISP_CLEAR;
                    state <= SEND_UPPER;
                when DISP_CLEAR =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00000001";
                    done_writing <= '0';
                    next_command <= DISPLAY_ON;
                    state <= SEND_UPPER;
                when DISPLAY_ON =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00001100";
                    next_command <= MODE_SET;
                    state <= SEND_UPPER;
                when MODE_SET =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00000110";
                    next_command <= RETURN_HOME;
                    state <= SEND_UPPER;
                when RETURN_HOME =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00000010";
                    next_command <= WRITE_CHAR;
                    state <= SEND_UPPER;
                when WRITE_CHAR =>
                    if char_cnt = "10111" then
                        state <= HOLD;
                        next_command <= HOLD;
                    elsif char_cnt = "01001" and line = '0' and lcd_menu_state = NAZWISKO then
                        LCD_RS <= '0';
                        DATA_BUS_VALUE <= "11000000";
                        line := '1';
                        state <= SEND_UPPER;
                        next_command <= WRITE_CHAR;
                    else
                        LCD_RS <= '1';
                        DATA_BUS_VALUE <= DOUT;
                        char_cnt <= char_cnt + 1;
                        state <= SEND_UPPER;
                        next_command <= WRITE_CHAR;
                    end if;
                when SEND_UPPER =>
                    LCD_E <= '1';
                    LCD_DB <= DATA_BUS_VALUE(7 downto 4);
                    state <= TOGGLE_E;
                when TOGGLE_E =>
                    LCD_E <= '0';
                    state <= SEND_LOWER;
                when SEND_LOWER =>
                    LCD_E <= '1';
                    LCD_DB <= DATA_BUS_VALUE(3 downto 0);
                    state <= TOGGLE_E2;
                when TOGGLE_E2 =>
                    LCD_E <= '0';
                    state <= HOLD;
                when HOLD =>
                    done_writing <= '1';
                    if ready then
                        LCD_E <= '1';
                        state <= next_command;
                        ready <= false;
                    else
                        ready <= true;
                    end if;
                when others =>
                    state <= next_command;
            end case;
        end if;
        if rising_edge(clk_3ms) then
            if lcd_menu_state /= actual_lcd_state then
                state <= DISP_CLEAR;
                LCD_E <= '1';
                LCD_RS <= '0';
                line := '0';
                char_cnt <= (others => '0');
                case lcd_menu_state is 
                    when DANE =>
                        lcd_menu_state <= DANE;
                    when IMIE =>
                        lcd_menu_state <= IMIE;
                    when NAZWISKO =>
                        lcd_menu_state <= NAZWISKO;
                    when INDEKS =>
                        lcd_menu_state <= INDEKS;
                    when WROC =>
                        lcd_menu_state <= WROC;
                    when EKRAN2 =>
                        lcd_menu_state <= EKRAN2;
                    when PODEKRAN1 => 
                        lcd_menu_state <= PODEKRAN1;
                    when others => lcd_menu_state <= DANE;
               end case;
               actual_lcd_state <= lcd_menu_state;
            end if;
            if state = WRITE_CHAR then
                if lcd_menu_state = DANE then
                    actual_lcd_state <= DANE;
                    case char_cnt is 
                        when "00000" => znak <= CHAR_D;
                        when "00001" => znak <= CHAR_A;
                        when "00010" => znak <= CHAR_N;
                        when "00011" => znak <= CHAR_E;
                        when others  => znak <= CHAR_SPACJA;
                    end case;
                elsif lcd_menu_state = IMIE then
                    actual_lcd_state <= IMIE;
                    case char_cnt is
                        when "00000" => znak <= CHAR_I; 
                        when "00001" => znak <= CHAR_M; 
                        when "00010" => znak <= CHAR_I; 
                        when "00011" => znak <= CHAR_E; -- E
                        when "00100" => znak <= CHAR_DWUKROP; -- :
                        when "00101" => znak <= CHAR_SPACJA; -- spacja
                        when "00111" => znak <= CHAR_M;
                        when "01000" => znak <= CHAR_a_male;
                        when "01001" => znak <= CHAR_r_male;
                        when "01010" => znak <= CHAR_t_male;
                        when "01011" => znak <= CHAR_a_male;
                        when others  => znak <= CHAR_SPACJA;
                    end case;
                 elsif lcd_menu_state = INDEKS then
                    actual_lcd_state <= INDEKS;
                    case char_cnt is
                        when "00000" => znak <= CHAR_I; 
                        when "00001" => znak <= CHAR_N;
                        when "00010" => znak <= CHAR_D;
                        when "00011" => znak <= CHAR_E;
                        when "00100" => znak <= CHAR_K;
                        when "00101" => znak <= CHAR_S;
                        when "00110" => znak <= CHAR_DWUKROP;
                        when "00111" => znak <= CHAR_SPACJA;
                        when "01000" => znak <= CHAR_2;
                        when "01001" => znak <= CHAR_5;
                        when "01010" => znak <= CHAR_2;
                        when "01011" => znak <= CHAR_6;
                        when "01100" => znak <= CHAR_2;
                        when "01101" => znak <= CHAR_7;
                        when others => znak <= CHAR_SPACJA;
                    end case;
                 elsif lcd_menu_state = NAZWISKO then
                    actual_lcd_state <= NAZWISKO;
                    case char_cnt is 
                        when "00000" => znak <= CHAR_N;
                        when "00001" => znak <= CHAR_A;
                        when "00010" => znak <= CHAR_Z;
                        when "00011" => znak <= CHAR_W;
                        when "00100" => znak <= CHAR_I;
                        when "00101" => znak <= CHAR_S;
                        when "00110" => znak <= CHAR_K;
                        when "00111" => znak <= CHAR_O;
                        when "01000" => znak <= CHAR_DWUKROP; 
                        when "01001" => znak <= CHAR_SPACJA;
                        when "01010" => znak <= CHAR_O;
                        when "01011" => znak <= CHAR_s_male;
                        when "01100" => znak <= CHAR_t_male;
                        when "01101" => znak <= CHAR_r_male;
                        when "01110" => znak <= CHAR_o_male;
                        when "01111" => znak <= CHAR_w_male;
                        when "10000" => znak <= CHAR_s_male;
                        when "10001" => znak <= CHAR_k_male;
                        when "10010" => znak <= CHAR_a_male;
                        when others => znak <= CHAR_SPACJA;
                    end case;
                 elsif lcd_menu_state = WROC then
                    actual_lcd_state <= WROC;
                    case char_cnt is
                        when "00000" => znak <= CHAR_P; 
                        when "00001" => znak <= CHAR_o_male;
                        when "00010" => znak <= CHAR_w_male;
                        when "00011" => znak <= CHAR_r_male; 
                        when "00100" => znak <= CHAR_o_male;
                        when "00101" => znak <= CHAR_t_male;
                        when others  => znak <= CHAR_SPACJA;
                    end case;
                 elsif lcd_menu_state = EKRAN2 then
                    actual_lcd_state <= EKRAN2;
                    case char_cnt is 
                        when "00000" => znak <= CHAR_E;
                        when "00001" => znak <= CHAR_k_male;
                        when "00010" => znak <= CHAR_r_male;
                        when "00011" => znak <= CHAR_a_male;
                        when "00100" => znak <= CHAR_n_male;
                        when "00101" => znak <= CHAR_2;
                        when others => znak <= CHAR_SPACJA;
                        end case;
                 elsif lcd_menu_state = PODEKRAN1 then
                    actual_lcd_state <= PODEKRAN1;
                    case char_cnt is 
                        when "00000" => znak <= CHAR_P;
                        when "00001" => znak <= CHAR_o_male;
                        when "00010" => znak <= CHAR_d_male;
                        when "00011" => znak <= CHAR_e_male; 
                        when "00100" => znak <= CHAR_k_male;
                        when "00101" => znak <= CHAR_r_male;
                        when "00110" => znak <= CHAR_a_male;
                        when "00111" => znak <= CHAR_n_male;
                         when others => znak <= CHAR_SPACJA;
                    end case;
                 end if;
            end if;
        end if;
    end process;

end Behavioral;
