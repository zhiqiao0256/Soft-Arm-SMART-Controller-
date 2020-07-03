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
par_set.trail25psi=[];
par_set.trail20psi=[];
par_set.trail15psi=[];
par_set.trail10psi=[];
par_set.trail5psi=[];
%
%% Read txt exp. data
if par_set.flag_read_exp==1
    par_set.trail25psi=low_level_exp_0_1(par_set.trail25psi,1);
    par_set.trail20psi=low_level_exp_0_1(par_set.trail20psi,2);
    par_set.trail15psi=low_level_exp_0_1(par_set.trail15psi,3);
    par_set.trail10psi=low_level_exp_0_1(par_set.trail10psi,4);
    par_set.trail5psi=low_level_exp_0_1(par_set.trail5psi,5);
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
func_plot_low_level_overlayResult(par_set);