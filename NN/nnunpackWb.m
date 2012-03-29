function [values layers] = nnunpackWb(net)
    layers = net.size;
    n      = net.n;

    values = [];
    for i = 2 : n
%        values = [values ; net.b{i - 1}(:)  ; net.W{i - 1}(:)  ; net.p{i}(:) ; ...
%                           net.db{i - 1}(:) ; net.dW{i - 1}(:)                     ];
        values = [values ; net.W{i - 1}(:) ; net.b{i - 1}(:) ];
    end

end
