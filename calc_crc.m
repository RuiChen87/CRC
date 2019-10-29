function crc = calc_crc(data, tab, width, refin, refout, init, xorval)
% 计算CRC，正向
% input:
%   - data: 数据
%   - tab: CRC码表
%   - width: 位宽，8，16，32等
%   - refin: 是否对输入数据翻转，1-true, 0-false
%   - refout: 是否对输出数据翻转，1-true, 0-false
%   - init: 初始值，十六进制数，str
%   - xorval: 异或值，十六进制数，str
%
% CRC计算过程：
%   步骤1：初始化CRC寄存器
%   步骤2：根据refin，对输入数据每个字节进行处理得到temp
%   步骤3：CRC最高字节与temp异或，得到temp1=(CRC>>width-8)^temp
%   步骤4：CRC左移一个字节，得到CRC1=CRC<<8
%   步骤5：在table中查找信息并于CRC异或，CRC=table[temp1]^CRC1
%   步骤6：重复步骤2~5，知道处理完所有数据
%   步骤7：根据refout，对输出数据进行处理得到CRC
%   步骤8：与xorval异或，得到最终CRC
%

% 步骤1：初始化CRC
if width == 32
    crc = uint32(hex2dec(init));
    xorout = uint32(hex2dec(xorval));
elseif width == 16
    crc = uint16(hex2dec(init));
    xorout = uint16(hex2dec(xorval));
end

data_len = length(data);
for i = 1 : data_len
    tmp = data(i);
    
    % 步骤2：输入数据按字节翻转
    if refin
        tmp = dec2bin(tmp, 8);
        tmp = tmp(8:-1:1);
        tmp = bin2dec(tmp);
%         if width == 32
%             tmp = dec2bin(tmp, 32);
%             tmp1 = tmp(8:-1:1);
%             tmp2 = tmp(16:-1:9);
%             tmp3 = tmp(24:-1:17);
%             tmp4 = tmp(32:-1:25);
%             tmp = [tmp1, tmp2, tmp3, tmp4];
%             tmp = uint32(bin2dec(tmp));
%         elseif width == 16
%             tmp = dec2bin(tmp, 16);
%             tmp1 = tmp(8:-1:1);
%             tmp2 = tmp(16:-1:9);
%             tmp = [tmp1, tmp2];
%             tmp = uint16(bin2dec(tmp));
%         end
    end

    % 计算CRC
    temp1 = bitxor(bitshift(crc, 8-width), tmp); % 步骤3：CRC最高字节与tmp异或
    crc1 = bitshift(crc, 8); % 步骤4：CRC左移一个字节
    crc = bitxor(tab(temp1+1), crc1); % 步骤5：查找table，并于CRC1异或，这里+1，主要是由于matlab的index起始从1开始
end

% 步骤7：输出数据翻转
if refout
    if width == 32
        crc = dec2bin(crc, 32);
        crc = crc(end:-1:1);
        crc = uint32(bin2dec(crc));
    elseif width == 16
        crc = dec2bin(crc, 16);
        crc = crc(end:-1:1);
        crc = uint16(bin2dec(crc));
    end
    
end

% 步骤8：与异或值异或
crc = bitxor(crc, xorout);

end