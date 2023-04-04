clear all; close all; clc;
set_params;

% Dictionary learning metrics
load('metrics/dico_is_time.mat','isdiv','timesec');

figure;
subplot(1,2,1); bar(mean(isdiv,3)');
set(gca,'xticklabel',{'MUR','EM','SAGE'},'fontsize',16)
ylabel('IS divergence','fontsize',16);

subplot(1,2,2); bar(mean(timesec,3)');
set(gca,'xticklabel',{'MUR','EM','SAGE'},'fontsize',16)
ylabel('Time (s)','fontsize',16);
legend('K=10','K=50','K=100');

% Separation metrics
load('metrics/separation_is_time.mat');
cost_sep = squeeze(mean(cost_sep,3)); tsep = squeeze(mean(tsep,3));

figure;
subplot(1,3,1);
loglog(1:Nsep,cost_sep(2,1:end-1,1),'b',1:Nsep,cost_sep(3,1:end-1,1),'b-*',1:Nsep,cost_sep(4,1:end-1,1),'r',1:Nsep,cost_sep(5,1:end-1,1),'r-*',1:Nsep,cost_sep(1,1:end-1,1),'r--');
xlabel('Iterations','fontsize',16);
ylabel('IS divergence','fontsize',16);
hl=legend('SAGE','EM','SAGE-MUR','EM-MUR','ML-MUR'); set(hl,'fontsize',14);
title('$K_j = 10$','interpreter','latex');

subplot(1,3,2);
loglog(1:Nsep,cost_sep(2,1:end-1,2),'b',1:Nsep,cost_sep(3,1:end-1,2),'b-*',1:Nsep,cost_sep(4,1:end-1,2),'r',1:Nsep,cost_sep(5,1:end-1,2),'r-*',1:Nsep,cost_sep(1,1:end-1,2),'r--');
xlabel('Iterations','fontsize',16);
ylabel('IS divergence','fontsize',16);
title('$K_j = 50$','interpreter','latex');

subplot(1,3,3);
loglog(1:Nsep,cost_sep(2,1:end-1,3),'b',1:Nsep,cost_sep(3,1:end-1,3),'b-*',1:Nsep,cost_sep(4,1:end-1,3),'r',1:Nsep,cost_sep(5,1:end-1,3),'r-*',1:Nsep,cost_sep(1,1:end-1,3),'r--');
xlabel('Iterations','fontsize',16);
ylabel('IS divergence','fontsize',16);
title('$K_j = 100$','interpreter','latex');