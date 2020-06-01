clear all
close all
clc
% load('sili_data.mat')
%% Initialize the system
par=[];
par.EOM=0;%flag for EOM deriviation
exp_case=1;% 1:Step response 2-2-2 to 25-2-2 to 2-25-25 five times 
%2: Step response 25-2-2 to 25-25-2 to 25-2-2 to 25-2-25 five times
par=func_exp_04_21(par,exp_case);
par.trianlge_length=70*1e-03;% fabric triangle edge length
par.c_plot_figure=0;%flag for plot
par.L=0.19;%actuator length
par.n=6;% # of joints for augmented rigid arm
% par.a0=15*1e-03;par.coeff_of_Area=0.1;
% temp.b=[];temp.c=[];
par.m0=0.35;%kg segment weight
par.g=9.8;%% gravity constant
par.a0=15*1e-03;
par.r_f=sqrt(3)/6*par.trianlge_length+par.a0; % we assume the force are evenly spread on a cirlce with radius of r_f
par.p1_angle=-30;%deg p1 position w/ the base frame
% update force position of p1 p2 and p3
for i =1:3
    par.r_p{i}=[par.r_f*cosd(par.p1_angle-120*(i-1)),par.r_f*sind(par.p1_angle-120*(i-1)),0].';
    par.f_p{i}=588.31*par.pm_MPa(:,i+1);
end
%% Get sample from the exp. data
sample=[];
temp.start=100;
temp.end=4800;
sample.pd_psi=par.pd_psi(temp.start:temp.end,1:end);
sample.pm_psi=par.pm_psi(temp.start:temp.end,1:end);
sample.pd_MPa=par.pd_MPa(temp.start:temp.end,1:end);
sample.pm_MPa=par.pm_MPa(temp.start:temp.end,1:end);
sample.tip_exp=par.tip_exp(temp.start:temp.end,1:end);
%% Calculate Phi from the data
% % Rotate w/ z-axis 0 deg
par.Rz_angle=0;%deg
par.Rz=[cosd(par.Rz_angle) sind(par.Rz_angle) 0;
        -sind(par.Rz_angle) cosd(par.Rz_angle) 0;
        0 0 1];
temp.phi_vector=sample.tip_exp(:,2:4); %xyz in Global frame
temp.angle_phi=[];
% Calculate phi anlge ranging [0,2pi]
for i =1:length(sample.pd_psi)
    temp.angle_phi(i,1)=rad2deg(func_myatan(temp.phi_vector(i,2),temp.phi_vector(i,1)));
end
sample.phi=temp.angle_phi;
sample.phi_rad=deg2rad(temp.angle_phi);
sample.phi_vector=temp.phi_vector;
%% XYZ in new frame (Z-Axis Rotation with phi)
tip_segi(:,1)=sample.tip_exp(:,1);
for i =1 : length(temp.phi_vector)
    temp.Rz=[];
    temp.Rz=[cosd(temp.angle_phi(i)) sind(temp.angle_phi(i)) 0;
        -sind(temp.angle_phi(i)) cosd(temp.angle_phi(i)) 0;
        0 0 1];
    temp_var=temp.phi_vector(i,1:3)*temp.Rz';
    tip_segi(i,2:4)=temp_var;
