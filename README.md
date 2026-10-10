# LCD Menu with Rotary Encoder (VHDL)

A multi-level menu on a character LCD, navigated with a rotary encoder and two buttons. Written in VHDL for the Digilent Arty A7-35T FPGA board.

## Features

- **LCD driver:** HD44780-compatible character LCD in 4-bit mode, with its own initialization sequence and command FSM
- **Rotary encoder decoder:** quadrature decoding with a 1 µs sampling glitch filter, outputting direction and a change pulse
- **Menu FSM:** 7 screens with encoder navigation, an enter button and a back button
- **Debug LEDs:** show the encoder direction and the change pulse

## Menu

```
Dane  <->  Ekran2
  | BTN1       | BTN1
  v            v
Imie <-> Nazwisko <-> Indeks <-> Powrot      Podekran
                                   | BTN2       | BTN2
                                   v            v
                                  Dane        Ekran2
```

`<->` = turn the encoder. Screens: Dane (data), Imię (first name), Nazwisko (last name), Indeks (student ID), Powrót (back), Ekran2 (screen 2), Podekran (subscreen).

## Ports

| Port | Direction | Function |
|---|---|---|
| `clk` | in | 100 MHz system clock |
| `Dreset` | in | Reset |
| `Encoder_A`, `Encoder_B` | in | Rotary encoder channels |
| `Button` | in | Enter |
| `Button2` | in | Back |
| `LCD_RS`, `LCD_E`, `LCD_DB[3:0]` | out | LCD (4-bit bus) |
| `LEDS[3:0]` | out | Encoder direction and change pulse |

## Repository layout

```
projekt.srcs/sources_1/new/
  projekt_main.vhd        Top level (encoder + LCD menu)
  enkoder.vhd             Rotary encoder decoder
  lcdmenu.vhd             LCD driver and menu FSM
  lcd_char_package.vhd    LCD character codes
projekt.xpr               Vivado project (XC7A35T)
```

To build, open `projekt.xpr` in Vivado 2025.1 and add the pin constraints for the PUL Arty Shield (`PUL_Arty_Shield.xdc`). The project expects that file one folder above the repo, and it isn't included. Then generate the bitstream and program the Arty A7.
