%% Main function for stiffness ID use data 0722
%%% Major chanages:
%%%
clear all
close all
clc
%% Initialize the system
par_set=[];
%flag for EOM deriviation
par_set.EOM=0;
%flag for plot
par_set.flag_plot_rawData =0;
%flag for read txt file or mat file 1: txt 0: mat
par_set.flag_read_exp = 1;
%flag for plotting moving constant layer
par_set.flag_plot_movingCC = 1;
%flag for plotting fwd kinematic results
par_set.plot_fwdKinematic = 1;
% Check data readme.txt for detail input reference
par_set.Ts=1/40;
% Geometric para.
par_set.trianlge_length=70*1e-03;% fabric triangle edge length
par_set.L=0.185;%actuator length
par_set.n=4;% # of joints for augmented rigid arm
par_set.m0=0.35;%kg segment weight
par_set.g=9.8;%% gravity constant
par_set.a0=15*1e-03;%% 1/2 of pillow width
par_set.r_f=sqrt(3)/6*par_set.trianlge_length+par_set.a0; % we assume the force are evenly spread on a cirlce with radius of r_f
%% Update location of 3 chambers P1, P2, P3
par_set.p1_angle=150;%deg p1 position w/ the base frame
% update force position of p1 p2 and p3
for i =1:3
    par_set.r_p{i}=[par_set.r_f*cosd(par_set.p1_angle+120*(i-1)),par_set.r_f*sind(par_set.p1_angle+120*(i-1)),0].';
%     par_set.f_p{i}=588.31*par_set.pm_MPa(:,i+1);
end
fprintf('System initialization done \n')
%% Read txt file or mat file
if par_set.flag_read_exp==1
    par_set=funcHighLevelExpPositionTracking(par_set,1);
    par_set=funcHighLevelExpPositionTracking(par_set,2);
    par_set=funcHighLevelExpPositionTracking(par_set,3);
    par_set=funcHighLevelExpPositionTracking(par_set,4);
    par_set=funcHighLevelExpPositionTracking(par_set,5);
%     par_set=funcHighLevelExpPositionTracking(par_set,6);
%     par_set=funcHighLevelExpPositionTracking(par_set,7);
%     par_set=funcHighLevelExpPositionTracking(par_set,8);
    save('raw_id_data.mat','par_set');
    fprintf( 'Saved \n' )
else
    fprintf( 'Loading... \n' );
    load('raw_id_data.mat');
    fprintf( 'Data loaded \n' );
end
%% Segment data1 
% close all
testData= par_set.trial1;
fp=figure('Name','ramp','Position',[100,100,600,800]);
plot(testData.xd_exp(:,2))
s_pt=403;e_pt=2403;
fp=figure('Name','fig1','Position',[100,100,800,600]);
subplot(2,1,1)
plot(testData.xd_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.xd_exp(s_pt:e_pt,2),'r','LineStyle','-','LineWidth',2)
hold on
plot(testData.x1_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.x1_exp(s_pt:e_pt,2),'b','LineStyle','-.','LineWidth',2)
hold on
plot(testData.x1_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.xdNew(s_pt:e_pt),'k','LineStyle',':','LineWidth',2)
ylabel('Angle (rad)')
xlim([0,50])
ylim([-0.9,-0.1])
legend('\theta_d','\theta','\theta_a','Orientation','horizontal','Location','north')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=20;
subplot(2,1,2)
plot(testData.x1_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.dist_est_inner_tau(s_pt:e_pt),'r','LineWidth',2)
legend('$\hat{\Delta}$','Interpreter','latex','Orientation','horizontal','Location','northeast')
ylabel('Disturbance (Nm)')
xlabel('Time (second)')
ylim([-0.2,2])
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=20;
testData = funcPostProcess(testData,s_pt,e_pt);
return
%% Segment data4 smcndob
% close all
testData= par_set.trial4;
fp=figure('Name','ramp','Position',[100,100,600,800]);
plot(testData.xd_exp(:,2))
s_pt=358;e_pt=2357;
fp=figure('Name','fig1','Position',[100,100,800,600]);
subplot(2,1,1)
plot(testData.xd_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.xd_exp(s_pt:e_pt,2),'r','LineStyle','-','LineWidth',2)
hold on
plot(testData.x1_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.x1_exp(s_pt:e_pt,2),'b','LineStyle','-.','LineWidth',2)
hold on
plot(testData.x1_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.xdNew(s_pt:e_pt),'k','LineStyle',':','LineWidth',2)
ylabel('Angle (rad)')
xlim([0,50])
ylim([-0.9,-0.1])
legend('\theta_d','\theta','\theta_a','Orientation','horizontal','Location','north')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(2,1,2)
plot(testData.x1_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.dist_est_tau(s_pt:e_pt),'r','LineWidth',2)
legend('\Delta','Orientation','horizontal','Location','northeast')
ylabel('Disturbance (Nm)')
xlabel('Time (second)')
ylim([-0.2,2])
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
testData = funcPostProcess(testData,s_pt,e_pt);
%% segment data 5 smcndob with switch
testData= par_set.trial5;
fp=figure('Name','ramp','Position',[100,100,600,800]);
plot(testData.xd_exp(:,2))
s_pt=380;e_pt=2379;
fp=figure('Name','fig1','Position',[100,100,800,600]);
subplot(2,1,1)
plot(testData.xd_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.xd_exp(s_pt:e_pt,2),'r','LineStyle','-','LineWidth',2)
hold on
plot(testData.x1_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.x1_exp(s_pt:e_pt,2),'b','LineStyle','-.','LineWidth',2)
hold on
plot(testData.x1_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.xdNew(s_pt:e_pt),'k','LineStyle',':','LineWidth',2)
ylabel('Angle (rad)')
xlim([0,50])
ylim([-0.9,-0.1])
legend('\theta_d','\theta','\theta_a','Orientation','horizontal','Location','north')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(2,1,2)
plot(testData.x1_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.dist_est_inner_tau(s_pt:e_pt),'r','LineWidth',2)
legend('\Delta','Orientation','horizontal','Location','northeast')
ylabel('Disturbance (Nm)')
xlabel('Time (second)')
ylim([-0.2,2])
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
testData = funcPostProcess(testData,s_pt,e_pt);
