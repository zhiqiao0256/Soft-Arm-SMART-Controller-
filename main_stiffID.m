%% Main function for stiffness ID use data 0704
clear all
close all
clc
%% Initialize the system
par_set=[];
%flag for EOM deriviation
par_set.EOM=1;
%flag for plot
par_set.flag_plot_rawData = 1;
%flag for read txt file or mat file 1: txt 0: mat
par_set.flag_read_exp = 1;
% p1 > p2,3
par_set.trial_2_25psi=[];
par_set.trial_5_25psi=[];
par_set.trial_1_25psi=[];
par_set.trial_0_25psi=[];
% Geometric para.
par_set.trianlge_length=70*1e-03;% fabric triangle edge length
par_set.L=0.19;%actuator length
par_set.n=4;% # of joints for augmented rigid arm
par_set.m0=0.35;%kg segment weight
par_set.g=9.8;%% gravity constant
par_set.a0=15*1e-03;%% 1/2 of pillow width
par_set.r_f=sqrt(3)/6*par_set.trianlge_length+par_set.a0; % we assume the force are evenly spread on a cirlce with radius of r_f
%% Update location of 3 chambers P1, P2, P3
par_set.p1_angle=-90;%deg p1 position w/ the base frame
% update force position of p1 p2 and p3
for i =1:3
    par_set.r_p{i}=[par_set.r_f*cosd(par_set.p1_angle+120*(i-1)),par_set.r_f*sind(par_set.p1_angle+120*(i-1)),0].';
%     par_set.f_p{i}=588.31*par_set.pm_MPa(:,i+1);
end
fprintf('System initialization done \n')
%% Read txt file or mat file
if par_set.flag_read_exp==1
    par_set.trial_2_25psi=func_high_level_exp(par_set.trial_2_25psi,1);
    par_set.trial_5_25psi=func_high_level_exp(par_set.trial_5_25psi,2);
    par_set.trial_1_25psi=func_high_level_exp(par_set.trial_1_25psi,3);
    par_set.trial_0_25psi=func_high_level_exp(par_set.trial_0_25psi,4);
    save('raw_id_data.mat','par_set');
    fprintf( 'Saved \n' )
else
    fprintf( 'Loading... \n' );
    load('raw_id_data.mat');
    fprintf( 'Data loaded \n' );
end
%% Rotate data with phi_0 deg let p1 at negative y axis
par_set.Rz_angle=30;%deg
par_set.Rz=[cosd(par_set.Rz_angle) -sind(par_set.Rz_angle)  0;
            sind(par_set.Rz_angle) cosd(par_set.Rz_angle)   0;
            0                   0                   1];
par_set.trial_2_25psi=func_alignCameraFrameWithBaseFrame(par_set.trial_2_25psi,par_set.Rz);
par_set.trial_1_25psi=func_alignCameraFrameWithBaseFrame(par_set.trial_1_25psi,par_set.Rz);
par_set.trial_0_25psi=func_alignCameraFrameWithBaseFrame(par_set.trial_0_25psi,par_set.Rz);
par_set.trial_5_25psi=func_alignCameraFrameWithBaseFrame(par_set.trial_5_25psi,par_set.Rz);
fprintf('Data is rotated %.f deg w.r.t. z (Or s in paper) p1 at -y axis.\n',par_set.Rz_angle)
if par_set.flag_plot_rawData==1
    test_tip_pos=[];
    test_tip_pos=par_set.trial_2_25psi.tip_exp;
    figure('Name','Raw 3D position vs. Rotated')
    subplot(1,2,1)
    plot3(test_tip_pos(:,2),test_tip_pos(:,3),test_tip_pos(:,4),'LineWidth',1,'LineStyle','-.','Color','k')
    hold on
    scatter3(test_tip_pos(1,2),test_tip_pos(1,3),test_tip_pos(1,4),'LineWidth',4,'Marker','hexagram','MarkerFaceColor','r')
    hold on
    xlim([-0.1,0.1])
    ylim([-0.1,0.1])
    zlim([0.0,0.2])
    grid on
    title('Camera Frame')
    xlabel('X(m)')
    ylabel('Y(m)')
    subplot(1,2,2)
    test_tip_pos=[];
    test_tip_pos=par_set.trial_2_25psi.tip_exp_rotated;
    plot3(test_tip_pos(:,2),test_tip_pos(:,3),test_tip_pos(:,4),'LineWidth',1,'LineStyle','-.','Color','b')
    hold on
    scatter3(test_tip_pos(1,2),test_tip_pos(1,3),test_tip_pos(1,4),'LineWidth',4,'Marker','hexagram','MarkerFaceColor','g')
    hold on
    xlim([-0.1,0.1])
    ylim([-0.1,0.1])
    zlim([0.0,0.2])
    grid on
    title('Rotated')
    xlabel('X(m)')
    ylabel('Y(m)')