end
sample.tip_segi=tip_segi;
%% Theta calculation in X-Z plane no beta offset
base_exp=zeros(length(sample.tip_exp(:,1)),3);
vector=[0,0,0.01]';
theta_vector=[sample.tip_segi(:,2),sample.tip_segi(:,4)]; %xyz in Segittal frame z/x'
angle_theta=90-atan2d(theta_vector(:,2),theta_vector(:,1));
sample.theta=2*angle_theta;
sample.theta_rad=deg2rad(angle_theta);
%% Inextensible layer on the Edge
% find points (x_e,y_e) on three edges where (x_e,y_e)=beta*(x_top,y_top)
% beta <0 and min(|beta|)
beta_array=zeros(length(sample.phi),3);
beta_array(:,1)=-par.trianlge_length./(sqrt(3)*(temp.phi_vector(:,2)-sqrt(3)*temp.phi_vector(:,1)));
beta_array(:,2)=-par.trianlge_length./(sqrt(3)*(temp.phi_vector(:,2)+sqrt(3)*temp.phi_vector(:,1)));
beta_array(:,3)=sqrt(3)*par.trianlge_length./(6*temp.phi_vector(:,2));
sample.beta=[];
for i=1:length(beta_array)% find beta <0 and min(beta)
    temp_array_1=[];temp_array_2=[];k=1;
    temp_array_1=beta_array(i,:);
    for j=1:length(temp_array_1)
        if temp_array_1(j)<=0
            temp_array_2(k)=temp_array_1(j);
            k=k+1;
        end
    end
        [beta_value,beta_pos]=min(abs(temp_array_2),[],2);
        sample.beta(i,1)=norm(beta_value*temp.phi_vector(i,1:2));
        sample.x_y_edge(i,1:2)=-beta_value*temp.phi_vector(i,1:2);
end

for i =1:3
    sample.r_p{i}=par.Rz*par.r_p{i};
end

%% Plot Edege position
x1=linspace(0,0.035,100);
x2=linspace(-0.035,0,100);
x3=linspace(-0.035,0.035,100);
y1=sqrt(3)*x1-1/sqrt(3)*par.trianlge_length;
y2=-sqrt(3)*x2-1/sqrt(3)*par.trianlge_length;
y3=ones(length(x3),1)*sqrt(3)/6*par.trianlge_length;
% rotate with Rz
for i=1:length(x1)
    edge1(:,i)=par.Rz(1:2,1:2)*[x1(i);y1(i)];
    edge2(:,i)=par.Rz(1:2,1:2)*[x2(i);y2(i)];
    edge3(:,i)=par.Rz(1:2,1:2)*[x3(i);y3(i)];
end
% par.c_plot_figure=1;
if par.c_plot_figure==1
    figure('Position',[100;100;600;600])
    for i =1:3
        scatter(sample.r_p{i}(1),sample.r_p{i}(2),'*')
    hold on
    end
    scatter(sample.phi_vector(1,1),sample.phi_vector(1,2),'g','*','LineWidth',12)
    hold on
    scatter(sample.phi_vector(end,1),sample.phi_vector(end,2),'c','*','LineWidth',12)
    hold on
    scatter(sample.x_y_edge(:,1),sample.x_y_edge(:,2),'r')
    hold on
    scatter(sample.phi_vector(:,1),sample.phi_vector(:,2),'b')
    hold on
    plot(edge1(1,:),edge1(2,:),'LineStyle',':','Color','y','LineWidth',2)
    hold on
    plot(edge2(1,:),edge2(2,:),'LineStyle',':','Color','y','LineWidth',2)
    hold on
    plot(edge3(1,:),edge3(2,:),'LineStyle',':','Color','y','LineWidth',2)
    hold on
    for i =1:20:length(sample.phi_vector)
        temp_v=[];
        temp_v=[sample.phi_vector(i,1:2);sample.x_y_edge(i,1:2)];
        plot(temp_v(:,1),temp_v(:,2),'k')
        hold on
    end

    legend('p1','p2','p3','start','end','Edge Point','Tip Center','Inextensible Edge','Location','southeast')
    xlabel('X-axis m')
    ylabel('Y-axis m')
    xlim([-0.07,0.07])
    ylim([-0.07,.07]) 
end
%% Augmented Rigid tip Estimation maps to Eq. (4) in the paper
xi_vector=[deg2rad(sample.phi), deg2rad(sample.theta/2), (par.L./deg2rad(sample.theta)-sample.beta).*sind(sample.theta/2),...
    (par.L./deg2rad(sample.theta)-sample.beta).*sind(sample.theta/2), deg2rad(sample.theta/2), -deg2rad(sample.phi)];
for j=1:length(xi_vector)
    xi=xi_vector(j,:);
    rigid_b0=sample.beta(j);thetad=sample.theta_rad(j);L=par.L;a0=par.a0;
     p1=sample.pm_MPa(j,2);p2=sample.pm_MPa(j,3);p3=sample.pm_MPa(j,4);
