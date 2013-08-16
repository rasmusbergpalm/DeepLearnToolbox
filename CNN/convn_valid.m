%Convolution for 3 dimensional vectors using conv2
%equivalent to convn(A,B, 'valid')

function result = convn_valid(A, B)

    m = size(A, 1) - size(B, 1) + 1;
    numWorkers = 2;
	
    function retcode = eh(error)
        a = error
        retcode = zeros(25, 1);	
    end
	
	%each worker will write its output to specific part of the output
	chunkSize = size(A,3)/numWorkers;
	result = pararrayfun(numWorkers,  @(i)convadd(A, B, m, i, chunkSize), 0:numWorkers-1, "ErrorHandler" , @eh);
	
    for j=m:numWorkers*m:m  
	    result(:,1:m) += result(:,j+1:j+m);
	end
	
	result = result(1:m,1:m);
end