end
%% Symbolic EOM
if par_set.EOM==1
par_set=func_EOM_YZplane(par_set);
end
%% Get sample from the exp. data
trainSet=[];test_data=[];
test_data=par_set.trial_2_25psi;
[val,pos]=findpeaks(test_data.pd_psi(:,2));
trainSet.r_p=par_set.r_p;
%%%%%%%%%%%%%%%
trainSet.pd_psi=test_data.pd_psi(1:pos(6)-10,1:end);
trainSet.pm_psi=test_data.pm_psi(1:pos(6)-10,1:end);
trainSet.pd_MPa=test_data.pd_MPa(1:pos(6)-10,1:end);
trainSet.pm_MPa=test_data.pm_MPa(1:pos(6)-10,1:end);
trainSet.tip_exp=test_data.tip_exp_rotated(1:pos(6)-10,1:end);
%%%%%%%%%%%%
validSet.pd_psi=test_data.pd_psi(pos(6)-9,1:end);
validSet.pm_psi=test_data.pm_psi(pos(6)-9,1:end);
validSet.pd_MPa=test_data.pd_MPa(pos(6)-9,1:end);
validSet.pm_MPa=test_data.pm_MPa(pos(6)-9,1:end);
validSet.tip_exp=test_data.tip_exp_rotated(pos(6)-9,1:end);
fprintf('Dividing trainning set and validation set\n')
%% Calculate Phi from the data
temp.phi_vector=trainSet.tip_exp(:,2:4); %xyz in Global frame
temp.angle_phi=[];
% Calculate phi anlge ranging [0,2pi] atan(y_top/x_top)
for i =1:length(trainSet.pd_psi)
    temp.angle_phi(i,1)=rad2deg(func_myatan(temp.phi_vector(i,2),temp.phi_vector(i,1)));
end
trainSet.phi=temp.angle_phi;
trainSet.phi_rad=deg2rad(temp.angle_phi);
trainSet.phi_vector=temp.phi_vector;
%% Theta calculation using x,y,z
trainSet.theta=
trainSet.theta_rad=deg2rad(trainSet.theta);
%% Inextensible layer on the Edge
% find points (x_e,y_e) on three edges where (x_e,y_e)=beta*(x_top,y_top)
% beta <0 and min(|beta|)
beta_array=zeros(length(trainSet.phi),3);
beta_array(:,3)=par_set.trianlge_length./(sqrt(3)*(temp.phi_vector(:,2)-sqrt(3)*temp.phi_vector(:,1)));
beta_array(:,2)=par_set.trianlge_length./(sqrt(3)*(temp.phi_vector(:,2)+sqrt(3)*temp.phi_vector(:,1)));
beta_array(:,1)=-sqrt(3)*par_set.trianlge_length./(6*temp.phi_vector(:,2));
r_beta=zeros(length(trainSet.phi),3);
% r_beta(:,1)=beta_array(:,1).*trainSet.tip_exp(:,2:3);
% r_beta(:,2)=beta_array(:,2).*trainSet.tip_exp(:,2:3);
% r_beta(:,3)=beta_array(:,3).*trainSet.tip_exp(:,2:3);
trainSet.beta=[];
for i=1:length(beta_array)% find beta <0 and ||beta*(xt,yt)|| <= a0/sqrt(3)
    beta_k=beta_array(i,:);
    for k =1:3
        r_beta_k(i,k)=norm(beta_k(k).*trainSet.tip_exp(i,2:3));
        if beta_k(k)<0
            if  r_beta_k(i,k)<= par_set.trianlge_length/sqrt(3)
                trainSet.beta(i,1)=r_beta_k(i,k);
                trainSet.x_y_edge(i,1:2)=beta_k(k)*trainSet.tip_exp(i,2:3);
            else
                trainSet.beta(i,1)=0;
                trainSet.x_y_edge(i,1:2)=[0,0];
            end
        end
    end
end
%% Plot Edege position
x2=linspace(0,0.035,100);
x3=linspace(-0.035,0,100);
x1=linspace(-0.035,0.035,100);
y3=sqrt(3)*x3+1/sqrt(3)*par_set.trianlge_length;
y2=-sqrt(3)*x2+1/sqrt(3)*par_set.trianlge_length;
y1=-ones(length(x1),1)*sqrt(3)/6*par_set.trianlge_length;
% rotate with Rz
for i=1:length(x1)
    edge1(:,i)=[x1(i);y1(i)];
    edge2(:,i)=[x2(i);y2(i)];
    edge3(:,i)=[x3(i);y3(i)];