% Maps to Table 1. DH parameters  
    rigid_a=zeros(1,par.n);
    rigid_alpha=[-pi/2,pi/2,  0,   -pi/2,pi/2,0];%alpha
    rigid_d=    [0      0   xi(3) xi(4) 0     0 ];
    rigid_theta=[xi(1) xi(2) 0    0    xi(5) xi(6)];
    m=[0 0  par.m0];
% Get HTM T{i}, p{i}, z{i}, for Jacobian calculation    
    Ti = cell(par.n+1,1);
    Ti(1) = {[1 0 0 0;0 1 0 0; 0 0 1 0; 0 0 0 1]};
    p_i{1}=Ti{1}(1:3,4);
    z_i{1}=Ti{1}(1:3,3);
for i = 2:par.n+1
    Ti{i} =  Ti{i-1} * ([cos(rigid_theta(i-1)) -sin(rigid_theta(i-1)) 0 0; sin(rigid_theta(i-1)) cos(rigid_theta(i-1)) 0 0; 0 0 1 0; 0 0 0 1] *[1 0 0 0; 0 1 0 0; 0 0 1 rigid_d(i-1); 0 0 0 1]*[1 0 0 rigid_a(i-1); 0 1 0 0; 0 0 1 0; 0 0 0 1]*[1 0 0 0; 0 cos(rigid_alpha(i-1)) -sin(rigid_alpha(i-1)) 0 ; 0 sin(rigid_alpha(i-1)) cos(rigid_alpha(i-1)) 0; 0 0 0 1]);
    p_i{i}=Ti{i}(1:3,4);
    z_i{i}=Ti{i}(1:3,3);
end
%% Linear Velocity J_v
J_v=cell(par.n,1);
i=par.n;
    j_v=(zeros(3,par.n));
    for j_counter =1:i
        if rigid_theta(j_counter) == 0 %% Prismatic Joint
            j_v(:,j_counter)=z_i{j_counter};
        else %% Rotational Joint
            j_v(:,j_counter)=cross(z_i{j_counter},(p_i{i+1}-p_i{j_counter}));
        end
    end
    J_v{i}=j_v;
%% Angular Velocity J_w
J_w=cell(par.n,1);
i = par.n;
    j_w=(zeros(3,par.n));
    for j_counter =1:i
        if rigid_theta(j_counter) == 0 %% Prismatic Joint
            j_w(:,j_counter)=zeros(3,1);
        else %% Rotational Joint
            j_w(:,j_counter)=z_i{j_counter};
        end
    end
    J_w{i}=j_w;

%% Jacobian maps to Eq.(8)
J_xi2q{j}=[1, 0, 0, 0, 0, -1;
           0, 0.5, - (cos(thetad/2)*(rigid_b0 - L/thetad))/2 - (L*sin(thetad/2))/thetad^2,  - (cos(thetad/2)*(rigid_b0 - L/thetad))/2 - (L*sin(thetad/2))/thetad^2, 0.5, 0]';

J_x2xi{j}=[J_v{end};J_w{end}];
xyz_estimation(j,1:3)=(Ti{end}(1:3,4))';
%% Wrech force w/ base frame
f_p1=588.31*p1;%mpa
f_p2=588.31*p2;%mpa
f_p3=588.31*p3;%mpa
for i =1:3
    T_p{i}=Ti{end}*[eye(3),sample.r_p{i};0 0 0 1];
    r_p_base{i}=T_p{i}(1:3,4);
end

sample.top_p1_xyz(j,1:3)=r_p_base{1};
sample.top_p2_xyz(j,1:3)=r_p_base{2};
sample.top_p3_xyz(j,1:3)=r_p_base{3};

wrench_base_pm{j}=[f_p1*T_p{1}(1:3,3);cross(r_p_base{1},f_p1*T_p{1}(1:3,3))]+...
    [f_p2*T_p{2}(1:3,3);cross(r_p_base{2},f_p2*T_p{2}(1:3,3))]+...
    [f_p3*T_p{3}(1:3,3);cross(r_p_base{3},f_p3*T_p{3}(1:3,3))];
