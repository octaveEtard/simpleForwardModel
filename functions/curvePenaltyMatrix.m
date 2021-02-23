function L = curvePenaltyMatrix(nLags)
% curvePenaltyMatrix 2TD penalty compute discrete ~2nd derivative operator.
% Not normalised by sampling rate
%
% octave.etard11@imperial.ac.uk ; github.com/octaveEtard
%

L = zeros(nLags,nLags);

% diagonal
L([1,nLags*nLags]) = 1;
L((nLags+2):(nLags+1):(nLags*nLags-nLags-1)) = -2;
% lower diagonal
L(2:(nLags+1):(nLags*nLags-2*nLags-1)) = 1;
% upper diagonal
L((2*nLags+2):(nLags+1):(nLags*nLags-1)) = 1;

end
%
%