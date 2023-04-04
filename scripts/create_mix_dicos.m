clear all; close all; clc;
set_params;

% Create mixtures and dicos indices
list_mix = randi(Nsentencestotal,Nmixtures,2);
stenlist1 = 1:Nsentencestotal; popo = unique(list_mix(:,1)); stenlist1(popo) = [];
stenlist2 = 1:Nsentencestotal; popo = unique(list_mix(:,2)); stenlist2(popo) = [];

% Get file names
D = dir(strcat(path_dataset,'1/','*.wav')) ; D = D(~cell2mat({D(:).isdir})) ; Listwav = {D(:).name} ; listmix1 = Listwav(list_mix(:,1)); listdico1 = Listwav(stenlist1);
D = dir(strcat(path_dataset,'4/','*.wav')) ; D = D(~cell2mat({D(:).isdir})) ; Listwav = {D(:).name} ; listmix2 = Listwav(list_mix(:,2)); listdico2 = Listwav(stenlist2);

% Create the mix signals
for j=1:Nmixtures
    
    % Read sources
    s1 = audioread(strcat(path_dataset,'1/',listmix1{j})); l1 = length(s1);
    s2 = audioread(strcat(path_dataset,'4/',listmix2{j})); l2 = length(s2);
    
    % Zero-pad the shortest
    s = zeros(max(l1,l2),2);
    s(1:l1,1)=s1; s(1:l2,2)=s2;
    
    % Root mean square equalization
    s(:,1) = s(:,1) ./ norm(s(:,1)) .* norm(s(:,2));
    s = s';
    
    % Mixture
    x = sum(s,1);
    
    % STFT and inverse STFT (proper size)
    X=STFT(x,Nfft,hop,Nw,wtype); x=iSTFT(X,Nfft,hop,Nw,wtype);
    S=STFT(s,Nfft,hop,Nw,wtype); s=iSTFT(S,Nfft,hop,Nw,wtype);
   
    % Record
    audiowrite(strcat('audio_files/mixtures/mix',int2str(j),'.wav'),x,Fs);
    audiowrite(strcat('audio_files/mixtures/mix',int2str(j),'_source1.wav'),s(1,:),Fs);
    audiowrite(strcat('audio_files/mixtures/mix',int2str(j),'_source2.wav'),s(2,:),Fs);
    
end

% Create the dico signals
x1 = [];
for j=1:length(listdico1)
    s = audioread(strcat(path_dataset,'1/',listdico1{j}))';
    x1 = [x1 s];
end
audiowrite('audio_files/dicos/dico1.wav',x1,Fs);

x2 = [];
for j=1:length(listdico2)
    s = audioread(strcat(path_dataset,'4/',listdico2{j}))';
    x2 = [x2 s];
end
audiowrite('audio_files/dicos/dico2.wav',x2,Fs);
