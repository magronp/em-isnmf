clear all; close all; clc;
global_setup;

%%% Performance of dictionary learning in terms of loss and time (Fig. 1)
load(strcat(out_path,'dico_learning.mat'));

figure;
subplot(1,2,1); bar(mean(loss_is_dic,3)');
set(gca,'xticklabel',{'MUR','EM','SAGE'},'fontsize',16)
ylabel('IS divergence','fontsize',16);
subplot(1,2,2); bar(mean(time_dico,3)');
set(gca,'xticklabel',{'MUR','EM','SAGE'},'fontsize',16)
ylabel('Time (s)','fontsize',16);
legend('K=10','K=50','K=100');

%%% Convergence at the test stage (Fig. 2)
load(strcat(out_path,'separation.mat'));
loss_is = squeeze(mean(loss_is_sep,3));

figure;
subplot(1,3,1);
loglog(1:Nsep,loss_is(2,1:end-1,1),'b',1:Nsep,loss_is(3,1:end-1,1),'b-*',1:Nsep,loss_is(4,1:end-1,1),'r',1:Nsep,loss_is(5,1:end-1,1),'r-*',1:Nsep,loss_is(1,1:end-1,1),'r--');
xlabel('Iterations','fontsize',16);
ylabel('IS divergence','fontsize',16);
hl=legend('SAGE','EM','SAGE-MUR','EM-MUR','ML-MUR'); set(hl,'fontsize',14);
title('$K_j = 10$','interpreter','latex');

subplot(1,3,2);
loglog(1:Nsep,loss_is(2,1:end-1,2),'b',1:Nsep,loss_is(3,1:end-1,2),'b-*',1:Nsep,loss_is(4,1:end-1,2),'r',1:Nsep,loss_is(5,1:end-1,2),'r-*',1:Nsep,loss_is(1,1:end-1,2),'r--');
xlabel('Iterations','fontsize',16);
ylabel('IS divergence','fontsize',16);
title('$K_j = 50$','interpreter','latex');

subplot(1,3,3);
loglog(1:Nsep,loss_is(2,1:end-1,3),'b',1:Nsep,loss_is(3,1:end-1,3),'b-*',1:Nsep,loss_is(4,1:end-1,3),'r',1:Nsep,loss_is(5,1:end-1,3),'r-*',1:Nsep,loss_is(1,1:end-1,3),'r--');
xlabel('Iterations','fontsize',16);
ylabel('IS divergence','fontsize',16);
title('$K_j = 100$','interpreter','latex');

%%% BSS score (Table 1)
res_list = {'SDR', 'SIR', 'SAR', 'Time'}
tsep_av = squeeze(mean(time_sep(:,end,:,:),3));
score_av = real(squeeze(mean(score,3)));

for k=1:Nd
    all_res = dataframe([{''},res_list;algos',num2cell([squeeze(score_av(:,:,k)) tsep_av(:,k)])]);
    fprintf(strcat(' -------------- Dictionary size = ',int2str(dicosize(k)),'---------------'));
    display(all_res);
end


