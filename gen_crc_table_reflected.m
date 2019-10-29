function crc_tab = gen_crc_table_reflected(ploy, width, method)
% 反向计算CRC码表
% input:
%   - ploy: int, 多项式
%   - width: 位宽，16，32等，8位的有待验证
%   - method: 方法，0-直接计算，1-将正向计算得到的CRC码表按位翻转
%
% 这里有2种方法计算，一是直接计算，二是由正向计算得到的CRC码表转换

if method
    crc_tab1 = gen_crc_table(ploy, width);
    crc_len = length(crc_tab1);
    crc_tab = crc_tab1;
    for i = 1 : crc_len
        crc_tab(bit_reflect(i-1,8)+1) = bit_reflect(crc_tab1(i), width);
    end
    
else
    % 生成多项式反向
    if width == 32
        ploy = dec2bin(ploy, 32);
        ploy = ploy(end:-1:1);
        ploy = uint32(bin2dec(ploy));
    elseif width == 16
        ploy = dec2bin(ploy, 16);
        ploy = ploy(end:-1:1);
        ploy = uint16(bin2dec(ploy));
    elseif width == 8
        ploy = dec2bin(ploy, 8);
        ploy = ploy(end:-1:1);
        ploy = uint8(bin2dec(ploy));
    end

    if width == 32
    %     crc_tab = cell(256, 1);
        crc_tab = uint32(zeros(256, 1));

        for i = 0 : 255
            data = uint32(i);
            for j = 0:7
                if bitand(data, 1)
                    data = uint32(bitxor(bitshift(data, -1), ploy)); % bitshift：>0表示向左移位，<0表示向右移位
                else
                    data = bitshift(data, -1);
                end
            end
    %         crc_tab{i+1} = dec2hex(crc, width/4);
            crc_tab(i+1) = uint32(data);
        end
    elseif width == 16
    %     crc_tab = cell(256, 1);
        crc_tab = uint16(zeros(256, 1));

        for i = 0 : 255
            data = uint16(i);
            for j = 0:7
                if bitand(data, 1)
                    data = uint16(bitxor(bitshift(data, -1), ploy)); % bitshift：>0表示向左移位，<0表示向右移位
                else
                    data = bitshift(data, -1);
                end
            end
    %         crc_tab{i+1} = dec2hex(crc, width/4);
            crc_tab(i+1) = uint16(data);
        end
    elseif width == 8
        %     crc_tab = cell(256, 1);
        crc_tab = uint8(zeros(256, 1));

        for i = 0 : 255
            data = uint8(i);
            for j = 0:7
                if bitand(data, 1)
                    data = uint8(bitxor(bitshift(data, -1), ploy)); % bitshift：>0表示向左移位，<0表示向右移位
                else
                    data = bitshift(data, -1);
                end
            end
    %         crc_tab{i+1} = dec2hex(crc, width/4);
            crc_tab(i+1) = uint8(data);
        end
    end
end


end


