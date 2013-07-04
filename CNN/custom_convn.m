% This function is used to choose between different implementations of the convn function
% according to the platform.
% This is mainly useful for overcoming an Octave's bug in convn(), https://savannah.gnu.org/bugs/?39314
% parameters: x is the chunk of the image/samples, k is the kernel.

function result = custom_convn(x, k, convmode) 
    
    %FFT works with batchsize>50, but still really slow, about 10000 seconds. It should produce an error near 0.18.
	%this convnfft is taken from http://www.mathworks.com/matlabcentral/fileexchange/24504-fft-based-convolution.
    if exist('convmode') && strcmp(convmode, 'fft')
       result = convnfft(x,k, 'valid');
       return
	end
	
	%the 'valid' version of convolution has problems in Octave, use 'same' instead.
	if isOctave()
	   %Alternative to convnftt, use for small batch size ~ 5, will give 2676.56 seconds, otherwise it will explode(too long running time).
       start = size(x,1) - size(k,1);
       fin = 2*start;
       %note: if x and k have not the same size in the third dimension, middle could be a range.
       middle = floor(size(x,3)/2) + 1;
       result = convn (x, k, "same")(start:fin, start:fin, middle);
	else
	   %we're running matlab
	   result = convn(x, k, 'valid');
	end

end

