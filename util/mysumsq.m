function ret = mysumsq(A)
#Wrapper to make use of Octave's sumsq-function which is something between
#slightly (small matrices) and incredible (huge matrices) faster than calling sum(A.^2).
    if(isInOctave())
        ret = sumsq(A);
    else
    	ret = sum(A.^2);
    end#if
end#function
