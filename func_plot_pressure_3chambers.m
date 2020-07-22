function []=func_plot_pressure_3chambers(trail)
    figure('Position',[200,200,600,400])
    plot(trail.pd_psi(:,1),trail.pd_psi(:,2),'LineStyle','-','Color','r')
    hold on
    plot(trail.pd_psi(:,1),trail.pd_psi(:,3),'LineStyle','-','Color','b')
    hold on
    plot(trail.pd_psi(:,1),trail.pd_psi(:,4),'LineStyle','-','Color','k')
    hold on
    plot(trail.pd_psi(:,1),trail.pm_psi(:,2),'LineStyle','--','Color','r')
    hold on
    plot(trail.pd_psi(:,1),trail.pm_psi(:,3),'LineStyle','--','Color','b')
    hold on
    plot(trail.pd_psi(:,1),trail.pm_psi(:,4),'LineStyle','--','Color','k')
    hold on
    legend('pd_1','pd_2','pd_3','pm_1','pm_2','pm_3','Orientation','horizontal')
end