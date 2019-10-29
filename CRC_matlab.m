function codedata = CRC_matlab(data, width, init, refin, refout, xorout)
% CRC��matlab�Դ���CRC
% 

%% 1.���ݴ���
% % ���ɶ��������ݣ���λ��ǰ��bit0����bit7
bindata = de2bi(data, 8); 
bindata = bindata(:, end:-1:1);

% ������ת����һ��
bindata = bindata';     % matlab�����ȣ������ת��
arr = bindata(:);

x = logical(arr);

%% 2.CRC����

if width == 16
    poly = [16 12 5 0];
%     poly = [16 15 2 0];
end
if width == 32 
    poly = [32 26 23 22 16 12 11 10 8 7 5 4 2 1 0];
end
if width == 8
%     poly = [8 6 4 3 2 0];
    poly = [8 2 1 0];
%     poly = [8 7 6 4 2 0];
%     poly = [8 2 1 0];
%     poly = [8 5 4 0];
end

% CRC
hGen = comm.CRCGenerator(poly, ...
                         'InitialConditions', init, ...
                         'DirectMethod', 1, ...
                         'ReflectInputBytes', refin, ...
                         'ReflectChecksums', refout, ...
                         'FinalXOR', xorout);

code = step(hGen, x);

%% 3.���ݴ���
if width == 16
    
    % CRCУ��ֵ
    codeword = code(end - 16 + 1:end);
    codeword = num2str(codeword);    
    codedata = bin2dec(codeword');

end

if width == 32
    
    % CRCУ��ֵ
    codeword = code(end - 32 + 1:end);    
    codeword = num2str(codeword);
    codedata = bin2dec(codeword');
    
end

if width == 8
    % CRCУ��ֵ
    codeword = code(end - 8 + 1:end);
    codeword = num2str(codeword);
    codedata = bin2dec(codeword');
end

end