function val = bit_reflect(data, width)
% ����tableת���ɷ���table
% inputs:
%   - data: ����
%   - width: λ��

val = 0;
for i = 1 : width
    if bitand(data, 1)
        val = bitor(val, bitshift(1, width-i));
    end
    data = bitshift(data, -1);
end

end