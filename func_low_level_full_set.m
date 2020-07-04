function par_set = func_low_level_full_set(par_set)
 fprintf( 'Splitting Inf and Def Process \n' );
workset=[];
workset=par_set.trail_0_25psi;
time_vec=[];
time_vec=workset.pd_psi(:,1);
[value,pos_inf]=findpeaks(workset.pd_psi(:,2));

[value,pos_def]=findpeaks(-workset.pd_psi(:,2));
% Segment inflation process
for index_num=1:size(pos_def,1)
    workset.inf_pd_psi{index_num}=workset.pd_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pd_psi{index_num}=workset.pd_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pm_psi{index_num}=workset.pm_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pm_psi{index_num}=workset.pm_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pe_psi{index_num}=workset.inf_pd_psi{index_num}-workset.inf_pm_psi{index_num};
    workset.inf_pe_psi{index_num}(:,1)=workset.inf_pm_psi{index_num}(:,1);
    workset.def_pe_psi{index_num}=workset.def_pd_psi{index_num}-workset.def_pm_psi{index_num};
    workset.def_pe_psi{index_num}(:,1)=workset.def_pm_psi{index_num}(:,1);
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.def_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];% 5-pt average
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.inf_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];
end
%
par_set.trail_0_25psi=workset;
%

workset=[];
workset=par_set.trail_0_20psi;
time_vec=[];
time_vec=workset.pd_psi(:,1);
[value,pos_inf]=findpeaks(workset.pd_psi(:,2));

[value,pos_def]=findpeaks(-workset.pd_psi(:,2));
% Segment inflation process
for index_num=1:size(pos_def,1)
    workset.inf_pd_psi{index_num}=workset.pd_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pd_psi{index_num}=workset.pd_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pm_psi{index_num}=workset.pm_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pm_psi{index_num}=workset.pm_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pe_psi{index_num}=workset.inf_pd_psi{index_num}-workset.inf_pm_psi{index_num};
    workset.inf_pe_psi{index_num}(:,1)=workset.inf_pm_psi{index_num}(:,1);
    workset.def_pe_psi{index_num}=workset.def_pd_psi{index_num}-workset.def_pm_psi{index_num};
    workset.def_pe_psi{index_num}(:,1)=workset.def_pm_psi{index_num}(:,1);
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.def_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];% 5-pt average
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.inf_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];
end
%
par_set.trail_0_20psi=workset;
%

workset=[];
workset=par_set.trail_0_15psi;
time_vec=[];
time_vec=workset.pd_psi(:,1);
[value,pos_inf]=findpeaks(workset.pd_psi(:,2));

[value,pos_def]=findpeaks(-workset.pd_psi(:,2));
% Segment inflation process
for index_num=1:size(pos_def,1)
    workset.inf_pd_psi{index_num}=workset.pd_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pd_psi{index_num}=workset.pd_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pm_psi{index_num}=workset.pm_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pm_psi{index_num}=workset.pm_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pe_psi{index_num}=workset.inf_pd_psi{index_num}-workset.inf_pm_psi{index_num};
    workset.inf_pe_psi{index_num}(:,1)=workset.inf_pm_psi{index_num}(:,1);
    workset.def_pe_psi{index_num}=workset.def_pd_psi{index_num}-workset.def_pm_psi{index_num};
    workset.def_pe_psi{index_num}(:,1)=workset.def_pm_psi{index_num}(:,1);
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.def_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];% 5-pt average
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.inf_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];
end
%
par_set.trail_0_15psi=workset;
%

workset=[];
workset=par_set.trail_0_10psi;
time_vec=[];
time_vec=workset.pd_psi(:,1);
[value,pos_inf]=findpeaks(workset.pd_psi(:,2));

[value,pos_def]=findpeaks(-workset.pd_psi(:,2));
% Segment inflation process
for index_num=1:size(pos_def,1)
    workset.inf_pd_psi{index_num}=workset.pd_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pd_psi{index_num}=workset.pd_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pm_psi{index_num}=workset.pm_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pm_psi{index_num}=workset.pm_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pe_psi{index_num}=workset.inf_pd_psi{index_num}-workset.inf_pm_psi{index_num};
    workset.inf_pe_psi{index_num}(:,1)=workset.inf_pm_psi{index_num}(:,1);
    workset.def_pe_psi{index_num}=workset.def_pd_psi{index_num}-workset.def_pm_psi{index_num};
    workset.def_pe_psi{index_num}(:,1)=workset.def_pm_psi{index_num}(:,1);
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.def_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];% 5-pt average
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.inf_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];
end
%
par_set.trail_0_10psi=workset;
%

workset=[];
workset=par_set.trail_0_5psi;
time_vec=[];
time_vec=workset.pd_psi(:,1);
[value,pos_inf]=findpeaks(workset.pd_psi(:,2));

[value,pos_def]=findpeaks(-workset.pd_psi(:,2));
% Segment inflation process
for index_num=1:size(pos_def,1)
    workset.inf_pd_psi{index_num}=workset.pd_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pd_psi{index_num}=workset.pd_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pm_psi{index_num}=workset.pm_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pm_psi{index_num}=workset.pm_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pe_psi{index_num}=workset.inf_pd_psi{index_num}-workset.inf_pm_psi{index_num};
    workset.inf_pe_psi{index_num}(:,1)=workset.inf_pm_psi{index_num}(:,1);
    workset.def_pe_psi{index_num}=workset.def_pd_psi{index_num}-workset.def_pm_psi{index_num};
    workset.def_pe_psi{index_num}(:,1)=workset.def_pm_psi{index_num}(:,1);
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.def_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];% 5-pt average
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.inf_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];
end
%
par_set.trail_0_5psi=workset;

