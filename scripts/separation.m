clear all; close all; clc;
set_params;

cost_sep = zeros(5,Nsep+1,Nmixtures,Nd);
tsep = zeros(5,Nsep+1,Nmixtures,Nd);

for k=1:Nd
    
    clc; fprintf('Dico %d / %d  \n',k,Nd);
    K = dicosize(k);
    load(strcat('dictionaries/dico_',int2str(K),'.mat'));

    for iter=1:Nmixtures

        fprintf('mix %d / %d  \n',iter,Nmixtures);

        % Load mixture
        x = audioread(strcat('audio_files/mixtures/mix',int2str(iter),'.wav'))';
        X = STFT(x,Nfft,hop,Nw,wtype);
        V = abs(X).^2+eps;
        [F,T] = size(X);

        % Initial H matrix
        Hini = cell(1,2); Hinik = zeros(2*K,T);
        Hini{1} = rand(K,T); Hini{2} = rand(K,T);
        Hinik(1:K,:) = Hini{1}; Hinik(K+1:end,:) = Hini{2};
        
        % Form a cell for W matrix
        Wc = cell(1,2); Wc{1} = W(:,1:K); Wc{2} = W(:,K+1:end);
        
        % NMFs
        [~,HMUR,cost_ML_MUR,tMUR] = isnmf_ML_MUR(V, Nsep, W, Hinik, 0);
        [~,HSAGE,cost_SAGE,tSAGE] = isnmf_SAGE(V, Nsep, W+eps, Hinik, 0);
        [~,HEM,cost_EM,tEM] = isnmf_EM(V, Nsep, W+eps, Hinik, 0);
        [~,HSAGE_MUR,cost_SAGE_MUR,tSAGE_MUR] = isnmf_SAGE_MUR(V, Nsep, Wc, Hini, 0);
        [~,HEM_MUR,cost_EM_MUR,tEM_MUR] = isnmf_EM_MUR(V, Nsep, Wc, Hini, 0);

        tsep(:,:,iter,k) = [tMUR;tSAGE;tEM;tSAGE_MUR;tEM_MUR];
        cost_sep(:,:,iter,k) = [cost_ML_MUR;cost_SAGE;cost_EM;cost_SAGE_MUR;cost_EM_MUR];

        % Wiener filtering 
        Xaux = zeros(F,T,2*K,5); 
        Xaux(:,:,:,1) = wiener(X,W,HMUR);
        Xaux(:,:,:,2) = wiener(X,W,HSAGE);
        Xaux(:,:,:,3) = wiener(X,W,HEM);
        Xaux(:,:,:,4) = wiener(X,W,cell2mat(HSAGE_MUR'));
        Xaux(:,:,:,5) = wiener(X,W,cell2mat(HEM_MUR'));
        
        % Recovering 2 sources
        Xs = zeros(F,T,2,5);
        Xs(:,:,1,:) = squeeze(sum(Xaux(:,:,1:K,:),3));
        Xs(:,:,2,:) = squeeze(sum(Xaux(:,:,K+1:end,:),3));

        % Synthesis and record
        for al=1:5
            se = iSTFT(squeeze(Xs(:,:,:,al)),Nfft,hop,Nw,wtype);
            audiowrite(strcat('audio_files/separation/dico_',int2str(K),'/mix',int2str(iter),'_source1_algo',int2str(al),'.wav'),se(1,:),Fs);
            audiowrite(strcat('audio_files/separation/dico_',int2str(K),'/mix',int2str(iter),'_source2_algo',int2str(al),'.wav'),se(2,:),Fs);
        end
        
    end

end


save('metrics/separation_is_time.mat','cost_sep','tsep');