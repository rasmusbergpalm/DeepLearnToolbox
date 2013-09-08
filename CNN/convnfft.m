function A = convnfft(A, B, shape, dims, options)
% CONVNFFT  FFT-BASED N-dimensional convolution.
%   C = CONVNFFT(A, B) performs the N-dimensional convolution of
%   matrices A and B. If nak = size(A,k) and nbk = size(B,k), then
%   size(C,k) = max([nak+nbk-1,nak,nbk]);
% 
%   C = CONVNFFT(A, B, SHAPE) controls the size of the answer C:
%       'full'   - (default) returns the full N-D convolution
%       'same'   - returns the central part of the convolution that
%                  is the same size as A.
%       'valid'  - returns only the part of the result that can be
%                  computed without assuming zero-padded arrays.
%                  size(C,k) = max([nak-max(0,nbk-1)],0).
%
%   C = CONVNFFT(..., SHAPE, DIMS) with DIMS is vector of dimensions where
%       the convolution will be carried out. By default DIMS is
%       [1:max(ndims(A),ndims(B))] (all dimensions). A and B must have the
%       same lengths on other dimensions.
%   C = CONVNFFT(..., SHAPE, DIMS, GPU)
%       GPU is boolean flag, see next
%
%   C = CONVNFFT(..., SHAPE, DIMS, OPTIONS)
%
%   OPTIONS is structure with following optional fields
%       - 'GPU', boolean. If GPU is TRUE Jacket/GPU FFT engine will be used
%       By default GPU is FALSE.
%       - 'Power2Flag', boolean. If it is TRUE, use FFT with length rounded
%       to the next power-two. It is faster but requires more memory.
%       Default value is TRUE.
%
% Class support for inputs A,B:
% float: double, single
%
% METHOD: CONVNFFT uses Fourier transform (FT) convolution theorem, i.e.
%         FT of the convolution is equal to the product of the FTs of the
%         input functions.
%         In 1-D, the complexity is O((na+nb)*log(na+nb)), where na/nb are
%         respectively the lengths of A and B.
%
% Usage recommendation:
%         In 1D, this function is faster than CONV for nA, nB > 1000.
%         In 2D, this function is faster than CONV2 for nA, nB > 20.
%         In 3D, this function is faster than CONVN for nA, nB > 5.
% 
% See also conv, conv2, convn.
% 
%   Author: Bruno Luong <brunoluong@yahoo.com>
%   History:
%       Original: 21-Jun-2009
%       23-Jun-2009: correct bug when ndims(A)<ndims(B)
%       02-Sep-2009: GPU/JACKET option
%       04-Sep-2009: options structure
%       16-Sep-2009: inplace product

if nargin<3 || isempty(shape)
    shape = 'full';
end

if nargin<5 || isempty(options)
    options = struct();
elseif ~isstruct(options) % GPU options
    options = struct('GPU', options);
end

nd = max(ndims(A),ndims(B));
% work on all dimensions by default
if nargin<4 || isempty(dims)
    dims = 1:nd;
end
dims = reshape(dims, 1, []); % row (needed for for-loop index)

% GPU enable flag
GPU = getoption(options, 'GPU', false);
% Check if Jacket is installed
GPU = GPU && ~isempty(which('ginfo'));

% IFUN function will be used later to truncate the result
% M and N are respectively the length of A and B in some dimension
switch lower(shape)
    case 'full',
        ifun = @(m,n) 1:m+n-1;
    case 'same',
        ifun = @(m,n) ceil((n-1)/2)+(1:m);
    case 'valid',
        ifun = @(m,n) n:m;
    otherwise
        error('convnfft: unknown shape %s', shape);
end

classA = class(A);
classB = class(B);
ABreal = isreal(A) && isreal(B);

% Special case, empty convolution, try to follow MATLAB CONVN convention
if any(size(A)==0) || any(size(B)==0)
    szA = zeros(1,nd); szA(1:ndims(A))=size(A);
    szB = zeros(1,nd); szB(1:ndims(B))=size(B);
    % Matlab wants these:
    szA = max(szA,1); szB = max(szB,1);
    szC = szA;
    for dim=dims
        szC(dim) = length(ifun(szA(dim),szB(dim)));
    end
    A = zeros(szC,classA); % empty -> return zeros
    return
end

power2flag = getoption(options, 'Power2Flag', true);
if power2flag
    % faster FFT if the dimension is power of 2
    lfftfun = @(l) 2^nextpow2(l);
else
    % slower, but smaller temporary arrays
    lfftfun = @(l) l;
end

if GPU % GPU/Jacket FFT
    if strcmp(classA,'single')
        A = gsingle(A);
    else
        A = gdouble(A);
    end
    if strcmp(classB,'single')
        B = gsingle(B);
    else
        B = gdouble(B);
    end
    % Do the FFT
    subs(1:ndims(A)) = {':'};
    for dim=dims
        m = size(A,dim);
        n = size(B,dim);
        % compute the FFT length
        l = lfftfun(m+n-1);
        % We need to swap dimensions because GPU FFT works along the
        % first dimension
        if dim~=1 % do the work when only required
            swap = 1:nd;
            swap([1 dim]) = swap([dim 1]);
            A = permute(A, swap);
            B = permute(B, swap);
        end
        A = fft(A,l);
        B = fft(B,l);
        subs{dim} = ifun(m,n);
    end
else % Matlab FFT
    % Do the FFT
    subs(1:ndims(A)) = {':'};
    for dim=dims
        m = size(A,dim);
        n = size(B,dim);
        % compute the FFT length
        l = lfftfun(m+n-1);
        A = fft(A,l,dim);
        B = fft(B,l,dim);
        subs{dim} = ifun(m,n);
    end
end
 
if GPU
    A = A.*B;
    clear B
else
    % inplace product to save 1/3 of the memory
	% Modified by Alberto Andreotti(albertoandreotti@gmail.com)
    %inplaceprod(A,B);
	A(:) = A(:).*B(:);
end

% Back to the non-Fourier space
if GPU % GPU/Jacket FFT
    for dim=dims(end:-1:1) % reverse loop
        A = ifft(A,[]);
        % Swap back the dimensions
        if dim~=1 % do the work when only required
            swap = 1:nd;
            swap([1 dim]) = swap([dim 1]);
            A = permute(A, swap);
        end        
    end   
else % Matlab IFFT  
    for dim=dims
        A = ifft(A,[],dim);
    end
end

% Truncate the results
if ABreal
    % Make sure the result is real
    A = real(A(subs{:}));
else
    A = A(subs{:});
end

% GPU/Jacket
if GPU
    % Cast the type back
    if strcmp(class(A),'gsingle')
        A = single(A);
    else
        A = double(A);
    end
end

end % convnfft


%% Get defaut option
function value = getoption(options, name, defaultvalue)
% function value = getoption(options, name, defaultvalue)
    value = defaultvalue;
    fields = fieldnames(options);
    found = strcmpi(name,fields);
    if any(found)
        i = find(found,1,'first');
        if ~isempty(options.(fields{i}))
            value = options.(fields{i});
        end
    end
end
