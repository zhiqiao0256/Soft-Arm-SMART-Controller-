function []=func_plot_low_level_overlayResult(par_set)
 fprintf( 'Plotting \n' );
%% Inflation Time domain results 0 psi to 5-25 psi
figure('Name','Inf trail overlay time domain 0 psi to 5-25 psi')
subplot(2,1,1)
title('Inflation Time domain results')
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_20psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_15psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_10psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','c','LineWidth',2,'LineStyle','--')
    hold on
end
workset=[];
workset=par_set.trail_0_5psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','g','LineWidth',2,'LineStyle','--')
    hold on
end
xlabel('Time(s)')
xlim([0 10])
ylabel('Chamber Pressure(psi)')
legend('p_{ref}','p_m','Location','northeast')


subplot(2,1,2)
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_20psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_15psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_10psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'c','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_5psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'g','LineWidth',2,'LineStyle','--')
    hold on
end

xlabel('Time(s)')
xlim([0 10])
ylabel('Pressrure Rate (psi/s)')
  
%% Inflation Sample domain 0 to 5-25psi

figure('Name','Inf trail overlay sample domain 0 psi to 5-25 psi')
subplot(2,1,1)
title('Inflation Sample domain results')
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_20psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_15psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_10psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','c','LineWidth',2,'LineStyle','--')
    hold on
end
workset=[];
workset=par_set.trail_0_5psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','g','LineWidth',2,'LineStyle','--')
    hold on
end
xlabel('Index(N)')
xlim([0 10])
ylabel('Chamber Pressure(psi)')
legend('p_{ref}','p_m','Location','northeast')


subplot(2,1,2)
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_20psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_15psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_10psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'c','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_5psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'g','LineWidth',2,'LineStyle','--')
    hold on
end

xlabel('Index(N)')
xlim([0 10])
ylabel('Pressrure Rate (psi/s)')
%% Inflation 0 to 5-25psi 
% figure('Name','Inf dot_pm vs. p_upstream-p_downstream')
% workset=[];
% workset=par_set.trail_0_25psi;
% for index_num=1:length(workset.inf_pd_psi)
%     temp_mat=[];
%     temp_mat=workset.inf_dot_pm_psi{index_num};
%     temp_mat2=workset.inf_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'r')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_20psi;
% for index_num=1:length(workset.inf_pd_psi)
%     temp_mat=[];
%     temp_mat=workset.inf_dot_pm_psi{index_num};
%     temp_mat2=workset.inf_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'b')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_15psi;
% for index_num=1:length(workset.inf_pd_psi)
%     temp_mat=[];
%     temp_mat=workset.inf_dot_pm_psi{index_num};
%     temp_mat2=workset.inf_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'k')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_10psi;
% for index_num=1:length(workset.inf_pd_psi)
%     temp_mat=[];
%     temp_mat=workset.inf_dot_pm_psi{index_num};
%     temp_mat2=workset.inf_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'c')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_5psi;
% for index_num=1:length(workset.inf_pd_psi)
%     temp_mat=[];
%     temp_mat=workset.inf_dot_pm_psi{index_num};
%     temp_mat2=workset.inf_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'g')
%     hold on
% end
% xlabel('p_{upStream}-p_{downStream} (psi)')
% ylabel('Pressrure Rate (psi/s)')
% title('Deflation pmRate vs. p_{upStream}-p_{downStream}') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inflation Time domain results 0-20 psi to 25 psi
figure('Name','Inf trail overlay time domain 0-20 psi to 25 psi')
subplot(2,1,1)
title('Inflation Time domain results')
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_5_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_10_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_15_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','c','LineWidth',2,'LineStyle','--')
    hold on
end
workset=[];
workset=par_set.trail_20_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','g','LineWidth',2,'LineStyle','--')
    hold on
end
xlabel('Time(s)')
xlim([0 10])
ylabel('Chamber Pressure(psi)')
legend('p_{ref}','p_m','Location','northeast')


subplot(2,1,2)
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_5_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_10_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_15_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'c','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_20_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'g','LineWidth',2,'LineStyle','--')
    hold on
end

xlabel('Time(s)')
xlim([0 10])
ylabel('Pressrure Rate (psi/s)')
%% Inflation Sample domain 0-20 psi to 25 psi

figure('Name','Inf trail overlay sample domain 0-20 psi to 25 psi')
subplot(2,1,1)
title('Inflation Sample domain results')
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_5_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_10_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_15_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','c','LineWidth',2,'LineStyle','--')
    hold on
