function []=func_camFramePlotMovingCC(trainSet)
    x2=linspace(0,0.035,100);
    x3=linspace(-0.035,0.035,100);
    x1=linspace(-0.035,0,100);
    y1= -sqrt(3)*x1-1/sqrt(3)*par_set.trianlge_length;
    y2= +sqrt(3)*x2-1/sqrt(3)*par_set.trianlge_length;
    y3= ones(length(x3),1)*sqrt(3)/6*par_set.trianlge_length;
    for i=1:length(x1)

        edge1(:,i)=[x1(i);y1(i);0];
        edge2(:,i)=[x2(i);y2(i);0];
        edge3(:,i)=[x3(i);y3(i);0];

    end
    figure('Position',[100;100;600;600])
    for i =1:3
        scatter3(trainSet.r_p{i}(1),trainSet.r_p{i}(2),trainSet.r_p{i}(3),'*')
        hold on
    end
    scatter3(trainSet.tip_exp(1,2),trainSet.tip_exp(1,3),trainSet.tip_exp(1,4),'g','*','LineWidth',4)
    hold on
    scatter3(trainSet.tip_exp(end,2),trainSet.tip_exp(end,3),trainSet.tip_exp(end,4),'c','*','LineWidth',4)
    hold on
    scatter3(trainSet.x_y_edge(:,1),trainSet.x_y_edge(:,2),trainSet.x_y_edge(:,3),'k')
    hold on
    scatter3(trainSet.tip_exp(:,2),trainSet.tip_exp(:,3),trainSet.tip_exp(:,4),'r','hexagram')
    hold on
    scatter3(0,0,0,'r','diamond')
    hold on
    plot3(edge1(1,:),edge1(2,:),edge1(3,:),'LineStyle',':','Color','k','LineWidth',2)
    hold on
    plot3(edge2(1,:),edge2(2,:),edge2(3,:),'LineStyle',':','Color','k','LineWidth',2)
    hold on
    plot3(edge3(1,:),edge3(2,:),edge3(3,:),'LineStyle',':','Color','k','LineWidth',2)
    hold on
    legend('Chamber 1','Chamber 2','Chamber 3','Start','End','Intersection point','Top center','Bottom center','Inextensible edge','Location','northwest')
    xlabel('X-axis (m)')
    ylabel('Y-axis (m)')
    zlabel('Z-axis (m)')
    xlim([-0.1,0.1])
    ylim([-0.1,.1])
    zlim([0,0.2])
    view([1,-1,1])
end