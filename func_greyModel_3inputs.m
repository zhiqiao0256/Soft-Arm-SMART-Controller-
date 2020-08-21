function dxdt= func_greyModel_3inputs(t,x,phit,phi,r0t,r0,ut,u1,u2,u3,alpha,k,b)
phi=interp1(phit,phi,t);
b0=interp1(r0t,r0,t);
pm1=interp1(ut,u1,t);
pm2=interp1(ut,u2,t);
pm3=interp1(ut,u3,t);
theta=x(1);
dtheta=x(2);
m0=0.35;g=9.8;L=0.19;
Izz=m0*b0^2;
% alpha=pi_set(1);k=pi_set(2);b=pi_set(3);

M=Izz/4 + m0*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(b0 - L/theta)^2)/4;
C_simp=-(L*dtheta*m0*(2*sin(theta/2) - theta*cos(theta/2))*(2*L*sin(theta/2) - L*theta*cos(theta/2) + b0*theta^2*cos(theta/2)))/(2*theta^5);
G_simp=-(g*m0*(L*sin(theta) + b0*theta^2*cos(theta) - L*theta*cos(theta)))/(2*theta^2);
dxdt(1,1)=x(2);
dxdt(2,1)= M\(-k*x(1) -(b+C_simp)*x(2)- G_simp+ (sin(phi)*(0.5*pm1+0.5*pm2-pm3)...
        -sqrt(3)*cos(phi)*(0.5*pm1-0.5*pm2))*alpha);
end