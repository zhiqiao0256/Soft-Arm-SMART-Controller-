load('greyMPa1001_40Hz.mat');
% %%
% flag_input_bound=1; % 0 for unbound control signal; 1 for bounded control signal with p1=40 psi p2=p3=1 psi
% % No distrubance No Uncertanties
% par_set=funcSimSMCSPO_noDistandUncert(par_set,flag_input_bound);
%%
flag_input_bound=0; % 0 for unbound control signal; 1 for bounded control signal with p1=40 psi p2=p3=1 psi
% No distrubance No Uncertanties
par_set=funcSimSMCSPO_noUncert(par_set,flag_input_bound);
