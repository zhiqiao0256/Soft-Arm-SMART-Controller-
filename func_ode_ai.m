function [dxdt]=func_ode_ai(t,x,texp,u,beta,Phi)
dxdt = zeros(2,1);
m0=0.35;g=9.8;L=0.185;
theta=x(1);dtheta=x(2);
alpha=1.2634;
k=0.4897;
b=0.8616;
b0=interp1(texp,beta,t);
phi=interp1(texp,Phi,t);
pm1=interp1(texp,u(1,:),t);pm2=interp1(texp,u(2,:),t);pm3=interp1(texp,u(3,:),t);
% b0=beta(1);
% phi=Phi(1);
Izz=m0*b0^2;

M=Izz/4 + m0*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(b0 - L/theta)^2)/4;
C_simp=-(L*dtheta*m0*(2*sin(theta/2) - theta*cos(theta/2))*(2*L*sin(theta/2) - L*theta*cos(theta/2) + b0*theta^2*cos(theta/2)))/(2*theta^5);
G_simp=-(g*m0*(L*sin(theta) + b0*theta^2*cos(theta) - L*theta*cos(theta)))/(2*theta^2);
dxdt(1)=x(2);
dxdt(2)=M\(-k*x(1) -(b+C_simp)*x(2)- G_simp+ (sin(phi)*(0.5*pm1+0.5*pm2-pm3)-sqrt(3)*cos(phi)*(0.5*pm1-0.5*pm2))*alpha);
end