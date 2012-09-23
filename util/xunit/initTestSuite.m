%findSubfunctionTests Utility script used for subfunction-based tests
%   This file is a script that is called at the top of M-files containing
%   subfunction-based tests.
%
%   The top of a typical M-file using this script looks like this:
%
%       function test_suite = testFeatureA
%
%       findSubfunctionTests;
%
%   IMPORTANT NOTE
%   --------------
%   The output variable name for an M-file using this script must be test_suite.

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

[ST,I] = dbstack('-completenames');
caller_name = ST(I + 1).name;
caller_file = ST(I + 1).file;
subFcns = which('-subfun', caller_file);

setup_fcn_name = subFcns(xunit.utils.isSetUpString(subFcns));
if numel(setup_fcn_name) > 1
    error('findSubfunctionTests:tooManySetupFcns', ...
        'Found more than one setup subfunction.')
elseif isempty(setup_fcn_name)
    setup_fcn = [];
else
    setup_fcn = str2func(setup_fcn_name{1});
end

teardown_fcn_name = subFcns(xunit.utils.isTearDownString(subFcns));
if numel(teardown_fcn_name) > 1
    error('findSubfunctionTests:tooManyTeardownFcns', ...
        'Found more than one teardown subfunction.')
elseif isempty(teardown_fcn_name)
    teardown_fcn = [];
else
    teardown_fcn = str2func(teardown_fcn_name{1});
end

test_fcns = cellfun(@str2func, subFcns(xunit.utils.isTestString(subFcns)), ...
    'UniformOutput', false);

suite = TestSuite;
suite.Name = caller_name;
suite.Location = which(caller_file);
for k = 1:numel(test_fcns)
    suite.add(FunctionHandleTestCase(test_fcns{k}, setup_fcn, teardown_fcn));
end

if nargout > 0
    test_suite = suite;
else
    suite.run();
end

