%TestSuite Collection of TestComponent objects
%   The TestSuite class defines a collection of TestComponent objects.
%
%   TestSuite methods:
%       TestSuite             - Constructor
%       add                   - Add test component to test suite
%       print                 - Display test suite summary to Command Window
%       run                   - Run the test suite
%       keepMatchingTestCase  - Keep only the named test component
%       fromName              - Construct test suite from directory or MATLAB function file name
%       fromTestCaseClassName - Construct test suite from TestCase class name
%       fromPackageName       - Construct test suite from package name
%       fromPwd               - Construct test suite from present directory
%
%   TestSuite properties:
%       TestComponents - Cell array of TestComponent objects
%
%   Examples
%   --------
%   Run all the test cases in the SampleTests1 class.  Display test suite
%   progress and a summary of results in the Command Window.
%
%       TestSuite('SampleTests1').run()
%
%   Construct a test suite from all test components found in the current
%   directory.
%
%       suite = TestSuite.fromPwd();
%
%   Construct a test suite from all test components found in the package
%   'mytool.tests'. (Note that the "+" character at the beginning of the package
%   folder name on disk is not part of the package name.)
%
%       suite = TestSuite.fromPackageName('mytool.tests');
%
%   Run all the test cases in the SampleTests class.  Display no output to the
%   Command Window.  Upon completion, query the number of test failures and test
%   errors.
%
%       logger = TestRunLogger();
%       TestSuite('SampleTests1').run(logger);
%       numFailures = logger.NumFailures
%       numErrors = logger.NumErrors
%
%   See also CommandWindowTestRunDisplay, TestCase, TestComponent, TestRunLogger

%   Steven L. Eddins
%   Copyright 2008-2010 The MathWorks, Inc.

