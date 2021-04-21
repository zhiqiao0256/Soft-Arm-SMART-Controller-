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
par_set.plot_fwdKinematic = 0;
%flag for using fixed beta value
par_set.flag_fixed_beta =0;
% Check data readme.txt for detail input reference
par_set.Ts=1/40;
% Geometric para.
par_set.trianlge_length=70*1e-03;% fabric triangle edge length
par_set.L=0.175;%actuator length
par_set.n=4;% # of joints for augmented rigid arm
par_set.m0=0.35;%kg segment weight
par_set.g=9.8;%% gravity constant
par_set.a0=15*1e-03;%% 1/2 of pillow width
par_set.r_f=sqrt(3)/6*par_set.trianlge_length+par_set.a0; % we assume the force are evenly spread on a cirlce with radius of r_f
par_set.fixed_beta=par_set.r_f; %% Change this value as needed
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
%     par_set=funcHighLevelExpPositionTracking(par_set,2);
%     par_set=funcHighLevelExpPositionTracking(par_set,3);
%     par_set=funcHighLevelExpPositionTracking(par_set,4);
%     par_set=funcHighLevelExpPositionTracking(par_set,5);
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
%% Calculate RMSE and Energy of Pm
testData= par_set.trial1;
s_pt=1;e_pt=length(testData.xd_exp(:,2));
close all
% testData = funcPostProcess(testData,s_pt,e_pt);
% fp=figure('Name','ramp','Position',[100,100,600,800]);
testData = funcGetPhiThetaRifromXYZ(testData,par_set);
testData = funcFwdKinematic5link(testData,par_set);
%%
% testData= par_set.trial2;
% testData = funcGetPhiThetaRifromXYZ(testData,par_set);
testData = funcFwdKinematic5link(testData,par_set);