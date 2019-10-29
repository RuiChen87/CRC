close all
clear
clc

width = 8;
refin = 0;
refout = 0;
init = 0;
xorval = 0;

crc = CRC_matlab([47], width, init, refin, refout, xorval);
crc = dec2hex(crc, width/4);


