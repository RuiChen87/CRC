function crc = calc_crc(data, tab, width, refin, refout, init, xorval)
% ����CRC������
% input:
%   - data: ����
%   - tab: CRC���
%   - width: λ��8��16��32��
%   - refin: �Ƿ���������ݷ�ת��1-true, 0-false
%   - refout: �Ƿ��������ݷ�ת��1-true, 0-false
%   - init: ��ʼֵ��ʮ����������str
%   - xorval: ���ֵ��ʮ����������str
%
% CRC������̣�
%   ����1����ʼ��CRC�Ĵ���
%   ����2������refin������������ÿ���ֽڽ��д���õ�temp
%   ����3��CRC����ֽ���temp��򣬵õ�temp1=(CRC>>width-8)^temp
%   ����4��CRC����һ���ֽڣ��õ�CRC1=CRC<<8
%   ����5����table�в�����Ϣ����CRC���CRC=table[temp1]^CRC1
%   ����6���ظ�����2~5��֪����������������
%   ����7������refout����������ݽ��д���õ�CRC
%   ����8����xorval��򣬵õ�����CRC
%

% ����1����ʼ��CRC
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
    
    % ����2���������ݰ��ֽڷ�ת
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

    % ����CRC
    temp1 = bitxor(bitshift(crc, 8-width), tmp); % ����3��CRC����ֽ���tmp���
    crc1 = bitshift(crc, 8); % ����4��CRC����һ���ֽ�
    crc = bitxor(tab(temp1+1), crc1); % ����5������table������CRC1�������+1����Ҫ������matlab��index��ʼ��1��ʼ
end

% ����7��������ݷ�ת
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

% ����8�������ֵ���
crc = bitxor(crc, xorout);

end