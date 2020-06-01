function []=func_plot_sample_results(sample)
fprintf( 'Plot Samples ...\n' )
figure(3)
set(gcf,'OuterPosition', [100,100,400,300]);
scatter3(sample.tip_exp(1,2),sample.tip_exp(1,3),sample.tip_exp(1,4),'r')
hold on
scatter3(sample.tip_exp(end,2),sample.tip_exp(end,3),sample.tip_exp(end,4),'b')
hold on
plot3(sample.tip_exp(:,2),sample.tip_exp(:,3),sample.tip_exp(:,4))
hold on
scatter3(sample.r_p{1}(1),sample.r_p{1}(2),sample.r_p{1}(3))
hold on
scatter3(sample.r_p{2}(1),sample.r_p{2}(2),sample.r_p{2}(3))
hold on
scatter3(sample.r_p{3}(1),sample.r_p{3}(2),sample.r_p{3}(3))
hold on
legend('Start','End','Path','p1','p2','p3')
title('Tip Position(m)')
xlabel('X');ylabel('Y');zlabel('Z');

figure(2)% figure for pd pm zyz roll pitch yall
set(gcf,'OuterPosition', [400,500,400,300]);
subplot(2,1,1)
title('Pressure')
plot(sample.pd_MPa(:,1),sample.pd_MPa(:,2),'Color','r','LineWidth',2)
hold on
plot(sample.pd_MPa(:,1),sample.pd_MPa(:,3),'Color','b','LineWidth',2)
hold on
plot(sample.pd_MPa(:,1),sample.pd_MPa(:,4),'Color','k','LineWidth',2)
hold on
plot(sample.pm_MPa(:,1),sample.pm_MPa(:,2),'Color','r','LineWidth',2,'LineStyle','-.')
hold on
plot(sample.pm_MPa(:,1),sample.pm_MPa(:,3),'Color','b','LineWidth',2,'LineStyle','-.')
hold on
plot(sample.pm_MPa(:,1),sample.pm_MPa(:,4),'Color','k','LineWidth',2,'LineStyle','-.')
legend('Pd1','Pd2','Pd3')
xlabel('Time')
ylabel('MPa')
% xlim([0 50])
subplot(2,1,2)
title('Position')
plot(sample.tip_exp(:,1),sample.tip_exp(:,2),'Color','r','LineWidth',2)
hold on
plot(sample.tip_exp(:,1),sample.tip_exp(:,3),'Color','b','LineWidth',2)
hold on
plot(sample.tip_exp(:,1),sample.tip_exp(:,4),'Color','k','LineWidth',2)
hold on
legend('x','y','z')
end