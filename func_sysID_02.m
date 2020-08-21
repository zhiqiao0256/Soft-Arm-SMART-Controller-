function test_data=func_sysID_02(test_data,par_set)
% test_data=par_set.trial_1_25psi;
% if max(test_data.pd_psi(:,2))>max(test_data.pd_psi(:,3))% p1>p23
%     [val,pos]=findpeaks(test_data.pd_psi(:,2));
% else
%     [val,pos]=findpeaks(test_data.pd_psi(:,3));
% end
trainSet.r_p=par_set.r_p;
%%%%%%%%%%%%%%%
trainSet.pd_psi=test_data.pd_psi;
trainSet.pm_psi=test_data.pm_psi;
trainSet.pd_MPa=test_data.pd_MPa;
trainSet.pm_MPa=test_data.pm_MPa;
trainSet.tip_exp=test_data.tip_exp;
%%%%%%%%%%%%
validSet.pd_psi=test_data.pd_psi;
validSet.pm_psi=test_data.pm_psi;
validSet.pd_MPa=test_data.pd_MPa;
validSet.pm_MPa=test_data.pm_MPa;
validSet.tip_exp=test_data.tip_exp;
fprintf('Dividing trainning set and validation set\n')
%% Estimate Phi b Theta in cam frame
trainSet=func_getPhiThetaBfromXYZ(trainSet,par_set);
validSet=func_getPhiThetaBfromXYZ(validSet,par_set);
%% Augmented Rigid tip Estimation in Base frame
trainSet=func_fwdKinematic(trainSet,par_set);
validSet=func_fwdKinematic(validSet,par_set);
%% least square 
trainSet=func_lestSquareWith5ptFilter(trainSet,par_set);
% trainSet=func_greyBox(trainSet);
test_data.trainSet=trainSet;
test_data.validSet=validSet;
end