end
%% Project froce in base frame to joint frame and arc frame
% Wrech Force for sample maps to Eq. (10) and (11)
for i =1:length(sample.pm_MPa)
   temp_torque(1:2,i)=J_xi2q{i}'*J_x2xi{i}'*wrench_base_pm{i}; 
   temp_tau_xi(:,i)=J_x2xi{i}'*wrench_base_pm{i}; 
   temp_tau_base_frame(:,i)=wrench_base_pm{i};
end
sample.tau_phi=temp_torque(1,:);
sample.tau_theta=temp_torque(2,:);
sample.tau_xi=temp_tau_xi;
sample.tau_base_frame=temp_tau_base_frame;
%% Plot result 
temp_figure=figure(6);
label_y_array={'\phi_1','\theta_2','l_3','l_4','\theta_5','\phi_6'};
label_y_array2={'\tau_1','\tau_2','f_3','f_4','\tau_5','\tau_6'};
for i =1:2:par.n*2
subplot(6,2,i)
plot(rad2deg(xi_vector(:,(i+1)/2)))
ylabel(label_y_array{(i+1)/2},'FontWeight','bold','FontSize',16)
subplot(6,2,i+1)
plot(sample.tau_xi((i+1)/2,:))
ylabel(label_y_array2{(i+1)/2},'FontWeight','bold','FontSize',16)
end
temp_figure=figure(7);
label_y_array={'f_x','f_y','f_z','\tau_x','\tau_y','\tau_z'};
for i =1:6
subplot(6,1,i)
plot(sample.tau_base_frame(i,:))
ylabel(label_y_array{i},'FontWeight','bold','FontSize',16)
end
%% Getting velocity and acceleration
% 5 sample moving average method is used
windowSize = 5; 
filter_b = (1/windowSize)*ones(1,windowSize);
filter_a = 1;
sample.velocity_phi_rad=zeros(length(sample.phi_rad),1);
sample.velocity_phi_rad(2:end)=filter(filter_b,filter_a,(sample.phi_rad(2:end)-sample.phi_rad(1:end-1))/(1/20));
sample.acc_phi_rad=zeros(length(sample.phi_rad),1);
sample.acc_phi_rad(2:end)=filter(filter_b,filter_a,(sample.velocity_phi_rad(2:end)-sample.velocity_phi_rad(1:end-1))/(1/20));

sample.velocity_theta_rad=zeros(length(sample.theta_rad),1);
sample.velocity_theta_rad(2:end)=smooth((sample.theta_rad(2:end)-sample.theta_rad(1:end-1))/(1/20));
sample.acc_theta_rad=zeros(length(sample.theta_rad),1);
sample.acc_theta_rad(2:end)=smooth((sample.velocity_theta_rad(2:end)-sample.velocity_theta_rad(1:end-1))/(1/20));


