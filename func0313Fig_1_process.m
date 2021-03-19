function par_set=func0313Fig_1_process(par_set)
%% Find start and end pts
testData= par_set.trial1;
fp=figure('Name','ramp','Position',[100,100,600,800]);
plot(testData.xd_exp(:,2))
s_pt=403;e_pt=2402;
fp=figure('Name','fig1','Position',[100,100,800,400]);
subplot(2,1,1)
plot(testData.xd_exp(s_pt:e_pt,1)-testData.xd_exp(s_pt,1),testData.xd_exp(s_pt:e_pt,2),'r')
hold on
plot(testData.x1_exp(s_pt:e_pt,1),testData.x1_exp(s_pt:e_pt,2),'b')
hold on
plot(testData.x1_exp(s_pt:e_pt,1),testData.xdNew(s_pt:e_pt),'k')
end
