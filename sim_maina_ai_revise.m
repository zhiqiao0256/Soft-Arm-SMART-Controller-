clear all
close all
clc
open_sim_load=load('opensim.mat');
testData= open_sim_load.opensim;

x=zeros(2,length(testData.pd_psi(:,1)));
x(:,1)=[testData.theta_rad(1);0];
test_u=testData.pd_psi(:,2:4)';
test_b0=testData.Ri;
alpha=1.2634;
k=0.4897;
b=0.8616;
for i =1:length(x)-1
    m0=0.35;g=9.8;L=0.185;
    theta=x(1,i);dtheta=x(2,i);

    pm1=test_u(1,i);pm2=test_u(2,i);pm3=test_u(3,i);
    phi=testData.phi_rad(i);
    b0=test_b0(i);
    dx=zeros(2,1);
    Izz=m0*b0^2;
    M=Izz/4 + m0*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(b0 - L/theta)^2)/4;
    C_simp=-(L*dtheta*m0*(2*sin(theta/2) - theta*cos(theta/2))*(2*L*sin(theta/2) - L*theta*cos(theta/2) + b0*theta^2*cos(theta/2)))/(2*theta^5);
    G_simp=-(g*m0*(L*sin(theta) + b0*theta^2*cos(theta) - L*theta*cos(theta)))/(2*theta^2);

    dx(1)=x(2,i);
    dx(2)=1/M*(-k*x(1) -(b+C_simp)*x(2)- G_simp+ (sin(phi)*(0.5*pm1+0.5*pm2-pm3)-sqrt(3)*cos(phi)*(0.5*pm1-0.5*pm2))*alpha);
    x(:,i+1)=x(:,i)+dx*(1.0/40);
end
figure
plot(testData.pd_MPa(:,1),x(1,:))