%%% main function for low level dyn.  use data 0706%%%
clear all
close all
clc
%% Initialization
par_set=[]; 
par_set.flag_read_exp=1;

if par_set.flag_read_exp ==1 % select between load txt or mat file
    par_set.flag_read_mat=0;
else
    par_set.flag_read_mat=1;
end
%
par_set.trail_1_25_01Hzpsi=[];
par_set.trail_1_25_0125Hzpsi=[];
par_set.trail_1_25_025Hzpsi=[];
par_set.trail_1_25_05Hzpsi=[];
par_set.trail_1_25_1Hzpsi=[];
par_set.trail_0_25_01Hzpsi=[];
par_set.trail_0_25_0125Hzpsi=[];
par_set.trail_0_25_025Hzpsi=[];
par_set.trail_0_25_05Hzpsi=[];
par_set.trail_0_25_1Hzpsi=[];

%
%% Read txt exp. data
if par_set.flag_read_exp==1
    par_set.trail_1_25_01Hzpsi=low_level_exp_0_1(par_set.trail_1_25_01Hzpsi,1);
    par_set.trail_1_25_0125Hzpsi=low_level_exp_0_1(par_set.trail_1_25_0125Hzpsi,2);
    par_set.trail_1_25_025Hzpsi=low_level_exp_0_1(par_set.trail_1_25_025Hzpsi,3);
    par_set.trail_1_25_05Hzpsi=low_level_exp_0_1(par_set.trail_1_25_05Hzpsi,4);
    par_set.trail_1_25_1Hzpsi=low_level_exp_0_1(par_set.trail_1_25_1Hzpsi,5);
    par_set.trail_0_25_01Hzpsi=low_level_exp_0_1(par_set.trail_0_25_01Hzpsi,6);
    par_set.trail_0_25_0125Hzpsi=low_level_exp_0_1(par_set.trail_0_25_0125Hzpsi,7);
    par_set.trail_0_25_025Hzpsi=low_level_exp_0_1(par_set.trail_0_25_025Hzpsi,8);
    par_set.trail_0_25_05Hzpsi=low_level_exp_0_1(par_set.trail_0_25_05Hzpsi,9);
    par_set.trail_0_25_1Hzpsi=low_level_exp_0_1(par_set.trail_0_25_1Hzpsi,10);
    save('raw_data.mat','par_set');
    fprintf( 'Saved \n' )
else
    fprintf( 'Loading... \n' );
    load('raw_data.mat');
    fprintf( 'Data loaded \n' );
end

%% Plot time domain 
figure('Name','Time domain p track','Position',[400,200,600,800])
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];test_time=[];
data_set=par_set.trail_1_25_01Hzpsi;
test_time=data_set.pd_psi(:,1);
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);
subplot(5,1,1)
plot(test_time,test_input,'LineWidth',2,'Color','r')
hold on
plot(test_time,test_output,'LineWidth',2,'Color','b')
hold on
title(' 0.1Hz')
xlim([5,90])
xlabel('Time(s)')
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];test_time=[];
data_set=par_set.trail_1_25_0125Hzpsi;
test_time=data_set.pd_psi(:,1);
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);
subplot(5,1,2)
plot(test_time,test_input,'LineWidth',2,'Color','r')
hold on
plot(test_time,test_output,'LineWidth',2,'Color','b')
hold on
title(' 0.125Hz')
xlim([5,70])
xlabel('Time(s)')
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];test_time=[];
data_set=par_set.trail_1_25_025Hzpsi;
test_time=data_set.pd_psi(:,1);
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);
subplot(5,1,3)
plot(test_time,test_input,'LineWidth',2,'Color','r')
hold on
plot(test_time,test_output,'LineWidth',2,'Color','b')
hold on
title(' 0.25Hz')
xlim([5,35])
xlabel('Time(s)')
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];test_time=[];
data_set=par_set.trail_1_25_05Hzpsi;
test_time=data_set.pd_psi(:,1);
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);
subplot(5,1,4)
plot(test_time,test_input,'LineWidth',2,'Color','r')
hold on
plot(test_time,test_output,'LineWidth',2,'Color','b')
hold on
title(' 0.5Hz')
xlim([5,25])
xlabel('Time(s)')
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];test_time=[];
data_set=par_set.trail_1_25_1Hzpsi;
test_time=data_set.pd_psi(:,1);
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);
subplot(5,1,5)
plot(test_time,test_input,'LineWidth',2,'Color','r')
hold on
plot(test_time,test_output,'LineWidth',2,'Color','b')
hold on
title(' 1Hz')
xlim([5,15])
xlabel('Time(s)')
%% Plot Overlay Results
func_plot_low_level_overlayResult(par_set);
%% Estimate controller parameters d_pm=a * pm + b * pd
par_set=func_EstiamtePressCntrlParams_noplot(par_set);
%% Compare averaged model with different trails
par_set=func_CompareAveragedModel(par_set);
