pkg load signal dataframe

% Sample rate
Fs = 25000;

% Data folders
data_dir = 'data/';
dataset_path = strcat(data_dir,'grid/');
mix_path = strcat(data_dir,'mixtures/');
dico_path = strcat(data_dir,'dicos/');
mkdir(mix_path); mkdir(dico_path);

% Outputs and recorded audio folders
out_path = 'outputs/';
audio_path = 'audio_files/';

% Speaker indices
spk1 = 's1/';
spk2 = 's4/';

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

% Random seed for reproducibility
rand("state", 42);
