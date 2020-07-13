function []=func_compareCamWithBase(trainSet)
 test_tip_pos=[];
    test_tip_pos=trainSet.tip_exp;
    figure('Name','3D position Cam vs. Base')
    subplot(1,2,1)
    plot3(test_tip_pos(:,2),test_tip_pos(:,3),test_tip_pos(:,4),'LineWidth',1,'LineStyle','-.','Color','k')
    hold on
    scatter3(test_tip_pos(1,2),test_tip_pos(1,3),test_tip_pos(1,4),'LineWidth',4,'Marker','hexagram','MarkerFaceColor','r')
    hold on
    xlim([-0.2,0.2])
    ylim([-0.2,0.2])
    zlim([-0.2,0.2])
    hold on
    grid on
    title('Camera Frame')
    xlabel('X(m)')
    ylabel('Y(m)')
    subplot(1,2,2)
    test_tip_pos=[];
    test_tip_pos=trainSet.tip_exp_baseFrame;
    plot3(test_tip_pos(:,2),test_tip_pos(:,3),test_tip_pos(:,4),'LineWidth',1,'LineStyle','-.','Color','b')
    hold on
    scatter3(test_tip_pos(1,2),test_tip_pos(1,3),test_tip_pos(1,4),'LineWidth',4,'Marker','hexagram','MarkerFaceColor','g')
    hold on
    xlim([-0.2,0.2])
    ylim([-0.2,0.2])
    zlim([-0.2,0.2])
    hold on
    grid on
    title('Base Frame')
    xlabel('X(m)')
    ylabel('Y(m)')
end