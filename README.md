# 6502-cpe
**WARNING: This program was made very poorly, has not been refactored, and uses GLOBAL VARIABLES! Therefore, it is extremely unlikely to actually work unless its (admittedly simple) inner workings are very well understood!**

This program follows a process that flashes the contents of a provided binary file to an EEPROM connected to an Arduino EEPROM programmer circuit, such as Ben Eater's design. The process begins with reading the binary file and copying it into (CPE) program memory. The contents of the binary file are then converted into a string format and appended to a program data buffer. An Arduino sketch file is created, ```out.ino```, where the contents of an EEPROM flashing program are placed, with the program data buffer inserted into the sketch program. The program data buffer can be changed depending on what the given binary file is, the convenience is how the CPE program automatically converts and formats the binary data into a string that can be used by the Arduino program to flash the EEPROM. The program then manually compiles the Arduino sketch using the provided ```arduino-cli``` tool, and then uploads the sketch to the Arduino plugged into the end-user's computer. The sketch will then automatically begin executing on the Adruino, and the EEPROM programmer will work as defined by the given Arduino sketch and data.

## Usage
```./cpe.exe -bin <file> -fqbn <fqbn> -cli <prog> -p <port> [-c]```

Arguments:\
```-bin```: Name of binary file to send to Arduino to flash EEPROM. Ex: ```... -bin my_program.bin ...```\
```-fqbn```: "Fully Qualified Board Name" field, required for arduino-cli. Ex: ```... -fqbn arduino:renesas_uno:minima ...```\
```-cli```: File path to the user's local arduino-cli executable. Note: if the location of the executable has been added to the PATH variable, only the name of the executable is needed. Ex (no PATH): ```... -cli C:\your\cli\arduino-cli ...```. Ex (PATH): ```... -cli arduino-cli ...```\
```-p```: Port specifier--choose whichever serial port your Arduino is connected to. Ex: ```... -p COM4 ...```\
```-c```: Compile-only mode--data will not be flashed to EEPROM, but the intermittent Arduino sketch file will be created. Useful for debugging potential problems in the stages between compilation and flashing. Ex: ```... -c ...```\

Example usage:\
```./cpe.exe -bin test.bin -fqbn arduino:renesas_uno:minima -cli arduino-cli -p COM4```
