% close all
x = 0 : .01 : 2 * pi;
% polarplot(x, 0.75 + asin(sin(2*x+pi/2))./(sin(2*x+pi/2)*pi^2));
n=3;
xx=x-pi/6;
rr=cos(pi/n)./(cos(mod(xx,2*pi/n)-pi/n));
% hold on
figure
polarplot(x,rr)
hold on
polarplot(x(1),rr(1),'o')
hold on
polarplot(x(10),rr(10),'o')

return
for i =1 :length(x)
    xi=x(i);
    if xi < 2*pi/3
        rrr(i)=cos(pi/n)./(cos(xi-1*pi/n));
    elseif 2*pi/3 <= xi && xi <=4*pi/3
        rrr(i)=cos(pi/n)./(cos(xi-3*pi/n));
    else
        rrr(i)=cos(pi/n)./(cos(xi-5*pi/n));
    end
end
hold on
polarplot(x,rrr)
hold on
xt=pi/3;
for i =1 :length(xt)
    xi=xt(i)+pi;
    if xi < 2*pi/3
        rrrr(i)=cos(pi/n)./(cos(xi-1*pi/n));
    elseif 2*pi/3 <= xi && xi <=4*pi/3
        rrrr(i)=cos(pi/n)./(cos(xi-3*pi/n));
    else
        rrrr(i)=cos(pi/n)./(cos(xi-5*pi/n));
    end
end
polarplot(xt,rrrr,'Marker','o')
polarplot(xt+pi,rrrr,'Marker','o')