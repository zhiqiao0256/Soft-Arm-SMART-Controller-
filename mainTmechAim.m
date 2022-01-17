%% Main function for stiffness ID use data 0722
%%% Major chanages:
%%%
clear all
close all
clc
%%
smc_base=load('smc_base.mat');
smc_wood=load('smc_wood.mat');

smcndob_base=load('smcndob_base.mat');
smcndob_wood=load('smcndob_wood.mat');

smart_base=load('smart_base.mat');
smart_wood=load('smart_wood.mat');
%% base pos tracking combo
close all
testData1= smc_base.smc;
testData2= smcndob_base.smcndob;
testData3= smart_base.smart;
fig_width=7/4;
fig_height=7/4;
%%% fig 1
s_pt=1;e_pt=length(testData1.xd_exp(:,2));
fp=figure('units','inches','Position',[4,4,fig_width,fig_height]);
plot(testData1.xd_exp(s_pt:e_pt,1)-testData1.xd_exp(s_pt,1),testData1.xd_exp(s_pt:e_pt,2),'r','LineStyle','-.','LineWidth',2)
hold on
plot(testData1.x1_exp(s_pt:e_pt,1)-testData1.xd_exp(s_pt,1),testData1.x1_exp(s_pt:e_pt,2),'r','LineStyle','-','LineWidth',1)
hold on
s_pt=1;e_pt=length(testData2.xd_exp(:,2));
% plot(testData2.xd_exp(s_pt:e_pt,1)-testData2.xd_exp(s_pt,1),testData2.xd_exp(s_pt:e_pt,2),'b','LineStyle','-.','LineWidth',2)
hold on
% plot(testData2.x1_exp(s_pt:e_pt,1)-testData2.xd_exp(s_pt,1),testData2.x1_exp(s_pt:e_pt,2),'b','LineStyle','-','LineWidth',1)
hold on
s_pt=1;e_pt=length(testData3.xd_exp(:,2));
% plot(testData3.xd_exp(s_pt:e_pt,1)-testData3.xd_exp(s_pt,1),testData3.xd_exp(s_pt:e_pt,2),'k','LineStyle','-.','LineWidth',2)
hold on
plot(testData3.x1_exp(s_pt:e_pt,1)-testData3.xd_exp(s_pt,1),testData3.x1_exp(s_pt:e_pt,2),'k','LineStyle','-','LineWidth',1)
ylabel('Angle (rad)')
xlabel('Time (second)')
xlim([0,50])
ylim([-0.9,-0.05])
leg=legend({'${\theta_d}$','$\theta_{b1}$','$\theta_{b2}$','$\theta_{p}$'},'Orientation','vertical','Location','south','Units','inches','Interpreter','latex')
leg.ItemTokenSize = [20,20];
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
%%%% disturbance
fp=figure('units','inches','Position',[4,4,fig_width,fig_height]);
plot(testData3.x1_exp(s_pt:e_pt,1)-testData3.xd_exp(s_pt,1),testData3.dist_est_inner_tau(s_pt:e_pt),'r','LineWidth',2)
leg=legend('$\hat{\Delta}$','Interpreter','latex','Orientation','horizontal','Location','northeast')
leg.ItemTokenSize = [20,20];
ylabel('Disturbance (Nm)')
xlabel('Time (second)')
ylim([-0.0,0.5])
xlim([0,50])
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
%% base pos tracking only smart as example
close all
testData1= smc_base.smc;
testData2= smcndob_base.smcndob;
testData3= smart_base.smart;
fig_width=7/4;
fig_height=7/4;
%%% fig 1
s_pt=1;e_pt=length(testData1.xd_exp(:,2));
fp=figure('units','inches','Position',[4,4,fig_width,fig_height]);
s_pt=1;e_pt=length(testData3.xd_exp(:,2));
plot(testData3.xd_exp(s_pt:e_pt,1)-testData3.xd_exp(s_pt,1),testData3.xd_exp(s_pt:e_pt,2),'r','LineStyle','-.','LineWidth',2)
hold on
plot(testData3.x1_exp(s_pt:e_pt,1)-testData3.xd_exp(s_pt,1),testData3.x1_exp(s_pt:e_pt,2),'b','LineStyle','-','LineWidth',1)
ylabel('Angle (rad)')
xlabel('Time (second)')
xlim([0,50])
ylim([-0.5,-0.05])
leg=legend({'${\theta_d}$','$\theta_{m}$'},'Orientation','vertical','Location','north','Units','inches','Interpreter','latex')
leg.ItemTokenSize = [20,20];
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
%%%% disturbance
fp=figure('units','inches','Position',[4,4,fig_width,fig_height]);
plot(testData3.x1_exp(s_pt:e_pt,1)-testData3.xd_exp(s_pt,1),testData3.dist_est_inner_tau(s_pt:e_pt),'k','LineWidth',2)
leg=legend('$\hat{\Delta}$','Interpreter','latex','Orientation','horizontal','Location','northeast')
leg.ItemTokenSize = [20,20];
ylabel('Disturbance (Nm)')
xlabel('Time (second)')
ylim([-0.0,0.5])
xlim([0,50])
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
%%%% Pressure compare
fp=figure('units','inches','Position',[4,4,fig_width,fig_height]);
s_pt=1;e_pt=length(testData1.xd_exp(:,2));
plot(testData1.x1_exp(s_pt:e_pt,1)-testData1.xd_exp(s_pt,1),testData1.pm_MPa(s_pt:e_pt,2),'b','LineWidth',1)%+0.07
hold on
s_pt=1;e_pt=length(testData3.xd_exp(:,2));
plot(testData3.x1_exp(s_pt:e_pt,1)-testData3.xd_exp(s_pt,1),testData3.pm_MPa(s_pt:e_pt,2),'k','LineWidth',2)
hold on
leg=legend('{smc}','{smart}','Interpreter','latex','Orientation','vertical','Location','south')
leg.ItemTokenSize = [20,20];
ylabel('Air Pressrue (MPa)')
xlabel('Time (second)')
ylim([0,0.25])
xlim([0,50])
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
%% Fwd kinematic 
clear all
close all
clc
load('fk_data.mat');
%%
close all
testData=[];
par_set.L=0.18;%actuator length
testData=par_set.trial3;
testData = funcGetPhiThetaRifromXYZ(testData,par_set);
testData=funcFwdKinematic5link(testData,par_set);
testData2=testData;
testData2.Ri=testData.Ri*0.0;
testData2=funcFwdKinematic5link(testData2,par_set);
funcCompareKinematicXYZ2models(testData,testData2,testData.xyz_estimation,testData2.xyz_estimation,par_set)