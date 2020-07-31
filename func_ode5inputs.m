function [dx] = func_ode5inputs(t, x, u, alpha,k,b)
%     alpha=piSet(1);k=piSet(2);b=piSet(3);
 % Output equations.
%   y = [x(1);                         ... % Angular position.
%        x(2)                          ... % Angular velocity.
%       ];
    dx = zeros(2,1);
   % State equations.
   m0=0.35;g=9.8;L=0.19;
   pm1=u(1);pm2=u(2);pm3=u(3);b0=u(4);phi=u(5);
   theta=x(1);
   dtheta=x(2);
   Izz=m0*b0^2;
    M=Izz/4 + m0*((cos(theta/2)*(b0 - L/theta))/2 + (L*sin(theta/2))/theta^2)^2 + (m0*sin(theta/2)^2*(b0 - L/theta)^2)/4;
    C_simp=-(L*dtheta*m0*(2*sin(theta/2) - theta*cos(theta/2))*(2*L*sin(theta/2) - L*theta*cos(theta/2) + b0*theta^2*cos(theta/2)))/(2*theta^5);
    G_simp=-(g*m0*(L*sin(theta) + b0*theta^2*cos(theta) - L*theta*cos(theta)))/(2*theta^2);
   dx = [x(2);                        ... % Angular velocity.
        M\(-k*x(1) -(b+C_simp)*x(2)- G_simp+ (sin(phi)*(0.5*pm1+0.5*pm2-pm3)...
        -sqrt(3)*cos(phi)*(0.5*pm1-0.5*pm2))*alpha);   ... % Angular acceleration.
       ];
end 