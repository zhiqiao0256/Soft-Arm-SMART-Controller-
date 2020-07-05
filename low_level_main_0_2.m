%%% main function for low level dyn.  use data 0702%%%
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
par_set.trail_0_25psi=[];
par_set.trail_0_20psi=[];
par_set.trail_0_15psi=[];
par_set.trail_0_10psi=[];
par_set.trail_0_5psi=[];
par_set.trail_5_25psi=[];
par_set.trail_10_25psi=[];
par_set.trail_15_25psi=[];
par_set.trail_20_25psi=[];
%
%% Read txt exp. data
if par_set.flag_read_exp==1
    par_set.trail_0_25psi=low_level_exp_0_1(par_set.trail_0_25psi,1);
    par_set.trail_0_20psi=low_level_exp_0_1(par_set.trail_0_20psi,2);
    par_set.trail_0_15psi=low_level_exp_0_1(par_set.trail_0_15psi,3);
    par_set.trail_0_10psi=low_level_exp_0_1(par_set.trail_0_10psi,4);
    par_set.trail_0_5psi=low_level_exp_0_1(par_set.trail_0_5psi,5);
    par_set.trail_5_25psi=low_level_exp_0_1(par_set.trail_5_25psi,6);
    par_set.trail_10_25psi=low_level_exp_0_1(par_set.trail_10_25psi,7);
    par_set.trail_15_25psi=low_level_exp_0_1(par_set.trail_15_25psi,8);
    par_set.trail_20_25psi=low_level_exp_0_1(par_set.trail_20_25psi,9);
    save('raw_data.mat','par_set');
    fprintf( 'Saved \n' )
else
    fprintf( 'Loading... \n' );
    load('raw_data.mat');
    fprintf( 'Data loaded \n' );
end

%% Calculate dot_pm, segment inflation and deflation process
par_set=func_low_level_full_set(par_set);
%% Plot Overlay Results
% func_plot_low_level_overlayResult(par_set);
%% Estimate controller parameters d_pm=-a * pm + b * pd
par_set=func_EstiamtePressCntrlParams_noplot(par_set);
%% Compare averaged model with different trails
% par_set=func_CompareAveragedModel(par_set);
