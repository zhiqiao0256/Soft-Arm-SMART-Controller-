%% main_frontier_r_append
l_tri = 70*1e-03;
phi_1= [0:0.01: pi/6];
phi_2= [0:0.01:4*pi/3];
phi_3= [pi:0.01:9*pi/3];

r_1=l_tri/sqrt(3)*(cos(pi/3))./(cos(mod(phi_1+pi/2,2*pi/3)-pi/3));
r_2=l_tri/sqrt(3)*(cos(pi/3))./(cos(mod(phi_2-pi/2,2*pi/3)-pi/3));
r_3=l_tri/sqrt(3)*(cos(pi/3))./(cos(mod(phi_3,2*pi/3)-pi/3));

phi30=pi/6+pi;
r30=l_tri/sqrt(3)*(cos(pi/3))./(cos(mod(phi30,2*pi/3)-pi/3));
r90=l_tri/sqrt(3)*(cos(pi/3))./(cos(mod(pi/2,2*pi/3)-pi/3));
x30=r30.*cos(phi30);
y30=r30*sin(phi30);
x90=r90*cos(pi/2);
y90=r90*sin(pi/2);
close all
figure(1)
plot(r_3.*cos(phi_3),r_3.*sin(phi_3),'Color','green')
hold on
scatter(x30,y30,'black')
hold on
scatter(x90,y90,'blue')
scatter(0,0,'red','filled')
grid on
xlim([-1 1]*0.05)
ylim([-1 1]*0.05)