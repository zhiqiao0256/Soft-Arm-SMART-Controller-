function [par_set]=func_EstiamtePressCntrlParams(par_set)
%% d_pm=a*pm+b*pd
a=1;b=1;
fcn_type='d';
Ts=0.05;
%%

%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_0_25psi;
%%%%%%%%%%

test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,25])
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(1).Value];
%%%%%%%%
par_set.trail_0_25psi=data_set;
%%%%%%%%%
%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_0_20psi;
%%%%%%%%%%
% data_set=[];test_input=[];test_output=[];
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,25])
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(1).Value];
%%%%%%%%
par_set.trail_0_20psi=data_set;
%%%%%%%%%
%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_0_15psi;
%%%%%%%%%%
% data_set=[];test_input=[];test_output=[];
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,25])
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(1).Value];
%%%%%%%%
par_set.trail_0_15psi=data_set;
%%%%%%%%%
%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_0_10psi;
%%%%%%%%%%
% data_set=[];test_input=[];test_output=[];
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,25])
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(1).Value];
%%%%%%%%
par_set.trail_0_10psi=data_set;
%%%%%%%%%
%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_0_5psi;
%%%%%%%%%%
% data_set=[];test_input=[];test_output=[];
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,25])
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(1).Value];
%%%%%%%%
par_set.trail_0_5psi=data_set;
%%%%%%%%%
%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_5_25psi;
%%%%%%%%%%
% data_set=[];test_input=[];test_output=[];
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,25])
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(1).Value];
%%%%%%%%
par_set.trail_5_25psi=data_set;
%%%%%%%%%
%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_10_25psi;
%%%%%%%%%%
% data_set=[];test_input=[];test_output=[];
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,25])
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(1).Value];
%%%%%%%%
par_set.trail_10_25psi=data_set;
%%%%%%%%%
%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_15_25psi;
%%%%%%%%%%
% data_set=[];test_input=[];test_output=[];
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,25])
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(1).Value];
%%%%%%%%
par_set.trail_15_25psi=data_set;
%%%%%%%%%
%%
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_20_25psi;
%%%%%%%%%%
% data_set=[];test_input=[];test_output=[];
test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,25])
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(1).Value];
%%%%%%%%
par_set.trail_20_25psi=data_set;
%%%%%%%%%
end