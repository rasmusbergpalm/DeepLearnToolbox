%detects if we're running Octave
function result = isOctave()
    result = exist('OCTAVE_VERSION') ~= 0;
end