workset=[];
workset=par_set.trail_5_25psi;
time_vec=[];
time_vec=workset.pd_psi(:,1);
[value,pos_inf]=findpeaks(workset.pd_psi(:,2));

[value,pos_def]=findpeaks(-workset.pd_psi(:,2));
% Segment inflation process
for index_num=1:size(pos_def,1)
    workset.inf_pd_psi{index_num}=workset.pd_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pd_psi{index_num}=workset.pd_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pm_psi{index_num}=workset.pm_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pm_psi{index_num}=workset.pm_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pe_psi{index_num}=workset.inf_pd_psi{index_num}-workset.inf_pm_psi{index_num};
    workset.inf_pe_psi{index_num}(:,1)=workset.inf_pm_psi{index_num}(:,1);
    workset.def_pe_psi{index_num}=workset.def_pd_psi{index_num}-workset.def_pm_psi{index_num};
    workset.def_pe_psi{index_num}(:,1)=workset.def_pm_psi{index_num}(:,1);
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.def_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];% 5-pt average
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.inf_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];
end
%
par_set.trail_5_25psi=workset;
%

workset=[];
workset=par_set.trail_10_25psi;
time_vec=[];
time_vec=workset.pd_psi(:,1);
[value,pos_inf]=findpeaks(workset.pd_psi(:,2));

[value,pos_def]=findpeaks(-workset.pd_psi(:,2));
% Segment inflation process
for index_num=1:size(pos_def,1)
    workset.inf_pd_psi{index_num}=workset.pd_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pd_psi{index_num}=workset.pd_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pm_psi{index_num}=workset.pm_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pm_psi{index_num}=workset.pm_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pe_psi{index_num}=workset.inf_pd_psi{index_num}-workset.inf_pm_psi{index_num};
    workset.inf_pe_psi{index_num}(:,1)=workset.inf_pm_psi{index_num}(:,1);
    workset.def_pe_psi{index_num}=workset.def_pd_psi{index_num}-workset.def_pm_psi{index_num};
    workset.def_pe_psi{index_num}(:,1)=workset.def_pm_psi{index_num}(:,1);
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.def_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];% 5-pt average
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.inf_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];
end
%
par_set.trail_10_25psi=workset;
%

workset=[];
workset=par_set.trail_15_25psi;
time_vec=[];
time_vec=workset.pd_psi(:,1);
[value,pos_inf]=findpeaks(workset.pd_psi(:,2));

[value,pos_def]=findpeaks(-workset.pd_psi(:,2));
% Segment inflation process
for index_num=1:size(pos_def,1)
    workset.inf_pd_psi{index_num}=workset.pd_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pd_psi{index_num}=workset.pd_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pm_psi{index_num}=workset.pm_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pm_psi{index_num}=workset.pm_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pe_psi{index_num}=workset.inf_pd_psi{index_num}-workset.inf_pm_psi{index_num};
    workset.inf_pe_psi{index_num}(:,1)=workset.inf_pm_psi{index_num}(:,1);
    workset.def_pe_psi{index_num}=workset.def_pd_psi{index_num}-workset.def_pm_psi{index_num};
    workset.def_pe_psi{index_num}(:,1)=workset.def_pm_psi{index_num}(:,1);
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.def_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];% 5-pt average
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.inf_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];
end
%
par_set.trail_15_25psi=workset;
%
workset=[];
workset=par_set.trail_20_25psi;
time_vec=[];
time_vec=workset.pd_psi(:,1);
[value,pos_inf]=findpeaks(workset.pd_psi(:,2));

[value,pos_def]=findpeaks(-workset.pd_psi(:,2));
% Segment inflation process
for index_num=1:size(pos_def,1)
    workset.inf_pd_psi{index_num}=workset.pd_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pd_psi{index_num}=workset.pd_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pm_psi{index_num}=workset.pm_psi(pos_inf(index_num):pos_def(index_num)-2,1:2);
    workset.def_pm_psi{index_num}=workset.pm_psi(pos_def(index_num):pos_inf(index_num+1)-2,1:2);
    workset.inf_pe_psi{index_num}=workset.inf_pd_psi{index_num}-workset.inf_pm_psi{index_num};
    workset.inf_pe_psi{index_num}(:,1)=workset.inf_pm_psi{index_num}(:,1);
    workset.def_pe_psi{index_num}=workset.def_pd_psi{index_num}-workset.def_pm_psi{index_num};
    workset.def_pe_psi{index_num}(:,1)=workset.def_pm_psi{index_num}(:,1);
    temp_mat=[];
    temp_mat=workset.def_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.def_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];% 5-pt average
    temp_mat=[];
    temp_mat=workset.inf_pm_psi{index_num};
    temp_result=[0;(temp_mat(2:end,2)-temp_mat(1:end-1,2))/workset.Ts];
    workset.inf_dot_pm_psi{index_num}=[temp_mat(:,1),smooth(temp_result)];
end
%
par_set.trail_20_25psi=workset;
%
fprintf( 'Splitted Inf and Def \n' );
end
%