end
workset=[];
workset=par_set.trail_20_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','g','LineWidth',2,'LineStyle','--')
    hold on
end
xlabel('Index(N)')
xlim([0 10])
ylabel('Chamber Pressure(psi)')
legend('p_{ref}','p_m','Location','northeast')


subplot(2,1,2)
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_20psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_15psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_10psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'c','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_5psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'g','LineWidth',2,'LineStyle','--')
    hold on
end

xlabel('Index(N)')
xlim([0 10])
ylabel('Pressrure Rate (psi/s)')
  

%% Inflation rate vs p_up-p_m 0-20 to 25psi 
% figure('Name','Inf dot_pm vs. p_upstream-p_downstream')
% workset=[];
% workset=par_set.trail_0_25psi;
% for index_num=1:length(workset.inf_pd_psi)
%     temp_mat=[];
%     temp_mat=workset.inf_dot_pm_psi{index_num};
%     temp_mat2=workset.inf_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'r')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_5_25psi;
% for index_num=1:length(workset.inf_pd_psi)
%     temp_mat=[];
%     temp_mat=workset.inf_dot_pm_psi{index_num};
%     temp_mat2=workset.inf_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'b')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_10_25psi;
% for index_num=1:length(workset.inf_pd_psi)
%     temp_mat=[];
%     temp_mat=workset.inf_dot_pm_psi{index_num};
%     temp_mat2=workset.inf_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'k')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_15_25psi;
% for index_num=1:length(workset.inf_pd_psi)
%     temp_mat=[];
%     temp_mat=workset.inf_dot_pm_psi{index_num};
%     temp_mat2=workset.inf_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'c')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_20_25psi;
% for index_num=1:length(workset.inf_pd_psi)
%     temp_mat=[];
%     temp_mat=workset.inf_dot_pm_psi{index_num};
%     temp_mat2=workset.inf_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'g')
%     hold on
% end
% xlabel('p_{upStream}-p_{downStream} (psi)')
% ylabel('Pressrure Rate (psi/s)')
% title('Deflation pmRate vs. p_{upStream}-p_{downStream}') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% deflation time domain 5-25psi to 0 
%
figure('Name','Def Trail overlay sample domain 5-25 psi to 0 psi')

subplot(2,1,1)
title('Deflation sample domain results')
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_20psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_15psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_10psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','c','LineWidth',2,'LineStyle','--')
    hold on
end
workset=[];
workset=par_set.trail_0_5psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','g','LineWidth',2,'LineStyle','--')
    hold on
end
xlabel('Index(N)')
xlim([0 10])
ylabel('Chamber Pressure(psi)')
legend('p_{ref}','p_m','Location','northeast')


subplot(2,1,2)
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_20psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_15psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_10psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'c','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_5psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'g','LineWidth',2,'LineStyle','--')
    hold on
end

xlabel('Index(N)')
xlim([0 10])
ylabel('Pressrure Rate (psi/s)')
 
%% Deflation Sample Domain 5-25 to 0 psi
figure('Name','Def Trail overlay 5-25 psi to 0 psi')

subplot(2,1,1)
title('Deflation Time domain results')
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_20psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_15psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_10psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','c','LineWidth',2,'LineStyle','--')
    hold on
end
workset=[];
workset=par_set.trail_0_5psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','g','LineWidth',2,'LineStyle','--')
    hold on
end
xlabel('Time(s)')
xlim([0 10])
ylabel('Chamber Pressure(psi)')
legend('p_{ref}','p_m','Location','northeast')


subplot(2,1,2)
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_20psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_15psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_10psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'c','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_0_5psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'g','LineWidth',2,'LineStyle','--')
    hold on
end

xlabel('Time(s)')
xlim([0 10])
ylabel('Pressrure Rate (psi/s)')
 
