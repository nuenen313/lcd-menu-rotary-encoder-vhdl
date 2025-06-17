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
        clk  : in  STD_LOGIC;
        LCD_RS      : out STD_LOGIC;
        LCD_E       : out STD_LOGIC;
        LCD_DB    : out STD_LOGIC_VECTOR (3 DOWNTO 0);
        LEDS : out STD_LOGIC_VECTOR(3 downto 0)
    );
end lcd_menu;

architecture Behavioral of lcd_menu is
    TYPE STATE_TYPE IS (
        HOLD, FUNC_SET, DISPLAY_ON, MODE_SET, SEND_CHARS,
        RETURN_HOME, SEND_UPPER, SEND_LOWER, TOGGLE_E, UNTOGGLE_E, INIT,
        INIT1, INIT2, INIT3, INIT4, DISPLAY_OFF, DISPLAY_CLEAR
    );
    TYPE MENU_STATE IS (DANE, IMIE, NAZWISKO, INDEKS, WROC);
    signal state         : STATE_TYPE := INIT;
    signal next_command  : STATE_TYPE := FUNC_SET;
    signal lcd_menu_state : MENU_STATE := DANE;
    signal DATA_BUS_VALUE: STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    signal clk_3ms    : STD_LOGIC := '0';
    signal clk_3msCNT : integer range 0 to 250000 := 0;
    signal char_no       : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal DOUT          : STD_LOGIC_VECTOR (7 DOWNTO 0);
    shared variable line : STD_LOGIC := '0';
    signal reset_cnt     : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal znak          : STD_LOGIC_VECTOR (7 DOWNTO 0) := "10000001";
    signal ready         : boolean := true;
    constant DELAY_20MS : integer := 2000000;
    constant DELAY_22_5MS : integer := 2250000;
    constant DELAY_27_5MS : integer := 2750000;
    constant DELAY_30MS : integer := 3000000;
    constant DELAY_100MS : integer := 20000000;
    signal counter_20ms : unsigned(27 downto 0) := (others => '0');
    signal counter_100ms : unsigned(27 downto 0) := (others => '0'); 
    signal button_prev : std_logic := '0';
    signal button_rise : std_logic := '0';
    signal clk_3ms_tick : std_logic := '0';
    signal clk_3ms_cnt : integer range 0 to 250000 := 0;
    signal init_step : integer range 0 to 3 := 0;

