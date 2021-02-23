function opt = laggedDims(nPnts,minLag,maxLag)
%
% laggedDims
%
% Compute relevant indices to form matrices X & y
%
% Input:
%
% nPnts [integer]: number of points in x & y
% minLag, maxLag [integers]: extent of the window in x that should be
% considered to model each point in y (minLag <= maxLag is required).
%
% # Behaviour:
%
% Use window in x such that the first window ends at index 1 and the last
% one begins at index nx (full coverage of x / all the points of x are
% used).
%
% If the corresponding points that are modelled in y (depending on the
% values of minLag / maxLag) do not exist, y is padded with 0 as needed.
%
% Output (in opt structure):
%
% nPadx : number of zeros to add at the begining / end of x
%
% nPady_b : number of zeros to add at the begining of y
% nPady_e : number of zeros to add at the end of y
% yb, ye: indices of the points in padded y modeled by the first and last
% windows on padded x.
%
% octave.etard11@imperial.ac.uk ; github.com/octaveEtard
%


%% Sanity check
assert(minLag <= maxLag,'minLag <= maxLag is required!');


%% Points to use in padded X / Y matrices
% 
% With padding, the first window ends at index 1, and the last window
% begins at index nx (full coverage of x).
nPadx = maxLag - minLag;

% first / last point in y corresponding to padded windows at the begining
% of x
%
% A window modeling point i0 will extend from i0-maxLag to i0-minLag
% For the first window: i0 - minLag = 1
yb = 1 + minLag;
% if yb < 1, we need padding:
if yb < 1
    nPady_b = 1 - yb;
    yb = 1;
else
    nPady_b = 0;
end

% For the last window: i0 - maxLag = nPnts
ye = nPnts + maxLag;
% if nPnts < ye, we need padding:
if nPnts < ye
    nPady_e = ye - nPnts;
    ye = nPnts + nPady_e;
else
    nPady_e = 0;
end

% if we padded the begining of x, the index ye needs to be shifted
ye = ye + nPady_b;

opt = struct(...
    'nPadx',nPadx,...
    'yb',yb,...
    'ye',ye,...
    'nPady_b',nPady_b,...
    'nPady_e',nPady_e);
end
%
%