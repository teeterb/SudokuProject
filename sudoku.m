classdef sudoku
% SUDOKU - rapidly find all possible solutions to a sudoku puzzle
% 
% Usage: Mout = sudoku(M)
% 
% M    = intial sudoku matrix, with zeros for empty entries
% Notes: (1) The algorithm employs recursion, but does as much as it can
%            with straighforward deterministic deduction at each recursion
%            level to increase overall speed.
%        (2) Supplying this function with an empty or overly sparse
%            input matrix can create longer calulation times as the
%            function searches for all possible solutions.
%        (3) A "No solution" error is generated if the input puzzle has no
%            valid solution.

% Revision History
%   07/27/2018 Final Draft Due
    properties(Access = public) 
       
        SudokuPuzzle;
    end
    
    
    methods
        function obj = sudoku(Matrix)
            
           obj.SudokuPuzzle = obj.solveSudoku(Matrix); 
           
        end
        
        function disp(obj)
        %% disp 
        %   disp(obj) displays the full object without printing 
        %   the variable name. It utilizes the disp function for a
        %   character array.
        %   
        %   Inputs: 
        %   obj     instance of class StudentData
        %
        %   Outputs: void
        
            fprintf('%s',obj.Sudoku);
        
        end
    
        function s = Sudoku(obj)
        %% Student
        %   Student(obj) returns a character array with the full info
        %   of the student object
        %   
        %   Inputs: 
        %   obj     instance of class StudentData
        %
        %   Outputs: %This will be added to 
        %   s       character vector 'firstname' 'middle initial'.
        %   'lastname' 'id'
        
            s = sprintf('%d ',obj.SudokuPuzzle);
        end
        
        function s = GetMatrix(obj)
        %% GetFirstname
        %   GetFirstname(obj) returns a character vector contain the first
        %   name of the object.
        %   
        %   Inputs: 
        %   obj     instance of class StudentData
        %
        %   Outputs:
        %   s       character vector containing first name of object

            s = obj.SudokuPuzzle;
        end
    end
    methods(Access = protected)
        function [Solution,nsize] = solveSudoku(obj,M)
        % main program:
            %           *--------------ERROR MESSAGES-------------*
    
            if ndims(M)~=2
                assert(false,'sudoku:solveSudoku:Assertion Input matrix must be two dimensional.')
            
            elseif any((size(M)-[9 9])~=0)
                assert(false,'sudoku:solveSudoku:Assertion Input matrix must have nine rows and nine columns.')
            
            elseif any(any(M~=floor(M))) || any(abs(M(:)-4.5)>4.5)
                assert(false,'sudoku:solveSudoku:AssertionOnly integers from zero to nine are permitted as input.')
            end

        % ----------
            
            if ismatrix(M)
                Solution=0*M; % clear out the solution matrix
                [M,imp,Solution]=obj.recurse(M,Solution); %#ok need this syntax for recursion
                if imp % if impossible, quit
                    assert(false,'sudoku:recurse:Assertion No possible solution')
                end
            else 
                assert(false,'sudoku:solveSudoku:Assertion Not a Matrix')
            end
            
            Solution=Solution(:,:,2:end);
            nsize = size(Solution);
            %Solution = mat2str(Solution);
            return
        end

        % ----------
        
        % recursive guess algorithm:
        function [M,imp,Solution]=recurse(obj,M,Solution)
        %clc;disp(M);pause(.1)
            [M,imp]=obj.deduce(M); % perform deterministic deductions
            if imp % if impossible, quit
                return
            end
        
            z=find(~M(:)); % indices of unsolved entries
            if isempty(z) % if solved
                Solution(:,:,end+1) = M;
                return
            end
            impall=zeros(1,9);
            for v=1:9
                Q=M;
                Q(z(1))=v; % guess
                [Q,impall(v),Solution]=obj.recurse(Q,Solution);
            end
            
            imp=all(impall);
            M=Q;
            return
        end

        % ----------

        % deterministic logic algorithm:
        function [M,imp]=deduce(obj,M)
        %clc;disp(M);pause(.1)
            imp=0; % not impossible yet
            % solve what you can by deterministic deduction (no guessing)
            Mprev = 10*M; % solution at previous stage
            while any(M(:)-Mprev(:)) % iterate until no longer changing
                Mprev=M;
                N=ones(9,9,9);
                % zero out untrue entries for input
                [r,c]=find(M);
                for n=1:length(r)
                    N(r(n),c(n),:)=0;
                    N(r(n),c(n),M(r(n),c(n)))=1;
                end
                if any(any(sum(N,3)<1))
                    imp=1; % impossible flag (no solution)
                    return
                end
                [r,c]=find(sum(N,3)<2); % solved entries
                for n=1:length(r)
                    if any(any(sum(N,3)<1))
                        imp=1; %impossible flag (no solution)
                        return
                    end
                    v = find(N(r(n),c(n),:)); % value of the entry
                    if isempty(v)
                        M(r(n),c(n)) = 0;
                    else
                        M(r(n),c(n)) = v; % make sure entry is recorded
                    end
                    % clear value out of row
                    N(:,c(n),v)=0;
                    % clear value out of column
                    N(r(n),:,v)=0;
                    % top row & left column of box:
                    br = floor((r(n)-.5)/3)*3+1;
                    bc = floor((c(n)-.5)/3)*3+1;
                    % clear value out of box:
                    N(br:br+2,bc:bc+2,v)=0;
                    % reset value into proper place:
                    N(r(n),c(n),v)=1;
                end
                % for each entry, find lone possibilites and record
                for r=1:9
                    for c=1:9
                        v=find(N(r,c,:));
                        if length(v)==1
                            M(r,c)=v;
                          
                        end
                    end
                end
                % for each row, find lone possibilities and record
                for r=1:9
                    for v=1:9
                        c=find(N(r,:,v));
                        if length(c)==1
                            M(r,c)=v;
                            
                        end
                    end
                end
                % for each column, find lone possibilities and record
                for c=1:9
                    for v=1:9
                        r=find(N(:,c,v));
                        if length(r)==1
                            M(r,c)=v;
                            
                        end
                    end
                end
                % for each box, find lone possibilities and record
                for r=[1 4 7]
                    for c=[1 4 7]
                        for v=1:9
                            Q=N(r:r+2,c:c+2,v);
                            [pr,pc]=find(Q);
                            if length(pr)==1
                                M(r+pr-1,c+pc-1)=v;
                                
                            end
                        end
                    end
                end
            end
            return
        end
    end
end
