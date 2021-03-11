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
par_set.flag_plot_movingCC = 0;
%flag for plotting fwd kinematic results
par_set.plot_fwdKinematic = 0;
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
%% data1
fp=figure('Name','ramp','Position',[100,100,600,800]);
testData=par_set.trial1;
testData = func_getPhiThetaBfromXYZ(testData,par_set);
% testData.dist_est_tau=[];
% testData.dist_th=0.8; % Nm
% testData.x1e_max_value=deg2rad(3);
% testData.x1e=[];
% testData.x1e=testData.xd_exp-testData.x1_exp;
% flag_first_contact=0;
% for i =1:length(testData.x1_exp)
%     theta=testData.x1_exp(i,2);
%     r0=testData.beta(i);
%     m0=par_set.m0;
%     L=par_set.L;
%     dist=testData.dist_est(i);
%     if theta==0
%         mx=m0*(L/2)^2;
%     else
%         Izz=m0*r0*r0;
%         mx =(Izz/4 + m0*((cos(theta/2)*(r0 - L/theta))/2 +...
%                 (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(r0 - L/theta)^2)/4);
%     end
%    testData.dist_est_tau(i,1)=mx*dist;
% 
% end
subplot(5,1,1)
plot(testData.xd_exp(:,1),testData.xd_exp(:,2),'r')
hold on
plot(testData.x1_exp(:,1),testData.x1_exp(:,2),'b')
hold on
plot(testData.x1_exp(:,1),testData.xdNew,'k')
hold on
plot(testData.x1_exp(:,1),-testData.ctrl_policy,'g')
hold on
%for i =1:length(testData.x1_exp)
%     if testData.contact_est(i,1) >0
%         plot(testData.x1_exp(i,1),-1,'MarkerSize',10)
%         hold on
%     end
% end
ylabel('\theta (rad)')
xlim([0,65])
% ylim([-1.1,0])
legend('x_d','x','Orientation','horizontal','Location','northeast')
title(['2 rad/s'])
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,2)
plot(testData.xd_exp(:,1),testData.xd_exp(:,2)-testData.x1_exp(:,2),'r')
xlim([0,65])
ylim([-0.1,0.1])
ylabel('Error (rad)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,3)
plot(testData.xd_exp(:,1),testData.pd_MPa(:,2),'b')
hold on
% plot(testData.xd_exp(:,1),testData.p1_ub_MPa,'r')
hold on
plot(testData.xd_exp(:,1),testData.pm_MPa(:,2),'k')
xlim([0,65])
ylim([0,0.3])
legend('p_b','pm','Orientation','horizontal','Location','northeast')
ylabel('Press. (MPa)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,4)
plot(testData.xd_exp(:,1),testData.u_total,'r')
hold on
plot(testData.xd_exp(:,1),testData.u_eq,'b')
hold on
plot(testData.xd_exp(:,1),testData.u_s,'k')
hold on
plot(testData.xd_exp(:,1),testData.u_n,'g')
legend('u_{total}','u_{eq}','u_s','u_n','Orientation','horizontal','Location','northeast')
xlim([0,65])
ylabel('Ctrl. Input(N\cdotm)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,5)
plot(testData.xd_exp(:,1),testData.dist_est_tau,'r')
hold on
plot(testData.xd_exp(:,1),testData.dist_est_inner_tau,'b')
xlim([0,65])
ylabel('Lumped Dist.(N\cdotm)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
%% data2
fp=figure('Name','ramp','Position',[100,100,600,800]);
testData=par_set.trial2;
testData = func_getPhiThetaBfromXYZ(testData,par_set);
% testData.dist_est_tau=[];
% for i =1:length(testData.x1_exp)
%     theta=testData.x1_exp(i,2);
%     r0=testData.beta(i);
%     m0=par_set.m0;
%     L=par_set.L;
%     dist=testData.dist_est(i);
%     if theta==0
%         mx=m0*(L/2)^2;
%     else
%         Izz=m0*r0*r0;
%         mx =(Izz/4 + m0*((cos(theta/2)*(r0 - L/theta))/2 +...
%                 (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(r0 - L/theta)^2)/4);
%     end
%    testData.dist_est_tau(i,1)=mx*dist;
% end
subplot(5,1,1)
plot(testData.xd_exp(:,1),testData.xd_exp(:,2),'r')
hold on
plot(testData.x1_exp(:,1),testData.x1_exp(:,2),'b')
hold on
plot(testData.x1_exp(:,1),testData.xdNew,'k')
hold on
plot(testData.x1_exp(:,1),-testData.ctrl_policy,'g')
hold on
ylabel('\theta (rad)')
xlim([0,65])
ylim([-1.1,0])
legend('x_d','x','Orientation','vertical','Location','northeast')
title(['5 rad/s'])
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,2)
plot(testData.xd_exp(:,1),testData.xd_exp(:,2)-testData.x1_exp(:,2),'r')
xlim([0,65])
ylim([-0.1,0.1])
ylabel('Error (rad)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,3)
plot(testData.xd_exp(:,1),testData.pd_MPa(:,2),'b')
hold on
% plot(testData.xd_exp(:,1),testData.p1_ub_MPa,'r')
hold on
plot(testData.xd_exp(:,1),testData.pm_MPa(:,2),'k')
xlim([0,65])
ylim([0,0.3])
legend('p_b','pm','Orientation','vertical','Location','northeast')
ylabel('Press. (MPa)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,4)
plot(testData.xd_exp(:,1),testData.u_total,'r')
hold on
plot(testData.xd_exp(:,1),testData.u_eq,'b')
hold on
plot(testData.xd_exp(:,1),testData.u_s,'k')
hold on
plot(testData.xd_exp(:,1),testData.u_n,'g')
legend('u_{total}','u_{eq}','u_s','u_n','Orientation','vertical','Location','northeast')
xlim([0,65])
ylabel('Ctrl. Input(N\cdotm)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,5)
plot(testData.xd_exp(:,1),testData.dist_est_tau,'r')
hold on
plot(testData.xd_exp(:,1),testData.dist_est_inner_tau,'b')
xlim([0,65])
ylabel('Lumped Dist.(N\cdotm)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
% return
%% data3
fp=figure('Name','ramp','Position',[100,100,600,800]);
testData=par_set.trial3;
testData = func_getPhiThetaBfromXYZ(testData,par_set);
% testData.dist_est_tau=[];
% for i =1:length(testData.x1_exp)
%     theta=testData.x1_exp(i,2);
%     r0=testData.beta(i);
%     m0=par_set.m0;
%     L=par_set.L;
%     dist=testData.dist_est(i);
%     if theta==0
%         mx=m0*(L/2)^2;
%     else
%         Izz=m0*r0*r0;
%         mx =(Izz/4 + m0*((cos(theta/2)*(r0 - L/theta))/2 +...
%                 (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(r0 - L/theta)^2)/4);
%     end
%    testData.dist_est_tau(i,1)=mx*dist;
% end
subplot(5,1,1)
plot(testData.xd_exp(:,1),testData.xd_exp(:,2),'r')
hold on
plot(testData.x1_exp(:,1),testData.x1_exp(:,2),'b')
hold on
plot(testData.x1_exp(:,1),testData.xdNew,'k')
hold on
plot(testData.x1_exp(:,1),-testData.ctrl_policy,'g')
hold on
ylabel('\theta (rad)')
xlim([0,65])
ylim([-1.1,0])
legend('x_d','x','Orientation','vertical','Location','northeastoutside')
title(['2 rad/s SMC'])
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,2)
plot(testData.xd_exp(:,1),testData.xd_exp(:,2)-testData.x1_exp(:,2),'r')
xlim([0,65])
ylim([-0.1,0.1])
ylabel('Error (rad)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,3)
plot(testData.xd_exp(:,1),testData.pd_MPa(:,2),'b')
hold on
% plot(testData.xd_exp(:,1),testData.p1_ub_MPa,'r')
hold on
plot(testData.xd_exp(:,1),testData.pm_MPa(:,2),'k')
xlim([0,65])
ylim([0,0.3])
legend('p_b','pm','Orientation','vertical','Location','northeastoutside')
ylabel('Press. (MPa)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,4)
plot(testData.xd_exp(:,1),testData.u_total,'r')
hold on
plot(testData.xd_exp(:,1),testData.u_eq,'b')
hold on
plot(testData.xd_exp(:,1),testData.u_s,'k')
hold on
plot(testData.xd_exp(:,1),testData.u_n,'g')
legend('u_{total}','u_{eq}','u_s','u_n','Orientation','vertical','Location','northeastoutside')
xlim([0,65])
ylabel('Ctrl. Input(N\cdotm)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,5)
plot(testData.xd_exp(:,1),testData.dist_est_tau,'r')
hold on
plot(testData.xd_exp(:,1),testData.dist_est_inner_tau,'b')
xlim([0,65])
ylabel('Lumped Dist.(N\cdotm)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
% return
%% data4
fp=figure('Name','ramp','Position',[100,100,600,800]);
testData=par_set.trial4;
testData = func_getPhiThetaBfromXYZ(testData,par_set);
% testData.dist_est_tau=[];
% for i =1:length(testData.x1_exp)
%     theta=testData.x1_exp(i,2);
%     r0=testData.beta(i);
%     m0=par_set.m0;
%     L=par_set.L;
%     dist=testData.dist_est(i);
%     if theta==0
%         mx=m0*(L/2)^2;
%     else
%         Izz=m0*r0*r0;
%         mx =(Izz/4 + m0*((cos(theta/2)*(r0 - L/theta))/2 +...
%                 (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(r0 - L/theta)^2)/4);
%     end
%    testData.dist_est_tau(i,1)=mx*dist;
% end
subplot(5,1,1)
plot(testData.xd_exp(:,1),testData.xd_exp(:,2),'r')
hold on
plot(testData.x1_exp(:,1),testData.x1_exp(:,2),'b')
hold on
plot(testData.x1_exp(:,1),testData.xdNew,'k')
hold on
plot(testData.x1_exp(:,1),-testData.ctrl_policy,'g')
hold on
ylabel('\theta (rad)')
xlim([0,65])
ylim([-1.1,0])
legend('x_d','x','Orientation','vertical','Location','northeastoutside')
title(['2 rad/s SMC'])
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,2)
plot(testData.xd_exp(:,1),testData.xd_exp(:,2)-testData.x1_exp(:,2),'r')
xlim([0,65])
ylim([-0.1,0.1])
ylabel('Error (rad)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,3)
plot(testData.xd_exp(:,1),testData.pd_MPa(:,2),'b')
hold on
% plot(testData.xd_exp(:,1),testData.p1_ub_MPa,'r')
hold on
plot(testData.xd_exp(:,1),testData.pm_MPa(:,2),'k')
xlim([0,65])
ylim([0,0.3])
legend('p_b','pm','Orientation','vertical','Location','northeastoutside')
ylabel('Press. (MPa)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,4)
plot(testData.xd_exp(:,1),testData.u_total,'r')
hold on
plot(testData.xd_exp(:,1),testData.u_eq,'b')
hold on
plot(testData.xd_exp(:,1),testData.u_s,'k')
hold on
plot(testData.xd_exp(:,1),testData.u_n,'g')
legend('u_{total}','u_{eq}','u_s','u_n','Orientation','vertical','Location','northeastoutside')
xlim([0,65])
ylabel('Ctrl. Input(N\cdotm)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,5)
plot(testData.xd_exp(:,1),testData.dist_est_tau,'r')
hold on
plot(testData.xd_exp(:,1),testData.dist_est_inner_tau,'b')
xlim([0,65])
ylabel('Lumped Dist.(N\cdotm)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
return
%% data5
fp=figure('Name','ramp','Position',[100,100,600,800]);
testData=par_set.trial5;
testData = func_getPhiThetaBfromXYZ(testData,par_set);
% testData.dist_est_tau=[];
% for i =1:length(testData.x1_exp)
%     theta=testData.x1_exp(i,2);
%     r0=testData.beta(i);
%     m0=par_set.m0;
%     L=par_set.L;
%     dist=testData.dist_est(i);
%     if theta==0
%         mx=m0*(L/2)^2;
%     else
%         Izz=m0*r0*r0;
%         mx =(Izz/4 + m0*((cos(theta/2)*(r0 - L/theta))/2 +...
%                 (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(r0 - L/theta)^2)/4);
%     end
%    testData.dist_est_tau(i,1)=mx*dist;
% end
subplot(5,1,1)
plot(testData.xd_exp(:,1),testData.xd_exp(:,2),'r')
hold on
plot(testData.x1_exp(:,1),testData.x1_exp(:,2),'b')
hold on
plot(testData.x1_exp(:,1),testData.xdNew,'k')
hold on
plot(testData.x1_exp(:,1),-testData.ctrl_policy,'g')
hold on
ylabel('\theta (rad)')
xlim([0,65])
ylim([-1.1,0])
legend('x_d','x','Orientation','vertical','Location','northeastoutside')
title(['2 rad/s SMC'])
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,2)
plot(testData.xd_exp(:,1),testData.xd_exp(:,2)-testData.x1_exp(:,2),'r')
xlim([0,65])
ylim([-0.1,0.1])
ylabel('Error (rad)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,3)
plot(testData.xd_exp(:,1),testData.pd_MPa(:,2),'b')
hold on
% plot(testData.xd_exp(:,1),testData.p1_ub_MPa,'r')
hold on
plot(testData.xd_exp(:,1),testData.pm_MPa(:,2),'k')
xlim([0,65])
ylim([0,0.3])
legend('p_b','pm','Orientation','vertical','Location','northeastoutside')
ylabel('Press. (MPa)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,4)
plot(testData.xd_exp(:,1),testData.u_total,'r')
hold on
plot(testData.xd_exp(:,1),testData.u_eq,'b')
hold on
plot(testData.xd_exp(:,1),testData.u_s,'k')
hold on
plot(testData.xd_exp(:,1),testData.u_n,'g')
legend('u_{total}','u_{eq}','u_s','u_n','Orientation','vertical','Location','northeastoutside')
xlim([0,65])
ylabel('Ctrl. Input(N\cdotm)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;
subplot(5,1,5)
plot(testData.xd_exp(:,1),testData.dist_est_tau,'r')
hold on
plot(testData.xd_exp(:,1),testData.dist_est_inner_tau,'b')
xlim([0,65])
ylabel('Lumped Dist.(N\cdotm)')
xlabel('Time (sec)')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;