%% Equation (63)
L=par.L;m0=par.m0;g=9.8;
for i =1:length(sample.pd_MPa)
theta=sample.theta_rad(i);phi=sample.phi_rad(i);b0=sample.beta(i);
dtheta=sample.velocity_theta_rad(i);dphi=sample.velocity_phi_rad(i);
%B_q
b11(i,1)=m0*sin(theta/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + m0*sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2;
b12(i,1)=(cos(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)))/2 - (sin(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)))/2;
b21(i,1)= (cos(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)))/2 - (sin(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)))/2;
b22(i,1)=((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)*(((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)*(m0*cos(theta/2)^2 + m0*sin(theta/2)^2*cos(phi + pi/2)^2 + m0*sin(theta/2)^2*sin(phi + pi/2)^2) - (m0*cos(theta/2)*(sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta) + sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)))/2 + (m0*cos(theta/2)*sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta))/2 + (m0*cos(theta/2)*sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta))/2) - (cos(phi + pi/2)*(sin(phi + pi/2)*(m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - cos(phi + pi/2)*(m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/4 - (sin(phi + pi/2)*(cos(phi + pi/2)*(m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - sin(phi + pi/2)*(m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/4 + (((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)*(m0*cos(theta/2)*sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta) - m0*cos(theta/2)*(sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta) + sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)*sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)))/2 + (m0*(sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta) + sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta))^2)/4 + (m0*cos(theta/2)^2*sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta)^2)/4 + (m0*cos(theta/2)^2*sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2)/4;

c11(i,1)=(dtheta*((m0*cos(theta/2)^2*(2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2))/2 - (m0*sin(theta/2)^2*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2))/2 - m0*cos(theta/2)*sin(theta/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)*sin(theta/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + m0*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2))/2 + dtheta*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)*((m0*cos(theta/2)^2*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))/2 + (m0*sin(theta/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))/2 + m0*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta) + m0*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + dphi*m0*sin(theta/2)^6*cos(phi + pi/2)*sin(phi + pi/2)*(b0 - L/theta)^2;
c12(i,1)=- (dphi*(sin(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) + cos(phi + pi/2)*(- m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)*sin(theta/2)^5*cos(phi + pi/2)*sin(phi + pi/2)^2*(b0 - L/theta)^2) - sin(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)*sin(theta/2)^5*cos(phi + pi/2)^2*sin(phi + pi/2)*(b0 - L/theta)^2) + cos(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) + (m0*cos(theta/2)^2*(2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2))/2 - (m0*sin(theta/2)^2*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2))/2 - m0*cos(theta/2)*sin(theta/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)*sin(theta/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + m0*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2))/2 - (dtheta*((cos(phi + pi/2)*(cos(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - sin(phi + pi/2)*(m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2 - (sin(phi + pi/2)*(sin(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - cos(phi + pi/2)*(m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2 + (cos(phi + pi/2)*(cos(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - cos(phi + pi/2)*(- 2*m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) - 2*m0*sin(theta/2)^4*cos(phi + pi/2)^3*sin(phi + pi/2)*(b0 - L/theta)^2 + 2*m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)*sin(phi + pi/2)^3*(b0 - L/theta)^2) + sin(phi + pi/2)*(- m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) - m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2 + 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2) + sin(phi + pi/2)*(m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2 - (sin(phi + pi/2)*(sin(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - cos(phi + pi/2)*(- m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) - m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2 + 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2) - sin(phi + pi/2)*(- 2*m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*sin(theta/2)^4*cos(phi + pi/2)*sin(phi + pi/2)^3*(b0 - L/theta)^2 + 2*m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)^3*sin(phi + pi/2)*(b0 - L/theta)^2) + cos(phi + pi/2)*(m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2))/4 - ((dtheta*((sin(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2 - (cos(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2))/2 + dphi*((m0*cos(theta/2)^2*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))/2 + (m0*sin(theta/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))/2 + m0*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta) + m0*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)))*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2) + (dtheta*((sin(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2 - (cos(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2)*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2))/2;
c21(i,1)= - (dtheta*(sin(phi + pi/2)*(m0*cos(theta/2)^2*cos(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*sin(theta/2)^2*cos(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)^2*cos(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - (cos(phi + pi/2)*(cos(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - sin(phi + pi/2)*(m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2 - cos(phi + pi/2)*(m0*cos(theta/2)^2*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*sin(theta/2)^2*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)^2*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2)) + (sin(phi + pi/2)*(sin(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - cos(phi + pi/2)*(m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2 - (cos(phi + pi/2)*(cos(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - cos(phi + pi/2)*(- 2*m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) - 2*m0*sin(theta/2)^4*cos(phi + pi/2)^3*sin(phi + pi/2)*(b0 - L/theta)^2 + 2*m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)*sin(phi + pi/2)^3*(b0 - L/theta)^2) + sin(phi + pi/2)*(- m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) - m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2 + 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2) + sin(phi + pi/2)*(m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2 + (sin(phi + pi/2)*(sin(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - cos(phi + pi/2)*(- m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) - m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2 + 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2) - sin(phi + pi/2)*(- 2*m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*sin(theta/2)^4*cos(phi + pi/2)*sin(phi + pi/2)^3*(b0 - L/theta)^2 + 2*m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)^3*sin(phi + pi/2)*(b0 - L/theta)^2) + cos(phi + pi/2)*(m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2))/4 + (dphi*((m0*cos(theta/2)^2*(2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2))/2 - (m0*sin(theta/2)^2*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2))/2 - m0*cos(theta/2)*sin(theta/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)*sin(theta/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + m0*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2))/2 + ((dtheta*((sin(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2 - (cos(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2))/2 + dphi*((m0*cos(theta/2)^2*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))/2 + (m0*sin(theta/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))/2 + m0*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta) + m0*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)))*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2) + (dtheta*((sin(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2 - (cos(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2)*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2))/2;
c22(i,1)=  - (dtheta*((sin(phi + pi/2)*(cos(phi + pi/2)*(m0*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - 2*m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) + sin(phi + pi/2)*(m0*sin(phi + pi/2)^2*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*sin(theta/2)^2*cos(phi + pi/2)^2*(2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - 2*m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2 + (cos(phi + pi/2)*(sin(phi + pi/2)*(m0*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - 2*m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) + cos(phi + pi/2)*(m0*cos(phi + pi/2)^2*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*sin(phi + pi/2)^2*(2*cos(theta/2)*sin(theta/2)^3*(b0 - L/theta)^2 - 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*sin(theta/2)^2*sin(phi + pi/2)^2*(2*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + 2*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - 2*m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2 - m0*(cos(theta/2)*sin(theta/2)*cos(phi + pi/2)^2*(b0 - L/theta) + cos(theta/2)*sin(theta/2)*sin(phi + pi/2)^2*(b0 - L/theta))*(sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta) + sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)^2 + m0*cos(theta/2)*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)^2))/8 - ((dtheta*sin(theta/2)*(b0 - L/theta))/4 - (L*dtheta*cos(theta/2))/theta^2 + (2*L*dtheta*sin(theta/2))/theta^3)*(((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)*(m0*cos(theta/2)^2 + m0*sin(theta/2)^2*cos(phi + pi/2)^2 + m0*sin(theta/2)^2*sin(phi + pi/2)^2) - (m0*cos(theta/2)*(sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta) + sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)))/2 + (m0*cos(theta/2)*sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta))/2 + (m0*cos(theta/2)*sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta))/2) + (((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)*(dphi*((sin(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2 - (cos(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2) + (dtheta*(- (cos(phi + pi/2)*(sin(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))) - cos(phi + pi/2)*(m0*cos(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*sin(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*sin(phi + pi/2)^2*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))))/2 - (sin(phi + pi/2)*(cos(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))) - sin(phi + pi/2)*(m0*sin(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))))/2 + m0*(sin(theta/2)*cos(phi + pi/2)^2 + sin(theta/2)*sin(phi + pi/2)^2)*(sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta) + sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*sin(theta/2)*cos(phi + pi/2)^2*(b0 - L/theta) + m0*cos(theta/2)^2*sin(theta/2)*sin(phi + pi/2)^2*(b0 - L/theta)))/2 - dtheta*(m0*cos(theta/2)*(sin(theta/2)*cos(phi + pi/2)^2 + sin(theta/2)*sin(phi + pi/2)^2) - m0*cos(theta/2)*sin(theta/2))*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)))/2 - (dphi*((cos(phi + pi/2)*(cos(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - sin(phi + pi/2)*(m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2 - (sin(phi + pi/2)*(sin(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - cos(phi + pi/2)*(m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2 + (cos(phi + pi/2)*(cos(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - cos(phi + pi/2)*(- 2*m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) - 2*m0*sin(theta/2)^4*cos(phi + pi/2)^3*sin(phi + pi/2)*(b0 - L/theta)^2 + 2*m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)*sin(phi + pi/2)^3*(b0 - L/theta)^2) + sin(phi + pi/2)*(- m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) - m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2 + 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2) + sin(phi + pi/2)*(m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2 - (sin(phi + pi/2)*(sin(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2)) - cos(phi + pi/2)*(- m0*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) - m0*sin(theta/2)^2*sin(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - m0*cos(theta/2)^2*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2 + 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)^2) - sin(phi + pi/2)*(- 2*m0*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*sin(theta/2)^4*cos(phi + pi/2)*sin(phi + pi/2)^3*(b0 - L/theta)^2 + 2*m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + 2*m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) - 2*m0*cos(theta/2)^2*sin(theta/2)^4*cos(phi + pi/2)^3*sin(phi + pi/2)*(b0 - L/theta)^2) + cos(phi + pi/2)*(m0*sin(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(cos(theta/2)^2*sin(theta/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(sin(theta/2)^4*cos(phi + pi/2)^2*(b0 - L/theta)^2 + sin(theta/2)^4*sin(phi + pi/2)^2*(b0 - L/theta)^2))))/2))/4 - ((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)*((dphi*((sin(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2 - (cos(phi + pi/2)*(m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))))/2))/2 + (dtheta*(- (cos(phi + pi/2)*(sin(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))) - cos(phi + pi/2)*(m0*cos(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*sin(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*sin(phi + pi/2)^2*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))))/2 - (sin(phi + pi/2)*(cos(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))) - sin(phi + pi/2)*(m0*sin(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))))/2 + m0*cos(theta/2)*(cos(theta/2)*sin(theta/2)*cos(phi + pi/2)^2*(b0 - L/theta) + cos(theta/2)*sin(theta/2)*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*(sin(theta/2)*cos(phi + pi/2)^2 + sin(theta/2)*sin(phi + pi/2)^2)*(sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta) + sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)) - m0*sin(theta/2)*(sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta) + sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta) + m0*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)))/4 - dtheta*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)*(- m0*cos(theta/2)*sin(theta/2) + m0*cos(theta/2)*sin(theta/2)*cos(phi + pi/2)^2 + m0*cos(theta/2)*sin(theta/2)*sin(phi + pi/2)^2)) + (dtheta*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)*(- (cos(phi + pi/2)*(sin(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))) - cos(phi + pi/2)*(m0*cos(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*sin(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*sin(phi + pi/2)^2*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))))/2 - (sin(phi + pi/2)*(cos(phi + pi/2)*(- m0*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*cos(phi + pi/2)*sin(phi + pi/2)*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta))) - sin(phi + pi/2)*(m0*sin(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*cos(phi + pi/2)^2*(2*cos(theta/2)^2*sin(theta/2)*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*sin(theta/2)^2*cos(phi + pi/2)^2*(2*sin(theta/2)^3*cos(phi + pi/2)^2*(b0 - L/theta) + 2*sin(theta/2)^3*sin(phi + pi/2)^2*(b0 - L/theta)))))/2 + m0*(sin(theta/2)*cos(phi + pi/2)^2 + sin(theta/2)*sin(phi + pi/2)^2)*(sin(theta/2)^2*cos(phi + pi/2)^2*(b0 - L/theta) + sin(theta/2)^2*sin(phi + pi/2)^2*(b0 - L/theta)) + m0*cos(theta/2)^2*sin(theta/2)*cos(phi + pi/2)^2*(b0 - L/theta) + m0*cos(theta/2)^2*sin(theta/2)*sin(phi + pi/2)^2*(b0 - L/theta)))/4;

g11(i,1)=0;
g21(i,1)= (g*m0*sin(theta/2)^2*(b0 - L/theta))/2 - g*m0*cos(theta/2)*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2);
end
%% Rigid force
for i =1:length(sample.pd_MPa)
    temp_b=[];temp_c=[];temp_g=[];
    temp_ddq=[];temp_dq=[];temp_q=[];temp_tau=[];
    temp_b=[b11(i) b12(i);b21(i) b22(i);];
    temp_c=[c11(i) c12(i);c21(i) c22(i);];
    temp_g=[g11(i);g21(i)];
    temp_ddq=[sample.acc_phi_rad(i);sample.acc_theta_rad(i)];
    temp_dq=[sample.velocity_phi_rad(i);sample.velocity_theta_rad(i)];
    temp_q=[sample.phi_rad(i);sample.theta_rad(i)];
    temp_tau=[sample.tau_phi(i);sample.tau_theta(i)];
    temp_result=-temp_b*temp_ddq-temp_c*temp_dq-temp_g+temp_tau;
    f11(i,1)=temp_result(1);
    f21(i,1)=temp_result(2);
end
%% Get Y matrix 
Y_bar=zeros(2*length(sample.pd_MPa),4);
tau_bar=zeros(2*length(sample.pd_MPa),1);
for i =1:1:length(sample.pd_MPa)
    Y_t=zeros(2,4);tau_t=zeros(2,1);
    Y_t(1,1)=sample.phi_rad(i);Y_t(2,2)=sample.theta_rad(i);Y_t(1,3)=sample.velocity_phi_rad(i);Y_t(2,4)=sample.velocity_theta_rad(i);
    tau_t(1,1)=f11(i);tau_t(2,1)=f21(i);
    Y_bar(2*i-1:2*i,:)=Y_t;
    tau_bar(2*i-1:2*i,:)=tau_t;
end
%% Results
k12_d12=inv(Y_bar'*Y_bar)*Y_bar'*tau_bar;
sample.K=[k12_d12(1) 0;
    0 k12_d12(2)];
sample.D=[k12_d12(3) 0;
    0 k12_d12(4)];
fprintf( 'K matrix \n' )
sample.K
fprintf( 'D matrix \n' )
sample.D
%%
%%%Compare
figure(1)
subplot(4,1,1)
plot(sample.pm_MPa(:,1),sample.pm_MPa(:,2))
hold on
plot(sample.pm_MPa(:,1),sample.pm_MPa(:,3))
hold on
plot(sample.pm_MPa(:,1),sample.pm_MPa(:,4))
hold on
xlabel('Time(s)')
ylabel('P_m (MPa)')
legend('p1','p2','p3','Location','eastoutside')
hold on

subplot(4,1,2)
plot(sample.pm_MPa(:,1),sample.phi_vector(:,1))
hold on
plot(sample.pm_MPa(:,1),sample.phi_vector(:,2))
hold on
xlabel('Time(s)')
ylabel('Position(m)')
legend('x','y','Location','eastoutside')
hold on

subplot(4,1,3)
plot(sample.pm_MPa(:,1),sample.phi)
hold on
plot(sample.pm_MPa(:,1),sample.theta)
hold on
xlabel('Time(s)')
ylabel('Angle(deg)')
legend('\phi','\theta','Location','eastoutside')


subplot(4,1,4)
plot(sample.pm_MPa(:,1),sample.tau_phi)
hold on
plot(sample.pm_MPa(:,1),sample.tau_theta)
hold on
xlabel('Time(s)')
ylabel('Torque (Nm)')
legend('\tau_\phi','\tau_\theta','Location','eastoutside')
par.c_plot_figure=1;

if par.c_plot_figure==1
    figure('Position',[100;100;600;600])
    for i =1:3
        scatter(sample.r_p{i}(1),sample.r_p{i}(2),'*')
    hold on
    end
    scatter(sample.phi_vector(1,1),sample.phi_vector(1,2),'g','*','LineWidth',12)
    hold on
    scatter(sample.phi_vector(end,1),sample.phi_vector(end,2),'c','*','LineWidth',12)
    hold on
    scatter(sample.x_y_edge(:,1),sample.x_y_edge(:,2),'r')
    hold on
    scatter(sample.phi_vector(:,1),sample.phi_vector(:,2),'b')
    hold on
    plot(edge1(1,:),edge1(2,:),'LineStyle',':','Color','y','LineWidth',2)
    hold on
    plot(edge2(1,:),edge2(2,:),'LineStyle',':','Color','y','LineWidth',2)
    hold on
    plot(edge3(1,:),edge3(2,:),'LineStyle',':','Color','y','LineWidth',2)
    hold on
    for i =1:20:length(sample.phi_vector)
        temp_v=[];
        temp_v=[sample.phi_vector(i,1:2);sample.x_y_edge(i,1:2)];
        plot(temp_v(:,1),temp_v(:,2),'k')
        hold on
    end

    legend('p1','p2','p3','start','end','Edge Point','Tip Center','Inextensible Edge','Location','southeast')
    xlabel('X-axis m')
    ylabel('Y-axis m')
    xlim([-0.07,0.07])
    ylim([-0.07,.07]) 
end