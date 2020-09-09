function test_data =func_greyBox(test_data)
%%
% test_data=par_set.trial_25_0psi.trainSet;
z=iddata([test_data.theta_rad,test_data.velocity_theta_rad],...
    [test_data.pm_psi(:,2:4),test_data.beta,test_data.phi_rad],0.05);
set(z, 'InputName', {'Pm1','Pm2','Pm3','r_0','Phi'}, ...
            'InputUnit', {'psi','psi','psi','m','rad'},               ...
          'OutputName', {'Angular position','vel'}, ...
          'OutputUnit', {'rad','rad/s'},                         ...
          'TimeUnit', 's');
% test_tspan=test_data.pd_psi(:,1);
test_x=[test_data.theta_rad,test_data.velocity_theta_rad]';
% test_u=test_data.pd_psi(:,2:4)';
% test_b0=test_data.beta;
% test_phi=test_data.phi_rad;
% test_piSet=test_data.pi_set;
test_x0=test_x(:,1);
 %%
FileName      = 'func_greyModel';       % File describing the model structure.
Order         = [2 5 2];           % Model orders [ny nu nx].
Parameters    = [1; 0.1;0.1];         % Initial parameters. Np = 2.
InitialStates = test_x0;            % Initial initial states.
Ts            = 0;                 % Time-continuous system.
nlgr = idnlgrey(FileName, Order, Parameters, InitialStates, Ts, ...
                'Name', 'Arm');
            %%
set(nlgr, 'InputName', {'Pm1','Pm2','Pm3','r_0','Phi'}, ...
            'InputUnit', {'psi','psi','psi','m','rad'},               ...
          'OutputName', {'Angular position','vel'}, ...
          'OutputUnit', {'rad','rad/s'},                         ...
          'TimeUnit', 's');
      %%
      fprintf('Estimating')
% opt = nlgreyestOptions('Display','off');
nlgreyModel = nlgreyest(z,nlgr);
%%
figure
compare(z,nlgreyModel)
figure
pe(z, nlgreyModel);
test_data.pi_grey=[nlgreyModel.Parameters(1).Value,nlgreyModel.Parameters(2).Value,nlgreyModel.Parameters(3).Value];
fprintf('Estimated [alpha,k,d] is [%.4f,%.4f,%.4f] \n',test_data.pi_grey(1),test_data.pi_grey(2),test_data.pi_grey(3))
