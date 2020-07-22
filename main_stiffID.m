%% Main function for stiffness ID use data 0714
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
% p1 < p2,3
par_set.trial_5_25psi=[];
par_set.trial_3_25psi=[];
par_set.trial_2_25psi=[];
par_set.trial_1_25psi=[];
% p1 > p2,3
par_set.trial_25_0psi=[];
par_set.trial_25_1psi=[];
par_set.trial_25_2psi=[];
par_set.trial_25_3psi=[];
par_set.trial_25_4psi=[];
par_set.trial_25_5psi=[];

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
    par_set.trial_3_25psi=func_high_level_exp(par_set.trial_3_25psi,4);
    par_set.trial_2_25psi=func_high_level_exp(par_set.trial_2_25psi,5);
    par_set.trial_1_25psi=func_high_level_exp(par_set.trial_1_25psi,6);
    
    par_set.trial_25_5psi=func_high_level_exp(par_set.trial_25_5psi,8);
    par_set.trial_25_4psi=func_high_level_exp(par_set.trial_25_4psi,9);
    par_set.trial_25_3psi=func_high_level_exp(par_set.trial_25_3psi,3);
    par_set.trial_25_2psi=func_high_level_exp(par_set.trial_25_2psi,2);
    par_set.trial_25_1psi=func_high_level_exp(par_set.trial_25_1psi,1);
    
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
%% system ID sets
par_set.trial_1_25psi=func_sysID(par_set.trial_1_25psi,par_set);
par_set.trial_2_25psi=func_sysID(par_set.trial_2_25psi,par_set);
par_set.trial_3_25psi=func_sysID(par_set.trial_3_25psi,par_set);
%
par_set.trial_25_1psi=func_sysID(par_set.trial_25_1psi,par_set);
par_set.trial_25_2psi=func_sysID(par_set.trial_25_2psi,par_set);
par_set.trial_25_3psi=func_sysID(par_set.trial_25_3psi,par_set);
par_set.trial_25_4psi=func_sysID(par_set.trial_25_4psi,par_set);
par_set.trial_25_5psi=func_sysID(par_set.trial_25_5psi,par_set);
%%
figure
xx_posi=[1,2,3]';
xx_neg=[-1,-2,-3,-4,-5]';
alpha_neg=[par_set.trial_25_1psi.trainSet.pi_set(1);par_set.trial_25_2psi.trainSet.pi_set(1);par_set.trial_25_3psi.trainSet.pi_set(1);par_set.trial_25_4psi.trainSet.pi_set(1);par_set.trial_25_5psi.trainSet.pi_set(1)];
alpha_posi=[par_set.trial_1_25psi.trainSet.pi_set(1);par_set.trial_2_25psi.trainSet.pi_set(1);par_set.trial_3_25psi.trainSet.pi_set(1);];

k_neg=[par_set.trial_25_1psi.trainSet.pi_set(2);par_set.trial_25_2psi.trainSet.pi_set(2);par_set.trial_25_3psi.trainSet.pi_set(2);par_set.trial_25_4psi.trainSet.pi_set(2);par_set.trial_25_5psi.trainSet.pi_set(2)];
k_posi=[par_set.trial_1_25psi.trainSet.pi_set(2);par_set.trial_2_25psi.trainSet.pi_set(2);par_set.trial_3_25psi.trainSet.pi_set(2);];

b_neg=[par_set.trial_25_1psi.trainSet.pi_set(3);par_set.trial_25_2psi.trainSet.pi_set(3);par_set.trial_25_3psi.trainSet.pi_set(3);par_set.trial_25_4psi.trainSet.pi_set(3);par_set.trial_25_5psi.trainSet.pi_set(3)];
b_posi=[par_set.trial_1_25psi.trainSet.pi_set(3);par_set.trial_2_25psi.trainSet.pi_set(3);par_set.trial_3_25psi.trainSet.pi_set(3);];

subplot(3,1,1)
scatter(-xx_neg,alpha_neg)
title('p_1\in[0,25]psi, p_{2,3}\in[1-5]psi')
ylabel('\alpha')
hold on

subplot(3,1,2)
scatter(-xx_neg,k_neg)
ylabel('k')
hold on

subplot(3,1,3)
scatter(-xx_neg,b_neg)
ylabel('b')
xlabel('p_{2,3} pd')
hold on

figure
subplot(3,1,1)
scatter(xx_posi,alpha_posi)
title('p_{2,3}\in[0,25]psi, p_1\in[1-3]psi')
ylabel('\alpha')
hold on

subplot(3,1,2)
scatter(xx_posi,k_posi)
ylabel('k')
hold on

subplot(3,1,3)
scatter(xx_posi,b_posi)
ylabel('b')
xlabel('p_1 pd')
hold on