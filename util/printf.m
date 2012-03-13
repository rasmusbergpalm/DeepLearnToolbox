function printf(varargin)

persistent prev_output

%disp(sprintf(varargin{:}))

format = varargin{1};

if format(1 : 2) == '\a'
  varargin{1} = format(3 : end);

  for i = 1 : length(prev_output)
    fprintf('\b')
  end

  prev_out = '';
end

fprintf(varargin{:});

output = sprintf(varargin{:});

s = regexp(output, '\n', 'split');

if 0
%if strcmp(output, s{end})
    prev_output = strcat(prev_output, output);
else
    prev_output = s{end};
end
