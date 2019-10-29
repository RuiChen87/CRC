close all
clear
clc

width = 16;
refin = 1;
refout = 1;
init = 'FFFF';
xorval = 'FFFF';

% ploy = '04C11DB7';
ploy = '8005';
ploy = hex2dec(ploy);

data = [47];


tab = gen_crc_table(ploy, width);
crc = calc_crc(data, tab, width, refin, refout, init, xorval);
crc = dec2hex(crc, width/4);

tab_ref = gen_crc_table_reflected(ploy, width, 1);
crc_ref = calc_crc_reflected(data, tab_ref, width, refin, refout, init, xorval);
crc_ref = dec2hex(crc_ref, width/4);

