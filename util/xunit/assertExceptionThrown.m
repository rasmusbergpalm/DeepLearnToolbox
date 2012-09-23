function assertExceptionThrown(f, expectedId, custom_message)
%assertExceptionThrown Assert that specified exception is thrown
%   assertExceptionThrown(F, expectedId) calls the function handle F with no
%   input arguments.  If the result is a thrown exception whose identifier is
%   expectedId, then assertExceptionThrown returns silently.  If no exception is
%   thrown, then assertExceptionThrown throws an exception with identifier equal
%   to 'assertExceptionThrown:noException'.  If a different exception is thrown,
%   then assertExceptionThrown throws an exception identifier equal to
%   'assertExceptionThrown:wrongException'.
%
%   assertExceptionThrown(F, expectedId, msg) prepends the string msg to the
%   assertion message.
%
%   Example
%   -------
%   % This call returns silently.
%   f = @() error('a:b:c', 'error message');
%   assertExceptionThrown(f, 'a:b:c');
%
%   % This call returns silently.
%   assertExceptionThrown(@() sin, 'MATLAB:minrhs');
%
%   % This call throws an error because calling sin(pi) does not error.
%   assertExceptionThrown(@() sin(pi), 'MATLAB:foo');

%   Steven L. Eddins
%   Copyright 2008-2010 The MathWorks, Inc.

noException = false;
try
    f();
    noException = true;
    
catch exception
    if ~strcmp(exception.identifier, expectedId)
        message = sprintf('Expected exception %s but got exception %s.', ...
            expectedId, exception.identifier);
        if nargin >= 3
            message = sprintf('%s\n%s', custom_message, message);
        end
        throwAsCaller(MException('assertExceptionThrown:wrongException', ...
            '%s', message));
    end
end

if noException
    message = sprintf('Expected exception "%s", but none thrown.', ...
        expectedId);
    if nargin >= 3
        message = sprintf('%s\n%s', custom_message, message);
    end
    throwAsCaller(MException('assertExceptionThrown:noException', '%s', message));
end
