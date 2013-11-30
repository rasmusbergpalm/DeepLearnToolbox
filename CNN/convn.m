%Overwrite convn function to handle octaves convn(a,b,'valid') bug. See http://savannah.gnu.org/bugs/?39314
function result = convn(A, B, shape)
    more off;
    disp('convn')
    disp(isOctave())
    disp(strcmp(shape, 'valid'))
    if(isOctave() && strcmp(shape, 'valid'))
    	disp('in here')
        m = size(A, 1) - size(B, 1) + 1;
        result = zeros(m, m);
        B = flipdim(B,3);
        for j=1:size(A, 3)  
	    result += conv2(A(:,:,j),B(:,:,j), 'valid');
        end
    else
        result = convn(A,B,shape)
    end
end
