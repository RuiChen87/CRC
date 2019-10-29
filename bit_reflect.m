function val = bit_reflect(data, width)
% 正向table转换成反向table
% inputs:
%   - data: 数据
%   - width: 位宽

val = 0;
for i = 1 : width
    if bitand(data, 1)
        val = bitor(val, bitshift(1, width-i));
    end
    data = bitshift(data, -1);
end

end