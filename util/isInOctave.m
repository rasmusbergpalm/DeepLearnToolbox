function inOctave = isInOctave ()
    persistent in;
    if isempty(in)
        in = exist('OCTAVE_VERSION','builtin') != 0;
    end#if
    inOctave = in;
end#function
