function trainSet= func_lestSquareWith5ptFilter(trainSet,par_set)
%% Getting velocity and acceleration
% 5 sample moving average method is used
windowSize = 5; 
filter_b = (1/windowSize)*ones(1,windowSize);
filter_a = 1;
trainSet.velocity_phi_rad=zeros(length(trainSet.phi_rad),1);
trainSet.velocity_phi_rad(2:end)=filter(filter_b,filter_a,(trainSet.phi_rad(2:end)-trainSet.phi_rad(1:end-1))/(1/20));
trainSet.acc_phi_rad=zeros(length(trainSet.phi_rad),1);
trainSet.acc_phi_rad(2:end)=filter(filter_b,filter_a,(trainSet.velocity_phi_rad(2:end)-trainSet.velocity_phi_rad(1:end-1))/(1/20));

trainSet.velocity_theta_rad=zeros(length(trainSet.theta_rad),1);
trainSet.velocity_theta_rad(2:end)=smooth((trainSet.theta_rad(2:end)-trainSet.theta_rad(1:end-1))/(1/20));
trainSet.acc_theta_rad=zeros(length(trainSet.theta_rad),1);
trainSet.acc_theta_rad(2:end)=smooth((trainSet.velocity_theta_rad(2:end)-trainSet.velocity_theta_rad(1:end-1))/(1/20));
%% leat square estimation for alpha k d
m0=par_set.m0;L=par_set.L;g=9.8;
for i =1:length(trainSet.pd_MPa)
theta=trainSet.theta_rad(i);phi=trainSet.phi_rad(i);b0=trainSet.beta(i);
dtheta=trainSet.velocity_theta_rad(i);dphi=trainSet.velocity_phi_rad(i);
pm1=trainSet.pm_MPa(i,2);pm2=trainSet.pm_MPa(i,3);pm3=trainSet.pm_MPa(i,4);
Izz=m0*b0^2;
M(i,1)=Izz/4 + m0*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(b0 - L/theta)^2)/4;
C(i,1)= (dtheta*m0*sin(theta/2)*(b0 - L/theta)*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2))/4 - m0*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)*((dtheta*sin(theta/2)*(b0 - L/theta))/4 - (L*dtheta*cos(theta/2))/theta^2 + (2*L*dtheta*sin(theta/2))/theta^3);
C_simp(i,1)=-(L*dtheta*m0*(2*sin(theta/2) - theta*cos(theta/2))*(2*L*sin(theta/2) - L*theta*cos(theta/2) + b0*theta^2*cos(theta/2)))/(2*theta^5);
G(i,1)=(g*m0*sin(theta/2)^2*(b0 - L/theta))/2 - g*m0*cos(theta/2)*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2);
G_simp(i,1)=-(g*m0*(L*sin(theta) + b0*theta^2*cos(theta) - L*theta*cos(theta)))/(2*theta^2);
pi_alpha(i,1)=sin(phi)*(0.5*pm1+0.5*pm2-pm3)-sqrt(3)*cos(phi)*(0.5*pm1-0.5*pm2);
pi_k(i,1)=-theta;
pi_d(i,1)=-dtheta;
end
%%%%
tau_bar=M.*trainSet.acc_theta_rad+C_simp.*trainSet.velocity_theta_rad+G_simp;
Y_bar=[pi_alpha,pi_k,pi_d];
%%%%
start_pt=300;
end_pt=length(Y_bar);
%%%%
temp.result=inv(Y_bar(start_pt:end_pt,:).'*Y_bar(start_pt:end_pt,:))*Y_bar(start_pt:end_pt,:).'*tau_bar(start_pt:end_pt,:);
% fprintf('Estimated [alpha,k,d] is [%.4f,%.4f,%.4f] \n',temp.result(1),temp.result(2),temp.result(3))
trainSet.pi_set=temp.result;
end