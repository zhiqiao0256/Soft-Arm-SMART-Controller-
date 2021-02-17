load('greyMPa1001_40Hz.mat');
% %%
% flag_input_bound=1; % 0 for unbound control signal; 1 for bounded control signal with p1=40 psi p2=p3=1 psi
% % No distrubance No Uncertanties
% par_set=funcSimSMCSPO_noDistandUncert(par_set,flag_input_bound);
%%
par_set=funcSimSMC_inputUncertain_saturation(par_set);
%%
 par_set=funcSimSMC_inputUncertain(par_set)
%%
flag_input_bound=0; % 0 for unbound control signal; 1 for bounded control signal with p1=40 psi p2=p3=1 psi
% No distrubance No Uncertanties
par_set=funcSimSMCSPO_noUncert(par_set,flag_input_bound);
%%
flag_input_bound=0; % 0 for unbound control signal; 1 for bounded control signal with p1=40 psi p2=p3=1 psi
% No distrubance No Uncertanties
par_set=funcSimSMCSPO_lowerDyn(par_set,flag_input_bound);

%%
par_set=funcSimDOB(par_set);
%%
par_set=funcSimDOBx1disturb(par_set);
%% Matched distrubance
par_set=funcSimDOBmatchDist(par_set);
%% Matched distrubance with reaching law eta*sat(sig)+smc_k*sig
par_set=funcSimDOBmatchDistV2(par_set);
%% Matched distrubance with reaching law eta*sat(sig)+smc_k*sig and fit to acutate exp. setup
par_set=funcSimDOBmatchDistV3(par_set);
%% low level dyn.
low_beta_1=-1.459;
low_beta_2=1.421;
Ts=0.01; % sampling period
timeArray=[0:Ts:10]';%sec
u_raw=zeros(length(timeArray),1)+10*0.00689476;
p1_t=zeros(length(timeArray),1)
for i=1:length(timeArray)-1
    d_p1_t=low_beta_1*p1_t(i,1)+ low_beta_2*u_raw(i,1);
    p1_t(i+1,1)=p1_t(i,1)+d_p1_t*Ts;
end
    plot(timeArray,p1_t)