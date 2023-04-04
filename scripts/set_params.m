% Sample rate
Fs = 25000;

% Path of the dataset
path_dataset = 'datasets/';


% STFT parameters
Nw=1500;
Nfft=Nw;
hop = Nw/4; 
wtype = 'hann';

% NMF parameters
Ndico = 1000; % iterations for dico learning
Nsep = 100; % iterations for separation
dicosize = [10 50 100]; %dico size per speaker
Nd = length(dicosize);

% Number of mixtures/speakers/sentences for testing
Nmixtures = 10;
Nsentencestotal = 100;