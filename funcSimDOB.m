function par_set=funcSimDOB(par_set)
close all
%% Input Output data
testData=par_set.trial1;
testData= funcArcFrameTorque(testData,par_set);
% testData=func_getPhiThetaBfromXYZ(testData,par_set);    % get phi,theta,r0
% testData= func3ptFilter(testData);  % get d_phi d_theta
Ts=0.01;
timeArray=testData.pd_MPa(:,1);%sec
x1=zeros(length(timeArray),1);
x2=zeros(length(timeArray),1);
dx1=zeros(length(timeArray),1);
dx2=zeros(length(timeArray),1);
tau_p=zeros(length(timeArray),1);
m0=0.35;     % segment weight kg
g=9.8;       % gravity
L=par_set.L;      % segment length
NDOB_p=[];
NDOB_L=[];
% NDOB_beta=1e11;
% NDOB_X=0.5*(2.3781e-05+NDOB_beta*9.1862e-04);
NDOB_X=1/9.1862e-04;
NDOB_z=zeros(length(timeArray),1);
NDOB_dz=zeros(length(timeArray),1);
tau_est=zeros(length(timeArray),1);
% Input signal
%%
%%%% Initial values
x1=testData.theta_rad;x2=testData.velocity_theta_rad;

r0_array=testData.beta;
phi=testData.phi_rad;
pm1=testData.pm_MPa(:,2);
pm2=testData.pm_MPa(:,3);
pm3=testData.pm_MPa(:,4);

alpha=par_set.meanAlpha;
k=par_set.meanK;
b=par_set.meanB;

tau_p=testData.tau*alpha;
%%% smc tunning parameters
Km=par_set.maxK-k;
Dm= par_set.maxB-b;
Alpham= (par_set.maxAlpha-alpha)/alpha;
%%% Randomize the Delta K and D
deltaD=0;
deltaK=0;
seed1=rng;
Kmax = Km;
Kmin= -Km;
deltaK = (Kmax-Kmin).*rand(1,1) + Kmin;
%
seed2=rng;
Dmax =Dm;
Dmin= -Dm;
deltaD = (Dmax-Dmin).*rand(1,1) + Dmin;
deltaD=Dmax;
deltaK=Kmax;

seed3=rng;
Alphamax =Alpham;
Alphamin= -Alpham;
deltaAlpha = (Alphamax-Alphamin).*rand(1,1) + Alphamin;
%%% Max uncertainty
% deltaD=Dmax;
% deltaK=Kmax;
% deltaAlpha=Alphamax;

for i=1:length(timeArray)-1
    %%% Variable caculation
    theta=x1(i,1);
    dtheta=x2(i,1);
    r0=r0_array(i,1);
    Izz=m0*r0^2;
    M=Izz/4 + m0*((cos(theta/2)*(r0 - L/theta))/2 +...
        (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(r0 - L/theta)^2)/4;
    maxM(i,1)=M;
    maxdM(i,1)=-(L*m0*dtheta*(4*L - r0*theta^3 + L*theta^2 - 4*L*cos(theta) + L*cos(theta)*theta^2 - r0*cos(theta)*theta^3 + 2*r0*sin(theta)*theta^2 - 4*L*sin(theta)*theta))/(2*theta^5);
    C_simp=-(L*dtheta*m0*(2*sin(theta/2) - theta*cos(theta/2))*(2*L*sin(theta/2)...
        - L*theta*cos(theta/2) + r0*theta^2*cos(theta/2)))/(2*theta^5);
    G_simp=-(g*m0*(L*sin(theta) + r0*theta^2*cos(theta) - L*theta*cos(theta)))/(2*theta^2);
    NDOB_f=M\(k*x1(i,1) +(b+C_simp)*x2(i,1)+ G_simp);
    %%% Update X
    
    %%% Update p and L
    NDOB_p=1/NDOB_X*x2(i,1);
    NDOB_L=1/NDOB_X*(1/M);
    %%% Update estimated torque
    tau_est(i,1)=NDOB_z(i,1)+NDOB_p;
    NDOB_dz(i,1)=NDOB_L*(-NDOB_z(i,1)+NDOB_f-tau_p(i,1)-NDOB_p);
    NDOB_z(i+1,1)=NDOB_dz(i,1)*Ts+NDOB_z(i,1);
end
max(abs(maxM));
max(abs(maxdM));
%% Result compare
fp=figure('Name','smcAndilc','Position',[100,100,600,400]);
% subplot(2,1,1)
plot(timeArray(1:end),tau_est(1:end),'r')
hold on
plot(timeArray(1:end),tau_p(1:end,1),'b')
% hold on
% plot(timeArray(2:end),x_k(2:end,end),'k')
legend('tau_{est}','tau_{p}','Orientation','horizontal')
ylim([-1,0])
title(['|M|max =',num2str(max(maxM)),' |dot(M)|max =',num2str(max(maxdM)),...
    ' \beta =',num2str(NDOB_beta)])
% ylabel('Angle(rad)')
% fp.CurrentAxes.FontWeight='Bold';
% fp.CurrentAxes.FontSize=10;
% hold on
% subplot(2,1,2)
% plot([1:1:max_iteration],RMSE_k,'r')
% title(['RMSE'])
% ylabel('RMSE(rad)')
% xlabel('Iterations')
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=10;

end