%% deflation rate 5-25 to 0 psi
% figure('Name','Def dot_pm vs. p_upstream-p_downstream')
% workset=[];
% workset=par_set.trail_0_25psi;
% for index_num=1:length(workset.def_pd_psi)
%     temp_mat=[];
%     temp_mat=-workset.def_dot_pm_psi{index_num};
%     temp_mat2=-workset.def_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'r')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_20psi;
% for index_num=1:length(workset.def_pd_psi)
%     temp_mat=[];
%     temp_mat=-workset.def_dot_pm_psi{index_num};
%     temp_mat2=-workset.def_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'b')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_15psi;
% for index_num=1:length(workset.def_pd_psi)
%     temp_mat=[];
%     temp_mat=-workset.def_dot_pm_psi{index_num};
%     temp_mat2=-workset.def_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'k')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_10psi;
% for index_num=1:length(workset.def_pd_psi)
%     temp_mat=[];
%     temp_mat=-workset.def_dot_pm_psi{index_num};
%     temp_mat2=-workset.def_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'c')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_5psi;
% for index_num=1:length(workset.def_pd_psi)
%     temp_mat=[];
%     temp_mat=-workset.def_dot_pm_psi{index_num};
%     temp_mat2=-workset.def_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'g')
%     hold on
% end
% xlabel('p_{upStream}-p_{downStream}')
% ylabel('Pressrure Rate (psi/s)') 
% title('Deflation pmRate vs. p_{upStream}-p_{downStream}') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% deflation time domain 25psi to 0-20 
%
figure('Name','Def Trail overlay sample domain 25 psi to 0-20 psi')

subplot(2,1,1)
title('Deflation sample domain results')
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_5_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_10_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_15_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','c','LineWidth',2,'LineStyle','--')
    hold on
end
workset=[];
workset=par_set.trail_20_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,2),'Color','g','LineWidth',2,'LineStyle','--')
    hold on
end
xlabel('Index(N)')
xlim([0 10])
ylabel('Chamber Pressure(psi)')
legend('p_{ref}','p_m','Location','northeast')


subplot(2,1,2)
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_5_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_10_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_15_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'c','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_20_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,2),'g','LineWidth',2,'LineStyle','--')
    hold on
end

xlabel('Index(N)')
xlim([0 10])
ylabel('Pressrure Rate (psi/s)')
 
%% Deflation Sample Domain 25 to 0-20 psi
figure('Name','Def Trail overlay 25 psi to 0-20 psi')

subplot(2,1,1)
title('Deflation Time domain results')
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_5_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_10_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_15_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','c','LineWidth',2,'LineStyle','--')
    hold on
end
workset=[];
workset=par_set.trail_20_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_pd_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','m','LineWidth',2)
    hold on
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'Color','g','LineWidth',2,'LineStyle','--')
    hold on
end
xlabel('Time(s)')
xlim([0 10])
ylabel('Chamber Pressure(psi)')
legend('p_{ref}','p_m','Location','northeast')


subplot(2,1,2)
workset=[];
workset=par_set.trail_0_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_5_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_10_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_15_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'c','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail_20_25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'g','LineWidth',2,'LineStyle','--')
    hold on
end

xlabel('Time(s)')
xlim([0 10])
ylabel('Pressrure Rate (psi/s)')
 
%% deflation rate 5-25 to 0 psi
% figure('Name','Def dot_pm vs. p_upstream-p_downstream')
% workset=[];
% workset=par_set.trail_0_25psi;
% for index_num=1:length(workset.def_pd_psi)
%     temp_mat=[];
%     temp_mat=-workset.def_dot_pm_psi{index_num};
%     temp_mat2=-workset.def_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'r')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_20psi;
% for index_num=1:length(workset.def_pd_psi)
%     temp_mat=[];
%     temp_mat=-workset.def_dot_pm_psi{index_num};
%     temp_mat2=-workset.def_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'b')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_15psi;
% for index_num=1:length(workset.def_pd_psi)
%     temp_mat=[];
%     temp_mat=-workset.def_dot_pm_psi{index_num};
%     temp_mat2=-workset.def_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'k')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_10psi;
% for index_num=1:length(workset.def_pd_psi)
%     temp_mat=[];
%     temp_mat=-workset.def_dot_pm_psi{index_num};
%     temp_mat2=-workset.def_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'c')
%     hold on
% end
% 
% workset=[];
% workset=par_set.trail_0_5psi;
% for index_num=1:length(workset.def_pd_psi)
%     temp_mat=[];
%     temp_mat=-workset.def_dot_pm_psi{index_num};
%     temp_mat2=-workset.def_pe_psi{index_num};
%     scatter(temp_mat2(:,2),temp_mat(:,2),'g')
%     hold on
% end
% xlabel('p_{upStream}-p_{downStream}')
% ylabel('Pressrure Rate (psi/s)') 
% title('Deflation pmRate vs. p_{upStream}-p_{downStream}')
end