function [XtX, Xty] = crossMatrices(x,y,minLag,maxLag)
%
% Compute cross-lagged matrices XtX and Xty based on the timeseries x & y
% and lag values minLag <= maxLag (integers).
%
% octave.etard11@imperial.ac.uk ; github.com/octaveEtard
%
nPnts = size(x,1);
nLags = maxLag - minLag + 1;

assert( nPnts == size(y,1),'x & y should contain the same number of points!');

% compute how much padding needs to be added, and relevant indices
opt = laggedDims(nPnts,minLag,maxLag);

% zero-pad x
x = pad(x,opt.nPadx,opt.nPadx);
% zero-pad y
y = pad(y,opt.nPady_b,opt.nPady_e);

% make lagged matrix X
X = lagMatrix(x,nLags);
% select corresponding points in y
Y = y(opt.yb:opt.ye,:);

% remove mean
X = X - mean(X,1);
Y = Y - mean(Y,1);

% compute cross-matrices
XtX = X' * X;
Xty = X' * Y;
end
%
%