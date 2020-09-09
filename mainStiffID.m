%% Main function for stiffness ID use data 0722
clear all
close all
clc
%% Initialize the system
par_set=[];
%flag for EOM deriviation
par_set.EOM=0;
%flag for plot
par_set.flag_plot_rawData = 0;
%flag for read txt file or mat file 1: txt 0: mat
par_set.flag_read_exp = 1;
%flag for plotting moving constant layer
par_set.flag_plot_movingCC =0;
%flag for plotting fwd kinematic results
par_set.plot_fwdKinematic =0;
% Check data readme.txt for detail input reference
par_set.trial1=[];
par_set.trial2=[];
par_set.trial3=[];
par_set.trial4=[];
par_set.trial5=[];


% Geometric para.
par_set.trianlge_length=70*1e-03;% fabric triangle edge length
par_set.L=0.19;%actuator length
par_set.n=4;% # of joints for augmented rigid arm
par_set.m0=0.35;%kg segment weight
par_set.g=9.8;%% gravity constant
par_set.a0=15*1e-03;%% 1/2 of pillow width
par_set.r_f=sqrt(3)/6*par_set.trianlge_length+par_set.a0; % we assume the force are evenly spread on a cirlce with radius of r_f
%% Update location of 3 chambers P1, P2, P3
par_set.p1_angle=-150;%deg p1 position w/ the base frame
% update force position of p1 p2 and p3
for i =1:3
    par_set.r_p{i}=[par_set.r_f*cosd(par_set.p1_angle+120*(i-1)),par_set.r_f*sind(par_set.p1_angle+120*(i-1)),0].';
%     par_set.f_p{i}=588.31*par_set.pm_MPa(:,i+1);
end
fprintf('System initialization done \n')
%% Read txt file or mat file
if par_set.flag_read_exp==1

%     par_set.trial_4_25psi=func_high_level_exp(par_set.trial_4_25psi,10);
%     par_set.trial_3_25psi=func_high_level_exp(par_set.trial_3_25psi,9);
%     par_set.trial_2_25psi=func_high_level_exp(par_set.trial_2_25psi,8);
%     par_set.trial_1_25psi=func_high_level_exp(par_set.trial_1_25psi,7);
%     par_set.trial_0_25psi=func_high_level_exp(par_set.trial_0_25psi,6);
    
    
    par_set.trial1=func_high_level_exp(par_set.trial1,1);
    par_set.trial2=func_high_level_exp(par_set.trial2,2);
    par_set.trial3=func_high_level_exp(par_set.trial3,3);
    par_set.trial4=func_high_level_exp(par_set.trial4,4);
    par_set.trial5=func_high_level_exp(par_set.trial5,5);
    
    save('raw_id_data.mat','par_set');
    fprintf( 'Saved \n' )
else
    fprintf( 'Loading... \n' );
    load('raw_id_data.mat');
    fprintf( 'Data loaded \n' );
end
%% Symbolic EOM
if par_set.EOM==1
par_set=func_EOM_baseFrame(par_set);
end
%% Grey-box system ID
testData=[];
testData=par_set.trial1;
testData=funcGreyBoxSysID(testData,par_set);
testData=func_greyBox(testData);
%%

