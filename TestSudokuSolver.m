classdef TestSudokuSolver < matlab.unittest.TestCase
%% TestSudokuSolver
%   A class derived from matlab.unittest.TestCase
%   running the Test mehtods unit, test the SudokuSolver class.
%
%   Implements specific unit tests for the SudokuSolver class.
    properties(Access = private)
       M = [];
       symbols;
       invalidsymbols;
       
       numOfvalidmatrixErrors;
       numOfNoSolutions;
       numOfvalidSolutions;
    end
    
    methods (TestMethodSetup)
        function createSymbols(testCase)
        %% createSymbols
            % Initializes variables used for testing
            % Reports results
            %
            % Input: testCase   
            %
            % Output: void
            %
            % Syntax: createSymbols(testCase)
            
                testCase.symbols = '0':'9';
                
                testCase.numOfvalidmatrixErrors = 0;
                testCase.numOfNoSolutions = 0;
                testCase.numOfvalidSolutions = 0;
                %put the initialization of error vars here
                
                clc
                
        end
    end
    
    methods (TestMethodTeardown)
        function reportErrors(testCase)
        %% reportErrors
        % Prints each error count to the Command Window
        %
        % Input: testCase
        %
        %
        % Output: void
        %
        % Syntax: reportErrors(testCase)
        %
            
            %using fprintf print the number of each type of error]
            fprintf('\nNumber of NonMatrix errors = %g\n',testCase.numOfvalidmatrixErrors);
            fprintf('Number of no solution errors = %g\n',testCase.numOfNoSolutions);
            
        end       
    end
    
    methods(Test)
        function testConstructor(testCase)
        %% testContstructor
        %
        % Input: testCase   TestSudokuSolver handle to instance of class
        %                   TestSudokuSolver
        %
        % Output: void
        %
        % Syntax: testConstructor(testCase)    
            
            %Here is the constructor, basically creating an easy sudoku to 
            %solve that we know the answer to,  to test the class's ability
            %to read numbers, char, and string if needed. 
            % % find the unique solution to this puzzle in a fraction of a second:
            
        N = [0 0 8 0 9 0 5 0 0;0 0 1 0 7 0 4 0 0;0 0 4 0 3 0 6 0 0;
             0 1 0 0 0 6 0 0 7;0 9 0 0 0 3 0 0 0;0 2 0 0 5 0 0 6 0;
             0 5 0 0 4 0 0 2 0;0 0 0 8 0 0 0 3 0;6 0 0 1 0 0 0 4 0];
        N = sudoku(N);
        text = sprintf('TestSudokuSolver: testConstructor\n');
        testCase.verifyTrue(ismatrix(N.GetMatrix),text);
        
        end 
%         
%         function testConstructorArguments(testCase)
%         %% testConstructorArguments
%         % Tests class by creating multiple matrices that are both valid and
%         % invalid puzzles to test the handling of it.
%         % Input: testCase   TestSudokuSolver handle to instance of class
%         %                   TestSudokuSolver
%         % 
%         % Output: void
%         % 
%         % Syntax: testConstructorArguments(testCase)    
%         
%             %here we would call the create matrix function
%             %testCase.MatrixCreater.
%             
%             %And this is where all the asserts go, read studentdata class
%             %for more info on using ME messages.
%             
%             
%             
%             unsolved = testCase.createSudoku;
%             
%             
%             try
%                 validdata = true;
%                 Solved = sudoku(unsolved);
%                 stringSolved = Solved.SudokuPuzzle;
%                 
%             catch ME
%                 validdata = false;
%                 A = mat2str(unsolved);
%                 cprintf('r','\n%s \n%s',ME.message, A);
%                 
%                 switch ME.message
%                     case char('sudoku:solveSudoku:Assertion Not a Matrix')
%                         testCase.numOfvalidmatrixErrors = testCase.numOfvalidmatrixErrors + 1;
%                     case char('sudoku:recurse:Assertion No possible solution')
%                         testCase.numOfNoSolutions = testCase.numOfNoSolutions + 1;
%                     case char('sudoku:solveSudoku:Assertion Input matrix must be two dimensional.')
%                         testCase.numOfvalidmatrixErrors = testCase.numOfvalidmatrixErrors + 1;
%                     case char('sudoku:solveSudoku:Assertion Input matrix must have nine rows and nine columns.')
%                         testCase.numOfvalidmatrixErrors = testCase.numOfvalidmatrixErrors + 1;
%                     case char('sudoku:solveSudoku:AssertionOnly integers from zero to nine are permitted as input.')
%                          testCase.numOfvalidmatrixErrors = testCase.numOfvalidmatrixErrors + 1;
%                     otherwise
%                         rethrow(ME);
%                 end
%             end
%             
%             txt = sprintf('TestSudokuSolver:testConstructorArguments: \n%s',stringSolved);
%             
%             if validdata
%                 testCase.numOfvalidSolutions = testCase.numOfvalidSolutions + 1;
%                 disp(stringSolved)
%                 testCase.verifyTrue(isa(Solved,'sudoku'));
%                 testCase.verifyTrue(ismatrix(Solved.GetMatrix),txt);
%                 existf = true;
%                 if exist('SolvedSudoku.txt','file')
%                     existf = false;
%                 end
%                 fileID = fopen('SolvedSudoku.txt','a');
%                 
%                 if existf
%                     fprintf(fileID,'%12s\n','Solved Sudokus');
%                 end
%                 fprintf(fileID,'%s\n',stringSolved);
%                 fclose(fileID);
%             end
%             
%         end
    end
    
    methods(Access = private)
        function A = createSudoku(testCase)
        %% createSudoku
        % creates a random puzzle to be solved.
        
            % math goes here for creation
            
            numberRemovals = testCase.numberRemovals;
            ir = 1:9;
            ic = reshape(ir,3,3)';
            A = 1 + mod(bsxfun(@plus,ir,ic(:)),9);
            
            p = randperm(9,9);
            
            r = bsxfun(@plus,randperm(3,3),3*(randperm(3,3)-1)');
            c = bsxfun(@plus,randperm(3,3),3*(randperm(3,3)-1)');
            
            %permutations
            A = p(A);
            A = A(r,:);
            A = A(:,c);
            
            %transpose randomly
            if randi(2) == 1
                A = A';
            end
            
            %remove numbers
            removed = 0;
            while removed ~= numberRemovals
                for r = randi(9)
                    for c = randi(9)
                        if A(r,c) > 0
                            A(r,c) = 0;
                            removed = removed + 1;
                        else
                            A(r,c) = A(r,c);
                        end
                    end
                end
            end
        end
        
        function num = numberRemovals(testCase)
            
            switch randi(3)
                case 1
                    num = 36;
                case 2
                    num = 48;
                case 3
                    num = 55;
            end
            
        end
        
        
        function M = createInvalidSudoku(testCase)
        %% createInvalidSudoku
        % Creates an invalid puzzle, to test how the class handles it. 
        %
        
            % math goes here for creation
        end
    end
    
    
end