%%%% Load data
close all; clear all; clc;
old_data = load('greyMPa1001_40Hz.mat');
new_data = load('opensim.mat');
%% Old simulation
testData=[];
avgModel.pi_grey=[1.2634,0.4897,0.8616]; % alpha, k, b in the paper
testData=old_data.par_set.trial7;
funcCompareAverageModel(avgModel,testData);
%% New simulation
testData=[];
testData = new_data.opensim;
t_array = testData.pd_psi(:,1);
% Resample
ts=timeseries([testData.phi_rad,testData.theta_rad,testData.pm_MPa(:,2:4),testData.Ri],t_array);
T=1/10000;
timevec=0:T:t_array(end);
tsout=resample(ts,timevec);
resampleData=tsout.Data;
time_set=[];
t_array = timevec';
re_phi_rad = resampleData(:,1);
re_theta_rad = resampleData(:,2);
re_pm_MPa = resampleData(:,3:5);
re_Ri = resampleData(:,6);
x = zeros(2,length(t_array));
x(1,1)=re_theta_rad(1);
test_u = zeros(1,length(timevec));
% test_u=testData.pd_psi(:,2:4)';
for i =1:length(x)
    sphi = sin(re_phi_rad(i));
    cphi = sin(re_phi_rad(i));
    p_array_i = re_pm_MPa(i,1:3);
    test_u(i) = [sphi, -cphi]*[-sin(pi/6), -sin(pi/6), 1;
                                cos(pi/6), -cos(pi/6), 0]*p_array_i';
end
test_b0 = re_Ri;
% Simulation part
M=[];C_simp=[];G_simp=[];
for i = 1:length(x)-1
    m0=0.35;g=9.8;L=0.185;
    theta=x(1,i);dtheta=x(2,i);
    b0=test_b0(i);
    dx=zeros(2,1);
    Izz=m0*b0^2;
    M(i)=Izz/4 + m0*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(b0 - L/theta)^2)/4;
    C_simp(i)=-(L*dtheta*m0*(2*sin(theta/2) - theta*cos(theta/2))*(2*L*sin(theta/2) - L*theta*cos(theta/2) + b0*theta^2*cos(theta/2)))/(2*theta^5);
    G_simp(i)=-(g*m0*(L*sin(theta) + b0*theta^2*cos(theta) - L*theta*cos(theta)))/(2*theta^2);

    dx(1)=x(2,i);
    dx(2)=1/M(i)*(-k*x(1) -(b+C_simp(i))*x(2)- G_simp(i)+ alpha*test_u(i));
    dx(2)=1/M(i)*(-k*x(1) -(b+C_simp(i))*x(2)- G_simp(i)+ alpha*test_u(i));
    x(:,i+1)=x(:,i)+dx*(T);
end
figure(1)
subplot(2,1,1)
plot(t_array,x(1,:))
ylabel('Angle (rad)')
subplot(2,1,2)
plot(t_array,x(2,:))
ylabel('Velocity (rad/s)')
xlabel('time(s)')