% return OCTAVE_VERSION or 'undefined' as a string
function result = myOctaveVersion()
  if isOctave()
    result = OCTAVE_VERSION;
  else
    result = 'undefined';
end
