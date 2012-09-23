function generateDoc
%generateDoc Publish the example scripts in the doc directory

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

doc_dir = fullfile(fileparts(which('runtests')), '..', 'doc');
addpath(doc_dir);
cd(doc_dir)
mfiles = dir('*.m');
for k = 1:numel(mfiles)
    publish(mfiles(k).name);
    cd(doc_dir)
end
