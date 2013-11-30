%Convolution for 3 dimensional vectors using conv2
%equivalent to convn(A,B, 'valid')

function result = convn_valid(A, B)
    m = size(A, 1) - size(B, 1) + 1;
    result = zeros(m, m);
    B = flipdim(B,3);
    for j=1:size(A, 3)  
	 result += conv2(A(:,:,j),B(:,:,j), 'valid');
    end
end