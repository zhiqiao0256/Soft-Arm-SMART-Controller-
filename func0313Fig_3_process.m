function par_set=func0313Fig_3_process(par_set)
%% Find start and end pts
testData= par_set.trial1;
fp=figure('Name','ramp','Position',[100,100,600,800]);
plot(testData.xd_exp(:,2))
s_pt=403;e_pt=2402;
end
