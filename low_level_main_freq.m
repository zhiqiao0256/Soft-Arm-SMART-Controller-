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
% xlim([5,90])
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
% xlim([5,70])
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
% xlim([5,35])
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
% xlim([5,25])
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
% xlim([5,15])
xlabel('Time(s)')
%% Validate averaged model with different freq.
par_set.mean_a=0.9297; 
par_set.mean_b=0.0685;
fprintf('Averaged model a is %f, b is %f',par_set.mean_a,par_set.mean_b)
averaged_model=idgrey('func_pressrueController',{par_set.mean_a,par_set.mean_b},'d');
Ts=0.05;
%%
figure('Position',[600,200,600,800])
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_0_25_01Hzpsi;
%%%%%%%%%%
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';

s(1)=subplot(5,1,1);
compare(test_data,averaged_model)
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
hold on
legend('0.1Hz','Avg. model','Orientation','vertical','Location','eastoutside')

%%%%%%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_0_25_0125Hzpsi;
%%%%%%%%%%
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';

s(2)=subplot(5,1,2);
compare(test_data,averaged_model)
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
hold on
legend('0.125Hz','Avg. model','Orientation','vertical','Location','eastoutside')
%%%%%%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_0_25_025Hzpsi;
%%%%%%%%%%
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';

s(3)=subplot(5,1,3);
compare(test_data,averaged_model)
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
hold on
legend('0.25Hz','Avg. model','Orientation','vertical','Location','eastoutside')

%%%%%%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_0_25_05Hzpsi;
%%%%%%%%%%
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';

s(4)=subplot(5,1,4);
compare(test_data,averaged_model)
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
hold on
legend('0.5Hz','Avg. model','Orientation','vertical','Location','eastoutside')

%%%%%%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_0_25_1Hzpsi;
%%%%%%%%%%
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';

s(5)=subplot(5,1,5);
compare(test_data,averaged_model)
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
hold on
legend('1Hz','Avg. model','Orientation','vertical','Location','eastoutside')
hold on
%%

figure('Position',[600,200,600,800])
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_1_25_01Hzpsi;
%%%%%%%%%%
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';

s(1)=subplot(5,1,1);
compare(test_data,averaged_model)
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
hold on
legend('0.1Hz','Avg. model','Orientation','vertical','Location','eastoutside')

%%%%%%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_1_25_0125Hzpsi;
%%%%%%%%%%
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';

s(2)=subplot(5,1,2);
compare(test_data,averaged_model)
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
hold on
legend('0.125Hz','Avg. model','Orientation','vertical','Location','eastoutside')
%%%%%%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_1_25_025Hzpsi;
%%%%%%%%%%
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';

s(3)=subplot(5,1,3);
compare(test_data,averaged_model)
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
hold on
legend('0.25Hz','Avg. model','Orientation','vertical','Location','eastoutside')

%%%%%%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_1_25_05Hzpsi;
%%%%%%%%%%
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';

s(4)=subplot(5,1,4);
compare(test_data,averaged_model)
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
hold on
legend('0.5Hz','Avg. model','Orientation','vertical','Location','eastoutside')

%%%%%%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_1_25_1Hzpsi;
%%%%%%%%%%
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';

s(5)=subplot(5,1,5);
compare(test_data,averaged_model)
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
hold on
legend('1Hz','Avg. model','Orientation','vertical','Location','eastoutside')
hold on
%%
workset=[];
workset=par_set.trail_1_25_01Hzpsi;
time_vec=[];
time_vec=workset.pd_psi(:,1);
[value,pos_inf]=findpeaks(workset.pd_psi(:,2));

[value,pos_def]=findpeaks(-workset.pd_psi(:,2));
% Segment inflation process
for index_num=1:size(pos_def,1)
    workset.inf_pd_psi{index_num}=workset.pd_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pd_psi{index_num}=workset.pd_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pm_psi{index_num}=workset.pm_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pm_psi{index_num}=workset.pm_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pe_psi{index_num}=workset.inf_pd_psi{index_num}-workset.inf_pm_psi{index_num};
    workset.inf_pe_psi{index_num}(:,1)=workset.inf_pm_psi{index_num}(:,1);
    workset.def_pe_psi{index_num}=workset.def_pd_psi{index_num}-workset.def_pm_psi{index_num};
    workset.def_pe_psi{index_num}(:,1)=workset.def_pm_psi{index_num}(:,1);
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.def_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];% 5-pt average
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.inf_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];
end
%
par_set.trail_1_25_01Hzpsi=workset;
%
%%
workset=[];
workset=par_set.trail_1_25_01Hzpsi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','r','LineWidth',2,'LineStyle','--')
    hold on
end
xlabel('Index(N)')
xlim([0 10])
ylabel('Chamber Pressure(psi)')
legend('p_{ref}','p_m','Location','northeast')