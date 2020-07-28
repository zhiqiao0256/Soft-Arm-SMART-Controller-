function [x]=func_myode(test_data)
x=zeros(2,length(test_data.pd_psi(:,1)));
x(:,1)=[test_data.theta_rad(1);test_data.velocity_theta_rad(1)];
piSet=test_data.pi_set;
test_x=[test_data.theta_rad,test_data.velocity_theta_rad];
test_u=test_data.pd_psi(:,2:4)';
test_b0=test_data.beta;
for i =1:length(x)-1
    m0=0.35;g=9.8;L=0.19;
    theta=x(1,i);dtheta=x(2,i);
    alpha=piSet(1);k=piSet(2);b=piSet(3);
    pm1=test_u(1,i);pm2=test_u(2,i);pm3=test_u(3,i);
    phi=test_data.phi_rad(i);
    b0=test_b0(i);
    dx=zeros(2,1);
    Izz=m0*b0^2;
    M=Izz/4 + m0*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(b0 - L/theta)^2)/4;
    C_simp=-(L*dtheta*m0*(2*sin(theta/2) - theta*cos(theta/2))*(2*L*sin(theta/2) - L*theta*cos(theta/2) + b0*theta^2*cos(theta/2)))/(2*theta^5);
    G_simp=-(g*m0*(L*sin(theta) + b0*theta^2*cos(theta) - L*theta*cos(theta)))/(2*theta^2);

    dx(1)=x(2,i);
    dx(2)=1/M*(-k*x(1) -(b+C_simp)*x(2)- G_simp+ (sin(phi)*(0.5*pm1+0.5*pm2-pm3)-sqrt(3)*cos(phi)*(0.5*pm1-0.5*pm2))*alpha);
    x(:,i+1)=x(:,i)+dx*0.05;
end
end