classdef TestSuite < TestComponent
    
    properties (SetAccess = protected)
        TestComponents = {};
    end
    
    methods
        
        function self = TestSuite(name)
            %TestSuite Constructor
            %   suite = TestSuite constructs an empty test suite. suite =
            %   TestSuite(name) constructs a test suite by searching for test
            %   cases defined in an M-file with the specified name.
            
            if nargin >= 1
                self = TestSuite.fromName(name);
            end
        end
        
        function did_pass_out = run(self, monitor)
            %run Execute test cases in test suite
            %   did_pass = suite.run() executes all test cases in the test
            %   suite, returning a logical value indicating whether or not all
            %   test cases passed.
            
            if nargin < 2
                monitor = CommandWindowTestRunDisplay();
            end
            
            monitor.testComponentStarted(self);
            did_pass = true;
            
            self.setUp();
            
            for k = 1:numel(self.TestComponents)
                this_component_passed = self.TestComponents{k}.run(monitor);
                did_pass = did_pass && this_component_passed;
            end
            
            self.tearDown();
            
            monitor.testComponentFinished(self, did_pass);
            
            if nargout > 0
                did_pass_out = did_pass;
            end
        end
        
        function num = numTestCases(self)
            %numTestCases Number of test cases in test suite
            
            num = 0;
            for k = 1:numel(self.TestComponents)
                component_k = self.TestComponents{k};
                num = num + component_k.numTestCases();
            end
        end
        
        function print(self, numLeadingBlanks)
            %print Display test suite summary to Command Window
            %   test_suite.print() displays a summary of the test suite to the
            %   Command Window.
            
            if nargin < 2
                numLeadingBlanks = 0;
            end
            fprintf('%s%s\n', blanks(numLeadingBlanks), self.Name);
            for k = 1:numel(self.TestComponents)
                self.TestComponents{k}.print(numLeadingBlanks + ...
                    self.PrintIndentationSize);
            end
        end
        
        function add(self, component)
            %add Add test component to test suite
            %   test_suite.add(component) adds the TestComponent object to the
            %   test suite.
            
            if iscell(component)
                self.TestComponents((1:numel(component)) + end) = component;
            else
                self.TestComponents{end + 1} = component;
            end
        end
        
        function keepMatchingTestCase(self, name)
            %keepMatchingTestCase Keep only the named test component
            %   test_suite.keepMatchingTestCase(name) keeps only the test
            %   component with a matching name and discards the rest.
            
            idx = [];
            for k = 1:numel(self.TestComponents)
                if strcmp(self.TestComponents{k}.Name, name)
                    idx = k;
                    break;
                end
            end
            if isempty(idx)
                self.TestComponents = {};
            else
                self.TestComponents = self.TestComponents(idx);
            end
        end
        
    end
    
    methods (Static)
        function suite = fromTestCaseClassName(class_name)
            %fromTestCaseClassName Construct test suite from TestCase class name
            %   suite = TestSuite.fromTestCaseClassName(name) constructs a
            %   TestSuite object from the name of a TestCase subclass.
            
            if ~xunit.utils.isTestCaseSubclass(class_name)
                error('xunit:fromTestCaseClassName', ...
                    'Input string "%s" is not the name of a TestCase class.', ...
                    class_name);
            end
            
            suite = TestSuite;
            suite.Name = class_name;
            suite.Location = which(class_name);
            
            methods = getClassMethods(class_name);
            for k = 1:numel(methods)
                if methodIsConstructor(methods{k})
                    continue
                end
                
                method_name = methods{k}.Name;
                if xunit.utils.isTestString(method_name)
                    suite.add(feval(class_name, method_name));
                end
            end
            
        end
        
        function suite = fromName(name)
            %fromName Construct test suite from M-file name
            %   test_suite = TestSuite.fromName(name) constructs a TestSuite
            %   object from an M-file with the given name.  The name can be of a
            %   directory, a TestCase subclass, or an M-file containing a simple
            %   test or containing subfunction-based tests.
            %
            %   Optionally, name can contain a colon (':') followed by filter
            %   string.  The filter string is used to select a particular named
            %   test case.  For example, TestSuite.fromName('MyTests:testA')
            %   constructs a TestSuite object containing only the test case
            %   named 'testA' found in the TestCase subclass MyTests.
            
            if isdir(name)
                suite = TestSuiteInDir(name);
                suite.gatherTestCases();
                return;
            end
            
            [name, filter_string] = strtok(name, ':');
            if ~isempty(filter_string)
                filter_string = filter_string(2:end);
            end
            
            if xunit.utils.isTestCaseSubclass(name)
                suite = TestSuite.fromTestCaseClassName(name);
                
            elseif ~isempty(meta.class.fromName(name))
                % Input is the name of a class that is not a TestCase subclass.
                % Return an empty test suite.
                suite = TestSuite();
                suite.Name = name;
                
            elseif isPackage(name)
                suite = TestSuite.fromPackageName(name);
                
            else
                
                try
                    if nargout(name) == 0
                        suite = TestSuite();
                        suite.Name = name;
                        suite.add(FunctionHandleTestCase(str2func(name), [], []));
                        suite.Location = which(name);
                        
                    else
                        suite = feval(name);
                        if ~isa(suite, 'TestSuite')
                            error('Function did not return a TestSuite object.');
                        end
                    end
                    
                catch
                    % Ordinary function does not appear to contain tests.
                    % Return an empty test suite.
                    suite = TestSuite();
                    suite.Name = name;
                end
            end
            
            if ~isempty(filter_string)
                suite.keepMatchingTestCase(filter_string);
            end
        end
        
        function test_suite = fromPwd()
            %fromPwd Construct test suite from present directory
            %   test_suite = TestSuite.fromPwd() constructs a TestSuite object
            %   from all the test components in the present working directory.
            %   all TestCase subclasses will be found, as well as simple and
            %   subfunction-based M-file tests beginning with the string 'test'
            %   or 'Test'.
            
            test_suite = TestSuite();
            test_suite.Name = pwd;
            test_suite.Location = pwd;
            
            mfiles = dir(fullfile('.', '*.m'));
            for k = 1:numel(mfiles)
                [path, name] = fileparts(mfiles(k).name);
                if xunit.utils.isTestCaseSubclass(name)
                    test_suite.add(TestSuite.fromTestCaseClassName(name));
                elseif xunit.utils.isTestString(name)
                    suite_k = TestSuite.fromName(name);
                    if ~isempty(suite_k.TestComponents)
                        test_suite.add(suite_k);
                    end
                end
            end
        end
        
        function test_suite = fromPackageName(name)
            %fromPackageName Construct test suite from package name
            %   test_suite = TestSuite.fromPackageName(name) constructs a
            %   TestSuite object from all the test components found in the
            %   specified package.

            package_info = meta.package.fromName(name);
            if isempty(package_info)
                error('xunit:fromPackageName:invalidName', ...
                    'Input string "%s" is not the name of a package.', ...
                    name);
            end
            test_suite = TestSuite();
            test_suite.Name = name;
            test_suite.Location = 'Package';
            
            for k = 1:numel(package_info.Packages)
                pkg_name = package_info.Packages{k}.Name;
                pkg_suite = TestSuite.fromPackageName(pkg_name);
                if ~isempty(pkg_suite.TestComponents)
                    test_suite.add(TestSuite.fromPackageName(pkg_name));
                end
            end
            
            class_names = cell(1, numel(package_info.Classes));
            for k = 1:numel(package_info.Classes)
                class_name = package_info.Classes{k}.Name;
                class_names{k} = class_name;
                if xunit.utils.isTestCaseSubclass(class_name)
                    test_suite.add(TestSuite.fromTestCaseClassName(class_name));
                end
            end
            
            for k = 1:numel(package_info.Functions)
                function_name = package_info.Functions{k}.Name;
                if xunit.utils.isTestString(function_name)
                    full_function_name = [package_info.Name '.' package_info.Functions{k}.Name];
                    if ~ismember(full_function_name, class_names)
                        suite_k = TestSuite.fromName(full_function_name);
                        if ~isempty(suite_k.TestComponents)
                            test_suite.add(suite_k);
                        end
                    end
                end
            end
        end
    end
end

function tf = isPackage(name)
tf = ~isempty(meta.package.fromName(name));
end

function methods = getClassMethods(class_name)
class_meta = meta.class.fromName(class_name);
methods = class_meta.Methods;
end

function result = methodIsConstructor(method)
method_name = method.Name;
if ~isempty(method.DefiningClass.ContainingPackage)
    method_name = [method.DefiningClass.ContainingPackage.Name, '.', ...
        method_name];
end
result = strcmp(method_name, method.DefiningClass.Name);
end
