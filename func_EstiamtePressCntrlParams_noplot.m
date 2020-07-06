function [par_set]=func_EstiamtePressCntrlParams_noplot(par_set)
%% d_pm=-a*pm+b*pd
a=1;b=1;
fcn_type='d';
Ts=0.05;
%%
plot_flag=1;
%%%%%%%%%%
data_set=[];test_input=[];test_output=[];
data_set=par_set.trail_0_25psi;
%%%%%%%%%%

test_output=data_set.pd_psi(:,2);
test_input=data_set.pm_psi(:,2)-data_set.pm_psi(end,2)+data_set.pd_psi(end,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
controller_model.Structure.Parameters(1).Minimum=0;
controller_model.Structure.Parameters(2).Minimum=0;
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = true;
controller_model = greyest(test_data,controller_model,opt);
if plot_flag==1
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,26])
end
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(2).Value];
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
test_input=data_set.pm_psi(:,2)-data_set.pm_psi(end,2)+data_set.pd_psi(end,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
controller_model.Structure.Parameters(1).Minimum=0;
controller_model.Structure.Parameters(2).Minimum=0;
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
if plot_flag==1
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,26])
end
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(2).Value];
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
test_input=data_set.pm_psi(:,2)-data_set.pm_psi(end,2)+data_set.pd_psi(end,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
controller_model.Structure.Parameters(1).Minimum=0;
controller_model.Structure.Parameters(2).Minimum=0;
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
if plot_flag==1
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,26])
end
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(2).Value];
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
test_input=data_set.pm_psi(:,2)-data_set.pm_psi(end,2)+data_set.pd_psi(end,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
controller_model.Structure.Parameters(1).Minimum=0;
controller_model.Structure.Parameters(2).Minimum=0;
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
if plot_flag==1
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,26])
end
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(2).Value];
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
test_input=data_set.pm_psi(:,2)-data_set.pm_psi(end,2)+data_set.pd_psi(end,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
controller_model.Structure.Parameters(1).Minimum=0;
controller_model.Structure.Parameters(2).Minimum=0;
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
if plot_flag==1
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,26])
end
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(2).Value];
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
test_input=data_set.pm_psi(:,2)-data_set.pm_psi(end,2)+data_set.pd_psi(end,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
controller_model.Structure.Parameters(1).Minimum=0;
controller_model.Structure.Parameters(2).Minimum=0;
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
if plot_flag==1
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,26])
end
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(2).Value];
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
test_input=data_set.pm_psi(:,2)-data_set.pm_psi(end,2)+data_set.pd_psi(end,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
controller_model.Structure.Parameters(1).Minimum=0;
controller_model.Structure.Parameters(2).Minimum=0;
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
if plot_flag==1
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,26])
end
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(2).Value];
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
test_input=data_set.pm_psi(:,2)-data_set.pm_psi(end,2)+data_set.pd_psi(end,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
controller_model.Structure.Parameters(1).Minimum=0;
controller_model.Structure.Parameters(2).Minimum=0;
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
if plot_flag==1
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,26])
end
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(2).Value];
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
test_input=data_set.pm_psi(:,2)-data_set.pm_psi(end,2)+data_set.pd_psi(end,2);

test_data=iddata([test_input],[test_output],Ts);
test_data.OutputName='Pressure';
test_data.OutputUnit='psi';
test_data.Tstart = 0;
test_data.TimeUnit = 's';
controller_model=idgrey('func_pressrueController',{a,b},'d');
controller_model.Structure.Parameters(1).Minimum=0;
controller_model.Structure.Parameters(2).Minimum=0;
opt = greyestOptions('InitialState','estimate','Display','off');
opt.EnforceStability = false;
controller_model = greyest(test_data,controller_model,opt);
if plot_flag==1
figure('Position',[600,600,600,400])
compare(test_data,controller_model)
ylim([0,26])
end
data_set.pressCntrl=[controller_model.Structure.Parameters(1).Value,controller_model.Structure.Parameters(2).Value];
%%%%%%%%
par_set.trail_20_25psi=data_set;
%%%%%%%%%
%% Display a and b
if plot_flag==1
para=[];
para=[par_set.trail_0_25psi.pressCntrl;
    par_set.trail_0_20psi.pressCntrl;
    par_set.trail_0_15psi.pressCntrl;
    par_set.trail_0_10psi.pressCntrl;
    par_set.trail_0_5psi.pressCntrl;
    par_set.trail_5_25psi.pressCntrl;
    par_set.trail_10_25psi.pressCntrl;
    par_set.trail_15_25psi.pressCntrl;
    par_set.trail_20_25psi.pressCntrl;];
num_set=linspace(1,9,9);
figure('Position',[600,600,600,400])
subplot(2,1,1)
scatter(num_set,para(:,1))
legend('a')
subplot(2,1,2)
scatter(num_set,para(:,2))
legend('b')
xlabel('Index (N)')
end
end