%TestRunMonitor Abstract base class for monitoring a running test suite
%   The abstract TestRunMonitor class defines an object that can observe and
%   record the results of running a test suite.  The run() method of a
%   TestComponent object takes a TestRunMonitor object as an input argument.
%
%   Different test suite logging or reporting functionality can be achieved by
%   subclassing TestRunMonitor.  For example, see the TestRunLogger and the
%   CommandWindowTestRunDisplay classes.
%
%   TestRunMonitor methods:
%       TestRunMonitor        - Constructor
%       testComponentStarted  - Called at beginning of test component run
%       testComponentFinished - Called when test component run finished
%       testCaseFailure       -   Called when a test case fails
%       testCaseError         - Called when a test case causes an error
%
%   See also CommandWindowTestRunDisplay, TestRunLogger, TestCase, TestSuite

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

classdef TestRunMonitor < handle

    methods (Abstract)
        
        testComponentStarted(self, component)
            
        testComponentFinished(self, component, did_pass)
        
        testCaseFailure(self, test_case, failure_exception)
        
        testCaseError(self, test_case, error_exception)
        
    end
end
