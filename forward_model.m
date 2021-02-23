% Derive TRFs on real EEG data
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
nChan = 64; % 64 EEG channels
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
Xty = zeros(nLags,nChan);

% data for sub index 1
iSub = 1;

for iPart = 1:nParts
    % load EEG data
    eegFileName = sprintf('eeg_sub_%i_siq_%i.mat',iSub,iPart);
    eeg = load(fullfile(dataFolder,eegFileName));
    eeg = eeg.eeg; % now a nPnts x nChan matrix
    
    % load envelope
    envFileName = sprintf('env_siq_%i.mat',iPart);
    env = load(fullfile(dataFolder,envFileName));
    env = env.attended; % now a nPnts x 1 vector
    
    % form the matrices on this part
    [XtX_, Xty_] = crossMatrices(env,eeg,minLag,maxLag);
    
    % accumulate the cross-matrices matrices over parts = same as forming
    % the matrices on all the data
    XtX = XtX + XtX_;
    Xty = Xty + Xty_;
end

% load channe locations
chanLocs = load(fullfile(dataFolder,'chanLocs-64.mat'));
chanLocs = chanLocs.chanLocs;


%% Compute TRFs
tms = 1e3 * (minLag:maxLag) / Fs; % in ms


% -- solution with no regularisation
trf = XtX \ Xty;

% -- OR: ridge regularisation
% meanEigen = trace(XtX) / nLags; % mean eigenvalue of XtX
% lambda2 = 0.5 * meanEigen;
% trf = (XtX + lambda2 * eye(nLags,nLags))\ Xty;

% -- OR: curve penalty
% L = curvePenaltyMatrix(nLags);
% lambda2 = 0.5 * meanEigen; % the 
% trf = (XtX + lambda2 * (L'*L))\ Xty;

%% Plot TRFs
% the 64 channels have known locations --> we can plot the topography of
% the responses at given time lags
% when to plot scalp topography (in ms)
t0 = [80,140,240]';
[~,it0] = min(abs(tms-t0),[],2); % using the closest latency
t0 = tms(it0);
nt0 = numel(t0);

figure;
% --- plot trf
ax = subplot(2,nt0,1:nt0);
plot(tms,trf);
arrayfun(@(t) xline(t,'--'),t0);
ax.XAxis.Label.String = 'Time (ms)';
ax.YAxis.Label.String = 'Amplitude (a.u.)';
ax.Title.String = 'Temporal Response Function';

% --- plot topoplots
for it = 1:nt0
    ax = subplot(2,nt0,nt0+it);
    % this function is from the EEGLAB toolbox:
    topoplot(trf(it0(it),:), chanLocs);
    ax.Title.String = sprintf('t = %i ms',t0(it));
end
%
%
%