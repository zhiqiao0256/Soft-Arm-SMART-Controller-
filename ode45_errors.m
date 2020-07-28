load('update_0728.mat');
test_data=par_set.trial_25_0psi.trainSet;
test_tspan=test_data.pd_psi(:,1);
test_x=[test_data.theta_rad,test_data.velocity_theta_rad]';
test_u=test_data.pd_psi(:,2:4)';
test_b0=test_data.beta;
test_phi=test_data.phi_rad;
test_piSet=test_data.pi_set;
test_x0=test_x(:,1);
[t,x]=ode45(@(t,x) func_ode(t,x,test_u,test_tspan,test_b0,test_phi,test_piSet),test_tspan,test_x0);
figure
plot(t,x(:,1))
hold on
plot(t,test_x(1,:))
legend('ode45','exp.')
xlabel('time s')
ylabel('\theta rad')