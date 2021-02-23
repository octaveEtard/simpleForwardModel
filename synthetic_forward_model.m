% make a TRF, convolve it with speech envelope to create synthetic EEG, and
% then attempt to deconvolve the EEG to test the code
%
% Make sure the 'functions' folder is in your path to use this code.
% This can be done by running:
% addpath('./functions'); % edit path if necessary

% path to the folder containing the data
dataFolder = './data';

% lags where to derive TRF
minLagT = -100e-3; % in s
maxLagT = 500e-3; % in s

nParts = 4;

Fs = 50; % sampling rate


%%
% time to index
minLag = floor(minLagT * Fs);
maxLag = ceil(maxLagT * Fs);

nLags = maxLag - minLag + 1;

% forward model: predictor = envelope, predicted = EEG
% XtX = auto-correlation matrix of the envelope
XtX = zeros(nLags,nLags);
% Xty = cross-correlation EEG - envelope
Xty = zeros(nLags,1);

% --- synthetic (ground truth) TRF as a Gaussian pulse
delayResponse = 200e-3; % in s
widthResponse = 50e-3; % in s
        
tMax = max(abs([minLagT,maxLagT]));
nMax = ceil(tMax*Fs)+1;
t = (-nMax:nMax)'/Fs;
groundTruthTRF = normpdf(t,delayResponse,widthResponse);
groundTruthTRF = groundTruthTRF / max(groundTruthTRF);


for iPart = 1:nParts

    % load envelope
    envFileName = sprintf('env_siq_%i.mat',iPart);
    env = load(fullfile(dataFolder,envFileName));
    env = env.attended; % now a nPnts x 1 vector
    
    % make synthetic EEG data
    eeg = conv(env,groundTruthTRF,'same');

    % form the matrices on this part
    [XtX_, Xty_] = crossMatrices(env,eeg,minLag,maxLag);
    
    % accumulate the cross-matrices matrices over parts = same as forming
    % the matrices on all the data
    XtX = XtX + XtX_;
    Xty = Xty + Xty_;
end


%% Compare ground truth TRF and deconvolved TRF
tms = 1e3 * (minLag:maxLag) / Fs; % in ms

% solution with no regularisation
trf = XtX \ Xty;

% ridge regularisation
% meanEigen = trace(XtX) / nLags; % mean eigenvalue of XtX
% this synthetic example has a very high SNR, and little regularisation is
% needed
% lambda2 = 1e-3 * meanEigen;
% trf = (XtX + lambda2 * eye(nLags,nLags))\ Xty;

% compare the ground truth and recoved TRF
figure; ax = axes(); hold on;
plot(1e3*t,groundTruthTRF,'k');
plot(tms,trf,'r');
legend({'True TRF','Recovered TRF'},'box','off');
ax.XAxis.Label.String = 'Time (ms)';
ax.YAxis.Label.String = 'Amplitude (a.u.)';
ax.Title.String = 'Synthetic data';
%
%