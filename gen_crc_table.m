function crc_tab = gen_crc_table(ploy, width)
% 计算CRC码表
% input:
%   - ploy: int, 多项式
%   - width: 位宽，16，32等，8位的有待验证
%

if width == 32
    % crc_tab = cell(256, 1);
    crc_tab = uint32(zeros(256, 1));

    for i = 0 : 255
        crc = bitshift(uint32(i), width-8, 'uint32'); % int 4个字节，32位
        for j = 0:7
            if bitand(crc, hex2dec('80000000'))
                crc = uint32(bitxor(bitshift(crc, 1), ploy)); % bitshift：>0表示向左移位，<0表示向右移位
            else
                crc = bitshift(crc, 1);
            end
        end
    %     crc_tab{i+1} = dec2hex(crc,8);
        crc_tab(i+1) = uint32(crc);
    end
elseif width == 16
%     crc_tab = cell(256, 1);
    crc_tab = uint16(zeros(256, 1));

    for i = 0 : 255
        crc = bitshift(uint16(i), width-8, 'uint16'); % int 4个字节，32位
        for j = 0:7
            if bitand(crc, hex2dec('8000'))
                crc = uint16(bitxor(bitshift(crc, 1), ploy)); % bitshift：>0表示向左移位，<0表示向右移位
            else
                crc = bitshift(crc, 1);
            end
        end
%         crc_tab{i+1} = dec2hex(crc,4);
        crc_tab(i+1) = uint16(crc);
    end
end

end

