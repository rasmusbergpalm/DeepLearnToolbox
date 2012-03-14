function printf(varargin)

persistent output_column

format = varargin{1};

if format(1 : 2) == '\a'
  varargin{1} = format(3 : end);

  for i = 1 : output_column
    fprintf('\b')
  end

  output_column = 0;
end

fprintf(varargin{:});

output = sprintf(varargin{:});

s = regexp(output, '\n', 'split');

%if 0
if strcmp(output, s{end})
    output_column = output_column + length(output);
else
    output_column = length(s{end});
end
