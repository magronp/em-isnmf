clear all; close all; clc;
set_params;

isdiv = zeros(Nd,3,2); timesec = zeros(Nd,3,2);

%%% Load dicos signals
x1 = audioread('audio_files/dicos/dico1.wav')';
x2 = audioread('audio_files/dicos/dico2.wav')';

% STFTs and magnitude normalization
F = Nw/2+1;
V1 = abs(STFT(x1,Nfft,hop,Nw,wtype));  V1= V1 ./ repmat(sum(V1,1),[F 1]); T1 = size(V1,2); V1 = V1.^2;
V2 = abs(STFT(x2,Nfft,hop,Nw,wtype));  V2= V2 ./ repmat(sum(V2,1),[F 1]); T2 = size(V2,2); V2 = V2.^2;


% Loop on the dictionary sizes
for k=1:Nd
    
    clc; fprintf('Dico size %d / %d \n',k,Nd);
    K = dicosize(k);
    
    % Speaker 1
    fprintf('Speaker 1 \n');
    Hini = rand(K,T1); Wini = rand(F,K);
    
    fprintf('MUR \n');
    [W1,~,is,tim] = isnmf_ML_MUR(V1,Ndico,Wini,Hini);
    isdiv(k,1,1) = is(end); timesec(k,1,1) = tim(end);
    
    fprintf('SAGE \n');
    [~,~,is,tim] = isnmf_SAGE(V1, Ndico, Wini, Hini);
    isdiv(k,2,1) = is(end); timesec(k,2,1) = tim(end);
    
    fprintf('EM \n');
    [~,~,is,tim] = isnmf_EM(V1, Ndico, Wini, Hini);
    isdiv(k,3,1) = is(end); timesec(k,3,1) = tim(end);
    
    
    % Speaker 2
    fprintf('Speaker 2 \n');
    Hini = rand(K,T2); Wini = rand(F,K);
    
    fprintf('MUR \n');
    [W2,~,is,tim] = isnmf_ML_MUR(V2,Ndico,Wini,Hini);
    isdiv(k,1,2) = is(end); timesec(k,1,2) = tim(end);
    
    fprintf('SAGE \n');
    [~,~,is,tim] = isnmf_SAGE(V2, Ndico, Wini, Hini);
    isdiv(k,2,2) = is(end); timesec(k,2,2) = tim(end);
    
    fprintf('EM \n');
    [~,~,is,tim] = isnmf_EM(V2, Ndico, Wini, Hini);
    isdiv(k,3,2) = is(end); timesec(k,3,2) = tim(end);    
    
    % Full dico
    W = [W1 W2];
    save(strcat('dictionaries/dico_',int2str(K),'.mat'),'W');
    
end


%%% Save IS and time
save('metrics/dico_is_time.mat','isdiv','timesec');

