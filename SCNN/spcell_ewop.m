function x = spcell_ewop(x, operation)
%{
    �������ܣ�ʹ�ò�������ÿһ��Ԫ�ؽ��в���
%}
    n = numel(x);
    for i = 1:n
        x{i} = operation(x{i});
    end
end