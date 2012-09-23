classdef FunctionHandleTestCase < TestCase
%FunctionHandleTestCase Test case based on a function handle
%   FunctionHandleTestCase is a TestCase subclass. It defines a test case object
%   that executes by running a function handle instead of by running a method of
%   the TestCase subclass. 
%
%   FunctionHandleTestCase methods:
%       FunctionHandleTestCase - Constructor
%       runTestCase            - Run function handle test  
%       setUp                  - Run test-fixture setup function
%       tearDown               - Run test-fixture teardown function
%
%   FunctionHandleTestCase properties:
%       TestFcn     - Function handle of test function
%       SetupFcn    - Function handle of setup function
%       TeardownFcn - Function handle of teardown function
%       TestData    - Data needed by test function or teardown function
%
%   See also TestCase, TestSuite

%   Steven L. Eddins
%   Copyright 2008-2009 The MathWorks, Inc.

    properties (SetAccess = protected, GetAccess = protected, Hidden = true)
        %TestFcn - Function handle of test function
        %   If SetupFcn has one or more output arguments, then TestFcn is
        %   called with this syntax:
        %
        %       TestFcn(data)
        %
        %   where data is the return value from SetupFcn.  Otherwise, TestFcn is
        %   called with no input and no output arguments.
        TestFcn;
        
        %SetupFcn - Function handle of setup function
        %   If SetupFcn has one or more output arguments, then SetupFcn is
        %   called with this syntax:
        %
        %       data = SetupFcn()
        %
        %   and data will be saved in the TestData property. Otherwise, SetupFcn
        %   is called with no input and no output arguments.
        SetupFcn;
        
        %TeardownFcn - Function handle of teardown function
        %   If SetupFcn has one or more output arguments, then TeardownFcn is
        %   called with this syntax:
        %
        %       TeardownFcn(data)
        %
        %   were data is the return value from SetupFcn.  Otherwise, TeardownFcn
        %   is called with no input and no output arguments.
        TeardownFcn;
        
        %TestData - Data needed by test function or teardown function.
        TestData;
    end

    methods
        function self = FunctionHandleTestCase(testFcn, setupFcn, teardownFcn)
            %FunctionHandleTestCase Constructor
            %   FunctionHandleTestCase(testFcn, setupFcn, teardownFcn) creates a
            %   TestCase object that executes by running the function handle
            %   TestFcn.  setupFcn is a function handle that will be executed
            %   before testFcn, and teardownFcn is a function handle that will
            %   be executed after TestFcn.  Either setupFcn or teardownFcn can
            %   be empty.
            %
            %   If setupFcn is function handle that has one output argument,
            %   then the three test functions will be called using these
            %   syntaxes:
            %
            %       testData = setupFcn();
            %       testFcn(testData);
            %       teardownFcn(testData);
            %
            %   Otherwise, the three test functions are all called with no input
            %   arguments:
            %
            %       setupFcn();
            %       TestFcn();
            %       teardownFcn();
            
            % Call the base class constructor.  Give it the name of the
            % FunctionHandleTestCase method that executes TestFcn.
            self = self@TestCase('runTestCase');
                        
            self.TestFcn = testFcn;
            self.SetupFcn = setupFcn;
            self.TeardownFcn = teardownFcn;

            % Determine the name and M-file location of the function handle.
            functionHandleInfo = functions(testFcn);
            self.Name = functionHandleInfo.function;
            if strcmp(functionHandleInfo.type, 'anonymous')
                % Anonymous function handles don't have an M-file location.
                self.Location = '';
            else
                self.Location = functionHandleInfo.file;
            end
        end

        function runTestCase(self)
            %runTestCase Run function handle test
            %   test_case.run() calls the test function handle.  If a nonempty
            %   SetupFcn was provided and it has at least one output argument,
            %   pass self.TestData to the test function.  Otherwise, call the
            %   test function with no input arguments.
            if ~isempty(self.SetupFcn) && nargout(self.SetupFcn) > 0
                self.TestFcn(self.TestData);
            else
                self.TestFcn();
            end
        end

        function setUp(self)
            %setUp Run test-fixture setup function
            %   If a nonempty SetupFcn was provided, run it.  If the SetupFcn
            %   has at least one output argument, capture the first output
            %   argument in instance data (TestData).
            if ~isempty(self.SetupFcn)
                if nargout(self.SetupFcn) > 0
                    if nargout(self.SetupFcn) > 1
                        message = sprintf(['A test fixture setup function returns more than one output argument. ', ...
                            'The test harness only calls the setup function with one output argument. ', ...
                            'Return a struct or a cell array from your setup function if you need to bundle several parts together.', ...
                            '\nTest name: %s\nTest location: %s'], ...
                            self.Name, self.Location);
                        warning('xunit:FunctionHandleTestCase:TooManySetupOutputs', ...
                            '%s', message);
                    end
                    self.TestData = self.SetupFcn();
                else
                    self.SetupFcn();
                end
            end
        end

        function tearDown(self)
            %tearDown Run test-fixture teardown function
            %   If a nonempty TeardownFcn was provided, run it.  If there is
            %   TestData (the output of the SetupFcn), then pass it to 
            %   TeardownFcn.  Otherwise, call TeardownFcn with no input
            %   arguments.
            if ~isempty(self.TeardownFcn)
                if ~isempty(self.SetupFcn) && (nargout(self.SetupFcn) > 0)
                    self.TeardownFcn(self.TestData);
                else
                    self.TeardownFcn();
                end
            end
        end
    end
end