end
par_set.c_plot_figure=1;
if par_set.c_plot_figure==1
    figure('Position',[100;100;600;600])
    for i =1:3
        scatter(trainSet.r_p{i}(1),trainSet.r_p{i}(2),'*')
    hold on
    end
    scatter(trainSet.phi_vector(1,1),trainSet.phi_vector(1,2),'g','*','LineWidth',12)
    hold on
    scatter(trainSet.phi_vector(end,1),trainSet.phi_vector(end,2),'c','*','LineWidth',12)
    hold on
    scatter(trainSet.x_y_edge(:,1),trainSet.x_y_edge(:,2),'r')
    hold on
    scatter(trainSet.phi_vector(:,1),trainSet.phi_vector(:,2),'b')
    hold on
    plot(edge1(1,:),edge1(2,:),'LineStyle',':','Color','y','LineWidth',2)
    hold on
    plot(edge2(1,:),edge2(2,:),'LineStyle',':','Color','y','LineWidth',2)
    hold on
    plot(edge3(1,:),edge3(2,:),'LineStyle',':','Color','y','LineWidth',2)
    hold on
%     for i =1:20:length(trainSet.phi_vector)
%         temp_v=[];
%         temp_v=[trainSet.phi_vector(i,1:2);trainSet.x_y_edge(i,1:2)];
%         plot(temp_v(:,1),temp_v(:,2),'k')
%         hold on
%     end

    legend('p1','p2','p3','start','end','Edge Point','Tip Center','Inextensible Edge','Location','southeast')
    xlabel('X-axis m')
    ylabel('Y-axis m')
    xlim([-0.07,0.07])
    ylim([-0.07,.07]) 
end
%% Augmented Rigid tip Estimation maps to Eq. (4) in the paper
xi_vector=[trainSet.theta_rad/2, (par_set.L./trainSet.theta_rad-trainSet.beta).*sin(trainSet.theta_rad/2),(par_set.L./trainSet.theta_rad-trainSet.beta).*sin(trainSet.theta_rad/2),trainSet.theta_rad/2];
% xi_vector=[deg2rad(sample.phi), deg2rad(sample.theta/2), (par.L./deg2rad(sample.theta)-sample.beta).*sind(sample.theta/2),...
%     (par.L./deg2rad(sample.theta)-sample.beta).*sind(sample.theta/2), deg2rad(sample.theta/2), -deg2rad(sample.phi)];
for j=1:length(xi_vector)
    xi=xi_vector(j,:);
    rigid_b0=trainSet.beta(j);thetad=trainSet.theta_rad(j);L=par_set.L;a0=par_set.a0;
     p1=trainSet.pm_MPa(j,2);p2=trainSet.pm_MPa(j,3);p3=trainSet.pm_MPa(j,4);
% Maps to Table 1. DH parameters  
    rigid_a=zeros(1,par_set.n);
    rigid_alpha=[-pi/2 0    pi/2      -pi/2];
    rigid_d=    [0     xi(2) xi(3)    0   ];
    rigid_theta=[xi(1) 0        0   xi(4)];
    m=[0 0  par_set.m0];
% Get HTM T{i}, p{i}, z{i}, for Jacobian calculation    
    Ti = cell(par_set.n+1,1);
    Ti(1) = {[1 0 0 0;0 1 0 0; 0 0 1 0; 0 0 0 1]};
    p_i{1}=Ti{1}(1:3,4);
    z_i{1}=Ti{1}(1:3,3);
for i = 2:par_set.n+1
    Ti{i} =  Ti{i-1} * ([cos(rigid_theta(i-1)) -sin(rigid_theta(i-1)) 0 0; sin(rigid_theta(i-1)) cos(rigid_theta(i-1)) 0 0; 0 0 1 0; 0 0 0 1] *[1 0 0 0; 0 1 0 0; 0 0 1 rigid_d(i-1); 0 0 0 1]*[1 0 0 rigid_a(i-1); 0 1 0 0; 0 0 1 0; 0 0 0 1]*[1 0 0 0; 0 cos(rigid_alpha(i-1)) -sin(rigid_alpha(i-1)) 0 ; 0 sin(rigid_alpha(i-1)) cos(rigid_alpha(i-1)) 0; 0 0 0 1]);
    p_i{i}=Ti{i}(1:3,4);
    z_i{i}=Ti{i}(1:3,3);
