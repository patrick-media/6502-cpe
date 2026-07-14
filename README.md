# 6502-cpe
**WARNING: This program was made very poorly, has not been refactored, and uses GLOBAL VARIABLES! Therefore, it is extremely unlikely to actually work unless its (admittedly simple) inner workings are very well understood!**

The Command Processing Enhancer (CPE) program flashes the contents of a provided binary file to an EEPROM connected to an Adruino EEPROM programmer circuit.

The CPE program first reads a binary file and copies it into program memory. The contents of the file are then converted into a string format stored in a buffer. The buffer contains formatted binary data that can be inserted into a pre-written Arduino sketch that is the EEPROM programmer--all that is left blank in it by default is the program to flash, which the CPE program fills based on the binary file provided. The CPE program then calls the ```arduino-cli``` tool and compiles and uploads the sketch to the Arduino plugged into the user's computer. The sketch will then automatically begin executing the EEPROM flashing program.

## Usage
```./cpe.exe -bin <file> -fqbn <fqbn> -cli <prog> -p <port> [-c]```

Arguments:\
```-bin```: Name of binary file to send to Arduino to flash EEPROM. Ex: ```... -bin my_program.bin ...```\
```-fqbn```: "Fully Qualified Board Name" field, required for arduino-cli. Ex: ```... -fqbn arduino:renesas_uno:minima ...```\
```-cli```: File path to the user's local arduino-cli executable. Note: if the location of the executable has been added to the PATH variable, only the name of the executable is needed. Ex (no PATH): ```... -cli C:\your\cli\arduino-cli ...```. Ex (PATH): ```... -cli arduino-cli ...```\
```-p```: Port specifier--choose whichever serial port your Arduino is connected to. Ex: ```... -p COM4 ...```\
```-c```: Compile-only mode--data will not be flashed to EEPROM, but the intermittent Arduino sketch file will be created. Useful for debugging potential problems in the stages between compilation and flashing. Ex: ```... -c ...```

Example usage:\
```./cpe.exe -bin test.bin -fqbn arduino:renesas_uno:minima -cli arduino-cli -p COM4```

## Misc. Notes
The ```src``` folder contains example 6502 programs and include-files that have been compiled using ```vasm``` and flashed using the CPE program.


**Notice:** CPE program files (```main.c```, ```cpe.h```, ```src/*```) last edited February-March 2024.
