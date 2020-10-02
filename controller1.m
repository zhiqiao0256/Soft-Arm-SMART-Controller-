function [sys,x0,str,ts]=spacemodel(t,x,u,flag)
switch flag,
case 0,
[sys,x0,str,ts]=mdlInitializeSizes;
case 3,
sys=mdlOutputs(t,x,u);
case {2,4,9},
sys=[];
otherwise
error(['Unhandled flag=',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes=simsizes;
sizes.NumContStates=0;
sizes.NumDiscStates=0;
sizes.NumOutputs=3;
sizes.NumInputs=3;
sizes.DirFeedthrough=1;
sizes.NumSampleTimes=0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
xd=u(1);
dxd=cos(t);
ddxd= -sin(t);
x1=u(2);
dx1=u(3);
c=15;
e=xd-x1;
de=dxd-dx1;
s=c*e+de;
fx=-25*dx1;b=133;
D=10.1;
epc=0.5;k=10;
ut=1/b*(epc*sign(s)+k*s+c*de+ddxd-fx+D*sign(s));
sys(1)=ut;
sys(2)=e;
sys(3)=de;