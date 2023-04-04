clear all; close all; clc;
set_params;

score = zeros(5,3,Nd,Nmixtures);

for k=1:Nd
    K = dicosize(k);
    for iter = 1:Nmixtures

        % Load original sources
        sm1 = audioread(strcat('audio_files/mixtures/mix',int2str(iter),'_source1.wav'));
        sm2 = audioread(strcat('audio_files/mixtures/mix',int2str(iter),'_source2.wav'));
        sm = [sm1 sm2]';

        % Load estimated sources and BSS eval
        for al=1:5
            se1 = audioread(strcat('audio_files/separation/dico_',int2str(K),'/mix',int2str(iter),'_source1_algo',int2str(al),'.wav'));
            se2 = audioread(strcat('audio_files/separation/dico_',int2str(K),'/mix',int2str(iter),'_source2_algo',int2str(al),'.wav'));
            se = [se1 se2]';
            [sd,si,sa] = GetSDR(se,sm);
            score(al,:,k,iter) = mean([sd si sa]);
        end

    end
end

save(strcat('metrics/separation_bss.mat'),'score');

% Mean score
scoremean = mean(score,4);