begin
    DOUT <= znak;
    process(clk)
    begin
        if rising_edge(clk) then
            if Dreset = '1' then
                clk_3msCNT <= 0;
                clk_3ms <= '0';
                counter_20ms <= (others => '0');
            else
                --clk_3msCNT <= clk_3msCNT + 1;
                --if clk_3msCNT = 250000 then
                    --clk_3msCNT <= 0;
                    --clk_3ms <= not clk_3ms;
                --end if;
                if clk_3ms_cnt = 249999 then
                    clk_3ms_cnt <= 0;
                    clk_3ms_tick <= '1';
                else
                    clk_3ms_cnt <= clk_3ms_cnt + 1;
                    clk_3ms_tick <= '0';
                end if;
                counter_20ms <= counter_20ms + 1;
                if counter_20ms > DELAY_20MS then
                    counter_20ms <= (others => '0');
                end if;
                button_rise <= '0';
                if Button = '1' and button_prev = '0' then
                    button_rise <= '1'; 
                end if;
                button_prev <= Button;
            end if;
        end if;
    end process;
    process(clk, clk_3ms, Dreset, lcd_menu_state, position, change, Button)
    begin
        LEDS(3 downto 1) <= position(2 downto 0);
        LEDS(0) <= change;
        if Dreset = '1' then
           DATA_BUS_VALUE <= "00000011";
           LCD_E <= '1';
           LCD_RS <= '0';
           line := '0';
           char_no <= (others => '0');
           state <= INIT;
           next_command <= FUNC_SET;
           lcd_menu_state <= DANE;
        elsif rising_edge(clk) then
            case lcd_menu_state is
                when DANE =>
                    if counter_100ms < DELAY_100MS then
                          counter_100ms <= counter_100ms +1;
                    end if;
                    if button_rise = '1' then
                       lcd_menu_state <= IMIE;
                       state <= DISPLAY_CLEAR;
                       LCD_E <= '1';
                       LCD_RS <= '0';
                       line := '0';
                       char_no <= (others => '0');
                    end if;
                    counter_20ms <= (others => '0');
                when IMIE =>
                    if counter_100ms < DELAY_100MS then
                         counter_100ms <= counter_100ms +1;
                    end if;
                    if change='1' then
                        if position = "100" then
                                lcd_menu_state <= NAZWISKO;
                                state <= DISPLAY_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_no <= (others => '0');
                         end if;
                     end if;
                     counter_100ms <= (others => '0');
                 when NAZWISKO =>
                    if counter_100ms < DELAY_100MS then
                       counter_100ms <= counter_100ms +1;
                    end if;
                    if change = '1' then
                        if position = "100" then
                                lcd_menu_state <= INDEKS;
                                state <= DISPLAY_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_no <= (others => '0');
                         elsif position = "001" then
                                lcd_menu_state <= IMIE;
                                state <= DISPLAY_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_no <= (others => '0');
                         end if;
                     end if;
                     counter_100ms <= (others => '0');
                 when INDEKS => 
                  if counter_100ms < DELAY_100MS then
                     counter_100ms <= counter_100ms +1;
                  end if;
                    if change = '1' then
                        if position = "100" then
                                lcd_menu_state <= WROC;
                                state <= DISPLAY_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_no <= (others => '0');    
                         elsif position = "001" then
                                lcd_menu_state <= NAZWISKO;
                                state <= DISPLAY_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_no <= (others => '0');
                         end if;
                     end if;
                      counter_100ms <= (others => '0');
                 when WROC =>
                 if counter_100ms < DELAY_100MS then
                    counter_100ms <= counter_100ms +1;
                  end if;
                    if change = '1' then
                        if position = "001" then
                                lcd_menu_state <= INDEKS;
                                state <= DISPLAY_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_no <= (others => '0');    
                         end if;
                         elsif button_rise = '1' then
                                lcd_menu_state <= DANE;
                                state <= DISPLAY_CLEAR;
                                LCD_E <= '1';
                                LCD_RS <= '0';
                                line := '0';
                                char_no <= (others => '0');
                        end if;
                        counter_100ms <= (others => '0');
                 when others =>
                    lcd_menu_state <= INDEKS;
            end case;
            if clk_3ms_tick = '1' then
            case state is
                when INIT =>
                    LCD_RS <= '0';
                    case init_step is
                        when 0 =>
                            DATA_BUS_VALUE <= "00000011";
                            reset_cnt <= reset_cnt + 1;
                            if reset_cnt = "1001" then
                                init_step <= 1;
                                reset_cnt <= (others => '0');
                            end if;
                        when 1 =>
                            DATA_BUS_VALUE <= "00000011";
                            reset_cnt <= reset_cnt + 1;
                            if reset_cnt = "1011" then
                                init_step <= 2;
                                reset_cnt <= (others => '0');
                            end if;
                        when 2 =>
                            DATA_BUS_VALUE <= "00000011";
                            reset_cnt <= reset_cnt + 1;
                            if reset_cnt = "1100" then
                                init_step <= 3;
                                reset_cnt <= (others => '0');
                            end if;
                        when 3 =>
                            DATA_BUS_VALUE <= "00000010";
                            next_command <= FUNC_SET;
                            state <= SEND_LOWER;
                    end case;
                when FUNC_SET =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00101000";
                    next_command <= DISPLAY_OFF;
                    state <= SEND_UPPER;
                when DISPLAY_OFF =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00001000";
                    next_command <= DISPLAY_CLEAR;
                    state <= SEND_UPPER;
                when DISPLAY_CLEAR =>
                    LCD_RS <= '0';
                    DATA_BUS_VALUE <= "00000001";
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
                    next_command <= SEND_CHARS;
                    state <= SEND_UPPER;
                when SEND_CHARS =>
                    if char_no = "10111" then
                        state <= HOLD;
                        next_command <= HOLD;
                    elsif char_no = "01001" and line = '0' and lcd_menu_state = NAZWISKO then
                        LCD_RS <= '0';
                        DATA_BUS_VALUE <= "11000000";
                        line := '1';
                        state <= SEND_UPPER;
                        next_command <= SEND_CHARS;
                    else
                        LCD_RS <= '1';
                        char_no <= char_no + 1;
                        state <= SEND_UPPER;
                        next_command <= SEND_CHARS;
                        DATA_BUS_VALUE <= DOUT;
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
                    state <= UNTOGGLE_E;
                when UNTOGGLE_E =>
                    LCD_E <= '0';
                    state <= HOLD;
                when HOLD =>
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
        end if;
    end process;
    
    process(clk_3ms, Dreset)
    begin
        if rising_edge(clk_3ms) then
            if state = SEND_CHARS then
                if lcd_menu_state = DANE then
                    case char_no is 
                        when "00000" => znak <= CHAR_D;
                        when "00001" => znak <= CHAR_A;
                        when "00010" => znak <= CHAR_N;
                        when "00011" => znak <= CHAR_E;
                        when others  => znak <= CHAR_SPACJA;
                    end case;
                elsif lcd_menu_state = IMIE then
                    case char_no is
                        when "00000" => znak <= CHAR_I; 
                        when "00001" => znak <= CHAR_M; 
                        when "00010" => znak <= CHAR_I; 
                        when "00011" => znak <= CHAR_E;
                        when "00100" => znak <= CHAR_DWUKROP;
                        when "00101" => znak <= CHAR_SPACJA;
                        when "00111" => znak <= CHAR_M;
                        when "01000" => znak <= CHAR_a_male;
                        when "01001" => znak <= CHAR_r_male;
                        when "01010" => znak <= CHAR_t_male;
                        when "01011" => znak <= CHAR_a_male;
                        when others  => znak <= CHAR_SPACJA;
                    end case;
                 elsif lcd_menu_state = INDEKS then
                    case char_no is
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
                    case char_no is 
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
                    case char_no is
                        when "00000" => znak <= CHAR_P; 
                        when "00001" => znak <= CHAR_o_male;
                        when "00010" => znak <= CHAR_w_male;
                        when "00011" => znak <= CHAR_r_male; 
                        when "00100" => znak <= CHAR_o_male;
                        when "00101" => znak <= CHAR_t_male;
                        when others  => znak <= CHAR_SPACJA;
                    end case;
                 end if;
            end if;
        end if;
    end process;

end Behavioral;