end
%% Linear Velocity J_v
J_v=cell(par_set.n,1);
i=par_set.n;
    j_v=(zeros(3,par_set.n));
    for j_counter =1:i
        if rigid_theta(j_counter) == 0 %% Prismatic Joint
            j_v(:,j_counter)=z_i{j_counter};
        else %% Rotational Joint
            j_v(:,j_counter)=cross(z_i{j_counter},(p_i{i+1}-p_i{j_counter}));
        end
    end
    J_v{i}=j_v;
%% Angular Velocity J_w
J_w=cell(par_set.n,1);
i = par_set.n;
    j_w=(zeros(3,par_set.n));
    for j_counter =1:i
        if rigid_theta(j_counter) == 0 %% Prismatic Joint
            j_w(:,j_counter)=zeros(3,1);
        else %% Rotational Joint
            j_w(:,j_counter)=z_i{j_counter};
        end
    end
    J_w{i}=j_w;

%% Jacobian maps to Eq.(8)
J_xi2q{j}=[0.5, - (cos(thetad/2)*(rigid_b0 - L/thetad))/2 - (L*sin(thetad/2))/thetad^2,- (cos(thetad/2)*(rigid_b0 - L/thetad))/2 - (L*sin(thetad/2))/thetad^2, 0.5]';

J_x2xi{j}=[J_v{end};J_w{end}];
xyz_estimation(j,1:3)=(Ti{end}(1:3,4))';
% %% Wrech force w/ base frame
% f_p1=588.31*p1;%mpa
% f_p2=588.31*p2;%mpa
% f_p3=588.31*p3;%mpa
% for i =1:3
%     T_p{i}=Ti{end}*[eye(3),trainSet.r_p{i};0 0 0 1];
%     r_p_base{i}=T_p{i}(1:3,4);
% end
% 
% trainSet.top_p1_xyz(j,1:3)=r_p_base{1};
% trainSet.top_p2_xyz(j,1:3)=r_p_base{2};
% trainSet.top_p3_xyz(j,1:3)=r_p_base{3};
% 
% wrench_base_pm{j}=[f_p1*T_p{1}(1:3,3);cross(r_p_base{1},f_p1*T_p{1}(1:3,3))]+...
%     [f_p2*T_p{2}(1:3,3);cross(r_p_base{2},f_p2*T_p{2}(1:3,3))]+...
%     [f_p3*T_p{3}(1:3,3);cross(r_p_base{3},f_p3*T_p{3}(1:3,3))];
end
%%
func_compare_kinematic(temp.phi_vector,xyz_estimation,par_set)
%% Project froce in base frame to joint frame and arc frame
% Wrech Force for sample maps to Eq. (10) and (11)
for i =1:length(trainSet.pm_MPa)
   temp_torque(1:2,i)=J_xi2q{i}'*J_x2xi{i}'*wrench_base_pm{i}; 
   temp_tau_xi(:,i)=J_x2xi{i}'*wrench_base_pm{i}; 
   temp_tau_base_frame(:,i)=wrench_base_pm{i};
end
trainSet.tau_phi=temp_torque(1,:);
trainSet.tau_theta=temp_torque(2,:);
trainSet.tau_xi=temp_tau_xi;
trainSet.tau_base_frame=temp_tau_base_frame;
%% Plot result 
temp_figure=figure(6);
label_y_array={'\phi','\theta/2','d','-\phi','\phi','d','\theta/2','-\phi'};
label_y_array2={'\tau_1','\tau_2','f_3','\tau_4','\tau_5','f_6','\tau_7','\tau_8'};
for i =1:2:par_set.n*2
subplot(par_set.n,2,i)
plot(rad2deg(xi_vector(:,(i+1)/2)))
ylabel(label_y_array{(i+1)/2},'FontWeight','bold','FontSize',16)
subplot(par_set.n,2,i+1)
plot(trainSet.tau_xi((i+1)/2,:))
ylabel(label_y_array2{(i+1)/2},'FontWeight','bold','FontSize',16)
end
temp_figure=figure(7);
label_y_array={'\tau_{\phi}','\tau_{\theta}'};
for i =1:2
subplot(4,1,i)
plot(trainSet.pd_psi(:,1),temp_torque(i,:))
ylabel(label_y_array{i},'FontWeight','bold','FontSize',16)
end
hold on
subplot(4,1,3)
plot(trainSet.pd_psi(:,1),trainSet.phi)
ylabel('\phi (deg)','FontWeight','bold','FontSize',16)
ylim([0 180])
hold on
subplot(4,1,4)
plot(trainSet.pd_psi(:,1),trainSet.theta)
ylabel('\theta (deg)','FontWeight','bold','FontSize',16)
ylim([0 180])
%%