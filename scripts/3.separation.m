clear all; close all; clc;
global_setup;

% List of algos
algos = {'MUR','SAGE','EM','SAGE_MUR','EM_MUR'};
Nalgos = length(algos);

% Initialize score / loss / time arrays
score = zeros(Nalgos,3,Nmixtures,Nd);
loss_is_sep = zeros(Nalgos,Nsep+1,Nmixtures,Nd);
time_sep = zeros(Nalgos,Nsep+1,Nmixtures,Nd);

% loop over dic size
for k=1:Nd
    
    K = dicosize(k);
    load(strcat(out_path,'dico_',int2str(K),'.mat'));

    rec_dir = strcat(audio_path,'dico_',int2str(K),'/');
    mkdir(rec_dir);

    % loop over mixtures
    for m=1:Nmixtures
      
        % Load original sources (useful for computing the score)
        sm1 = audioread(strcat(mix_path,'mix',int2str(m),'_source1.wav'))';
        sm2 = audioread(strcat(mix_path,'mix',int2str(m),'_source2.wav'))';
        
        % Load mixture
        x = audioread(strcat(mix_path,'mix',int2str(m),'.wav'))';
        X = STFT(x,Nfft,hop,Nw,wtype);
        V = abs(X).^2+eps;
        [F,T] = size(X);

        % Initial H matrix
        Hini = cell(1,2); Hinik = zeros(2*K,T);
        Hini{1} = rand(K,T); Hini{2} = rand(K,T);
        Hinik(1:K,:) = Hini{1}; Hinik(K+1:end,:) = Hini{2};
        
        % Form a cell for W matrix
        Wc = cell(1,2); Wc{1} = W(:,1:K); Wc{2} = W(:,K+1:end);
        
        % Loop over NMF algorithms
        for al=1:Nalgos
          
          clc; fprintf('Dico %d / %d  \n mixture %d / %d  \n algo  %d / %d',k,Nd,m,Nmixtures,al,Nalgos);
        
          % NMFs
          switch algos{al}
            case 'MUR'
              [~,H,cost,ts] = isnmf_ML_MUR(V, Nsep, W, Hinik, 0);
            case 'SAGE'
              [~,H,cost,ts] = isnmf_SAGE(V, Nsep, W+eps, Hinik, 0);
            case 'EM'
              [~,H,cost,ts] = isnmf_EM(V, Nsep, W+eps, Hinik, 0);
            case 'SAGE_MUR'
              [~,H,cost,ts] = isnmf_SAGE_MUR(V, Nsep, Wc, Hini, 0);
              H = cell2mat(H');
            case 'EM_MUR'
              [~,H,cost,ts] = isnmf_EM_MUR(V, Nsep, Wc, Hini, 0);
              H = cell2mat(H');
          end
        
        % Store loss and time over iterations
        loss_is_sep(al,:,m,k) = cost;
        time_sep(al,:,m,k) = ts;
        
        % Wiener filter
        V1 = W(:,1:K)*H(1:K,:); V2 = W(:,K+1:end)*H(K+1:end,:);
        Xe1 = V1 / (V1 + V2) * X; Xe2 = V2 / (V1 + V2) * X;

        % Synthesis
        se1 = iSTFT(Xe1,Nfft,hop,Nw,wtype);
        se2 = iSTFT(Xe2,Nfft,hop,Nw,wtype);
        
        % Record
        audiowrite(strcat(rec_dir,'mix',int2str(m),'_source1_',algos{al},'.wav'),se1,Fs);
        audiowrite(strcat(rec_dir,'mix',int2str(m),'_source2_',algos{al},'.wav'),se2,Fs);
        
        % Score
        [sd,si,sa] = GetSDR([se1 se2]',[sm1 sm2]');
        score(al,:,m,k) = mean([sd si sa]);
        
        end
        
    end

end

% Record score, loss, and computational time
save(strcat(out_path,'separation.mat'),'score','loss_is_sep','time_sep','algos');
