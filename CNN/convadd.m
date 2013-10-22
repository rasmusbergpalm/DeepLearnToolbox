	%a is the image, k the kernel, o the output, i is the index.
function result = convadd(a, k, m, pid, chunkSize)
	init = pid*chunkSize + 1;
	result = zeros(m, m);
	for i=init:init+chunkSize -1
	    result += conv2D(a(:,:, i), k(:,:, i));
	end
end
