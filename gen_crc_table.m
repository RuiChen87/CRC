function crc_tab = gen_crc_table(ploy, width)
% ����CRC���
% input:
%   - ploy: int, ����ʽ
%   - width: λ��16��32�ȣ�8λ���д���֤
%

if width == 32
    % crc_tab = cell(256, 1);
    crc_tab = uint32(zeros(256, 1));

    for i = 0 : 255
        crc = bitshift(uint32(i), width-8, 'uint32'); % int 4���ֽڣ�32λ
        for j = 0:7
            if bitand(crc, hex2dec('80000000'))
                crc = uint32(bitxor(bitshift(crc, 1), ploy)); % bitshift��>0��ʾ������λ��<0��ʾ������λ
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
        crc = bitshift(uint16(i), width-8, 'uint16'); % int 4���ֽڣ�32λ
        for j = 0:7
            if bitand(crc, hex2dec('8000'))
                crc = uint16(bitxor(bitshift(crc, 1), ploy)); % bitshift��>0��ʾ������λ��<0��ʾ������λ
            else
                crc = bitshift(crc, 1);
            end
        end
%         crc_tab{i+1} = dec2hex(crc,4);
        crc_tab(i+1) = uint16(crc);
    end
end

end

