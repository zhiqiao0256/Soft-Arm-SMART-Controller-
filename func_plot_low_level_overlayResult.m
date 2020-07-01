function []=func_plot_low_level_overlayResult(par_set)
 fprintf( 'Plotting \n' );
%
figure('Name','Inf Trail overlay')
subplot(2,1,1)
title('Inflation Time domain results')
workset=[];
workset=par_set.trail25psi;
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
workset=par_set.trail20psi;
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
workset=par_set.trail15psi;
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
workset=par_set.trail10psi;
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
workset=par_set.trail5psi;
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
workset=par_set.trail25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail20psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail15psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail10psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'c','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail5psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'g','LineWidth',2,'LineStyle','--')
    hold on
end

xlabel('Time(s)')
xlim([0 10])
ylabel('Pressrure Rate (psi/s)')
  
%%
figure('Name','Inf dot_pm vs. p_upstream-p_downstream')
workset=[];
workset=par_set.trail25psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    temp_mat2=workset.inf_pe_psi{index_num};
    scatter(temp_mat2(:,2),temp_mat(:,2),'r')
    hold on
end

workset=[];
workset=par_set.trail20psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    temp_mat2=workset.inf_pe_psi{index_num};
    scatter(temp_mat2(:,2),temp_mat(:,2),'b')
    hold on
end

workset=[];
workset=par_set.trail15psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    temp_mat2=workset.inf_pe_psi{index_num};
    scatter(temp_mat2(:,2),temp_mat(:,2),'k')
    hold on
end

workset=[];
workset=par_set.trail10psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    temp_mat2=workset.inf_pe_psi{index_num};
    scatter(temp_mat2(:,2),temp_mat(:,2),'c')
    hold on
end

workset=[];
workset=par_set.trail5psi;
for index_num=1:length(workset.inf_pd_psi)
    temp_mat=[];
    temp_mat=workset.inf_dot_pm_psi{index_num};
    temp_mat2=workset.inf_pe_psi{index_num};
    scatter(temp_mat2(:,2),temp_mat(:,2),'g')
    hold on
end
xlabel('p_{upStream}-p_{downStream} (psi)')
ylabel('Pressrure Rate (psi/s)')
title('Deflation pmRate vs. p_{upStream}-p_{downStream}') 
%%
%
figure('Name','Def Trail overlay')

subplot(2,1,1)
title('Deflation Time domain results')
workset=[];
workset=par_set.trail25psi;
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
workset=par_set.trail20psi;
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
workset=par_set.trail15psi;
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
workset=par_set.trail10psi;
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
workset=par_set.trail5psi;
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
workset=par_set.trail25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'r','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail20psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'b','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail15psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'k','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail10psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'c','LineWidth',2,'LineStyle','--')
    hold on
end

workset=[];
workset=par_set.trail5psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=workset.def_dot_pm_psi{index_num};
    plot(temp_mat(:,1)-temp_mat(1,1),temp_mat(:,2),'g','LineWidth',2,'LineStyle','--')
    hold on
end

xlabel('Time(s)')
xlim([0 10])
ylabel('Pressrure Rate (psi/s)')
 
 
%%
figure('Name','Def dot_pm vs. p_upstream-p_downstream')
workset=[];
workset=par_set.trail25psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=-workset.def_dot_pm_psi{index_num};
    temp_mat2=-workset.def_pe_psi{index_num};
    scatter(temp_mat2(:,2),temp_mat(:,2),'r')
    hold on
end

workset=[];
workset=par_set.trail20psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=-workset.def_dot_pm_psi{index_num};
    temp_mat2=-workset.def_pe_psi{index_num};
    scatter(temp_mat2(:,2),temp_mat(:,2),'b')
    hold on
end

workset=[];
workset=par_set.trail15psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=-workset.def_dot_pm_psi{index_num};
    temp_mat2=-workset.def_pe_psi{index_num};
    scatter(temp_mat2(:,2),temp_mat(:,2),'k')
    hold on
end

workset=[];
workset=par_set.trail10psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=-workset.def_dot_pm_psi{index_num};
    temp_mat2=-workset.def_pe_psi{index_num};
    scatter(temp_mat2(:,2),temp_mat(:,2),'c')
    hold on
end

workset=[];
workset=par_set.trail5psi;
for index_num=1:length(workset.def_pd_psi)
    temp_mat=[];
    temp_mat=-workset.def_dot_pm_psi{index_num};
    temp_mat2=-workset.def_pe_psi{index_num};
    scatter(temp_mat2(:,2),temp_mat(:,2),'g')
    hold on
end
xlabel('p_{upStream}-p_{downStream}')
ylabel('Pressrure Rate (psi/s)') 
title('Deflation pmRate vs. p_{upStream}-p_{downStream}') 
end