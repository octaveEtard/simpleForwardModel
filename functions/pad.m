function x = pad(x,nPad_b,nPad_e)
%
% padx
% octave.etard11@imperial.ac.uk ; github.com/octaveEtard
%
nCol = size(x,2);
% zero pad x
x = [zeros(nPad_b,nCol) ; x ; zeros(nPad_e,nCol)];
end
%
%