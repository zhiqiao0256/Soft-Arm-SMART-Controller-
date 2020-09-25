%% Main function for stiffness ID use data 0722
%%% Major chanages:
%%%
clear all
close all
clc
%% Initialize the system
par_set=[];
%flag for EOM deriviation
par_set.EOM=0;
%flag for plot
par_set.flag_plot_rawData = 0;
%flag for read txt file or mat file 1: txt 0: mat
par_set.flag_read_exp = 1;
%flag for plotting moving constant layer
par_set.flag_plot_movingCC = 0;
%flag for plotting fwd kinematic results
par_set.plot_fwdKinematic = 0;
% Check data readme.txt for detail input reference
par_set.Ts=1/40;
% Geometric para.
par_set.trianlge_length=70*1e-03;% fabric triangle edge length
par_set.L=0.17;%actuator length
par_set.n=4;% # of joints for augmented rigid arm
par_set.m0=0.35;%kg segment weight
par_set.g=9.8;%% gravity constant
par_set.a0=15*1e-03;%% 1/2 of pillow width
par_set.r_f=sqrt(3)/6*par_set.trianlge_length+par_set.a0; % we assume the force are evenly spread on a cirlce with radius of r_f
%% Update location of 3 chambers P1, P2, P3
par_set.p1_angle=-150;%deg p1 position w/ the base frame
% update force position of p1 p2 and p3
for i =1:3
    par_set.r_p{i}=[par_set.r_f*cosd(par_set.p1_angle+120*(i-1)),par_set.r_f*sind(par_set.p1_angle+120*(i-1)),0].';
%     par_set.f_p{i}=588.31*par_set.pm_MPa(:,i+1);
end
fprintf('System initialization done \n')
%% Read txt file or mat file
if par_set.flag_read_exp==1
    par_set=funcHighLevelExp100Hz(par_set,1);
    par_set=funcHighLevelExp100Hz(par_set,2);
    par_set=funcHighLevelExp100Hz(par_set,3);
    par_set=funcHighLevelExp100Hz(par_set,4);
    par_set=funcHighLevelExp100Hz(par_set,5);
    par_set=funcHighLevelExp100Hz(par_set,6);
    par_set=funcHighLevelExp100Hz(par_set,7);
    par_set=funcHighLevelExp100Hz(par_set,8);
    par_set=funcHighLevelExp100Hz(par_set,9);
    par_set=funcHighLevelExp100Hz(par_set,10);
    par_set=funcHighLevelExp100Hz(par_set,11);
    par_set=funcHighLevelExp100Hz(par_set,12);
    par_set=funcHighLevelExp100Hz(par_set,13);
    par_set=funcHighLevelExp100Hz(par_set,14);
    par_set=funcHighLevelExp100Hz(par_set,15);
    save('raw_id_data.mat','par_set');
    fprintf( 'Saved \n' )
else
    fprintf( 'Loading... \n' );
    load('raw_id_data.mat');
    fprintf( 'Data loaded \n' );
end
%% Symbolic EOM
if par_set.EOM==1
    par_set=func_EOM_baseFrame(par_set);
end
%% Grey-box system ID
testData=[];
testData=par_set.trial1;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial1=testData;

testData=[];
testData=par_set.trial2;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial2=testData;

testData=[];
testData=par_set.trial3;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial3=testData;

testData=[];
testData=par_set.trial4;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial4=testData;

testData=[];
testData=par_set.trial5;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial5=testData;

testData=[];
testData=par_set.trial6;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial6=testData;

testData=[];
testData=par_set.trial7;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial7=testData;

testData=[];
testData=par_set.trial8;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial8=testData;

testData=[];
testData=par_set.trial9;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial9=testData;

testData=[];
testData=par_set.trial10;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial10=testData;

testData=[];
testData=par_set.trial11;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial11=testData;

testData=[];
testData=par_set.trial12;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial12=testData;

testData=[];
testData=par_set.trial13;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial13=testData;

testData=[];
testData=par_set.trial14;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial14=testData;

testData=[];
testData=par_set.trial15;
testData=funcGreyBoxSysID(testData,par_set);
% testData=func_greyBox(testData);
par_set.trial15=testData;

beep;
%% crossValidation MPa
testData=par_set.trial2;
testData2=par_set.trial1;

funcCompareTwoGreyBoxModelMPa(testData,testData2)

testData2=par_set.trial7;
funcCompareTwoGreyBoxModelMPa(testData,testData2)

testData2=par_set.trial3;
funcCompareTwoGreyBoxModelMPa(testData,testData2)

testData2=par_set.trial5;
funcCompareTwoGreyBoxModelMPa(testData,testData2)

%% parameter distribution Mpa
% figure
% subplot(3,1,1)
% plot([par_set.trial1.pi_grey(1);par_set.trial2.pi_grey(1);par_set.trial3.pi_grey(1);par_set.trial4.pi_grey(1);par_set.trial5.pi_grey(1);...
%                 par_set.trial6.pi_grey(1);par_set.trial7.pi_grey(1);par_set.trial8.pi_grey(1);par_set.trial9.pi_grey(1);],'o');
% ylabel('\alpha')
% subplot(3,1,2)
% plot([par_set.trial1.pi_grey(2);par_set.trial2.pi_grey(2);par_set.trial3.pi_grey(2);par_set.trial4.pi_grey(2);par_set.trial5.pi_grey(2);...
%                 par_set.trial6.pi_grey(2);par_set.trial7.pi_grey(2);par_set.trial8.pi_grey(2);par_set.trial9.pi_grey(2);],'o');
% ylabel('k')
% subplot(3,1,3)
% plot([par_set.trial1.pi_grey(3);par_set.trial2.pi_grey(3);par_set.trial3.pi_grey(3);par_set.trial4.pi_grey(3);par_set.trial5.pi_grey(3);...
%                 par_set.trial6.pi_grey(3);par_set.trial7.pi_grey(3);par_set.trial8.pi_grey(3);par_set.trial9.pi_grey(3);],'o');
% ylabel('b')

% %% Average Model MPa
% meanAlpha=mean([par_set.trial1.pi_grey(1);par_set.trial2.pi_grey(1);par_set.trial3.pi_grey(1);par_set.trial4.pi_grey(1);par_set.trial5.pi_grey(1);...
%                 par_set.trial6.pi_grey(1);par_set.trial7.pi_grey(1);par_set.trial8.pi_grey(1);par_set.trial9.pi_grey(1);]);
% meanK=    mean([par_set.trial1.pi_grey(2);par_set.trial2.pi_grey(2);par_set.trial3.pi_grey(2);par_set.trial4.pi_grey(2);par_set.trial5.pi_grey(2);...
%                 par_set.trial6.pi_grey(2);par_set.trial7.pi_grey(2);par_set.trial8.pi_grey(2);par_set.trial9.pi_grey(2);]);
% meanB=    mean([par_set.trial1.pi_grey(3);par_set.trial2.pi_grey(3);par_set.trial3.pi_grey(3);par_set.trial4.pi_grey(3);par_set.trial5.pi_grey(3);...
%                 par_set.trial6.pi_grey(3);par_set.trial7.pi_grey(3);par_set.trial8.pi_grey(3);par_set.trial9.pi_grey(3);]);
% avgModel.pi_grey=[meanAlpha,meanK,meanB];
% testData2=par_set.trial1;
% funcCompareAverageModel(avgModel,testData2);
% testData2=par_set.trial2;
% funcCompareAverageModel(avgModel,testData2);
% testData2=par_set.trial3;
% funcCompareAverageModel(avgModel,testData2);
% testData2=par_set.trial4;
% funcCompareAverageModel(avgModel,testData2);
% testData2=par_set.trial5;
% funcCompareAverageModel(avgModel,testData2);
% testData2=par_set.trial6;
% funcCompareAverageModel(avgModel,testData2);
% testData2=par_set.trial7;
% funcCompareAverageModel(avgModel,testData2);
% testData2=par_set.trial8;
% funcCompareAverageModel(avgModel,testData2);
% testData2=par_set.trial9;
% funcCompareAverageModel(avgModel,testData2);

%% bar plot for SMC
par_set.allAlpha=([par_set.trial1.pi_grey(1);par_set.trial2.pi_grey(1);par_set.trial3.pi_grey(1);...
                par_set.trial4.pi_grey(1);par_set.trial5.pi_grey(1);par_set.trial6.pi_grey(1);...
                par_set.trial7.pi_grey(1);par_set.trial8.pi_grey(1);par_set.trial9.pi_grey(1);...
                par_set.trial10.pi_grey(1);par_set.trial11.pi_grey(1);par_set.trial12.pi_grey(1);...
                par_set.trial13.pi_grey(1);par_set.trial14.pi_grey(1);par_set.trial15.pi_grey(1);]);
            
par_set.allK=([par_set.trial1.pi_grey(2);par_set.trial2.pi_grey(2);par_set.trial3.pi_grey(2);...
            par_set.trial4.pi_grey(2);par_set.trial5.pi_grey(2);par_set.trial6.pi_grey(2);...
            par_set.trial7.pi_grey(2);par_set.trial8.pi_grey(2);par_set.trial9.pi_grey(2);...
            par_set.trial10.pi_grey(2);par_set.trial11.pi_grey(2);par_set.trial12.pi_grey(2);...
            par_set.trial13.pi_grey(2);par_set.trial14.pi_grey(2);par_set.trial15.pi_grey(2);]);
        
par_set.allB=([par_set.trial1.pi_grey(3);par_set.trial2.pi_grey(3);par_set.trial3.pi_grey(3);...
            par_set.trial4.pi_grey(3);par_set.trial5.pi_grey(3);par_set.trial6.pi_grey(3);...
            par_set.trial7.pi_grey(3);par_set.trial8.pi_grey(3);par_set.trial9.pi_grey(3);...
            par_set.trial10.pi_grey(3);par_set.trial11.pi_grey(3);par_set.trial12.pi_grey(3);...
            par_set.trial13.pi_grey(3);par_set.trial14.pi_grey(3);par_set.trial15.pi_grey(3);]);

par_set.allAlpha2=([par_set.trial1.pi_grey2(1);par_set.trial2.pi_grey2(1);par_set.trial3.pi_grey2(1);...
                par_set.trial4.pi_grey2(1);par_set.trial5.pi_grey2(1);par_set.trial6.pi_grey2(1);...
                par_set.trial7.pi_grey2(1);par_set.trial8.pi_grey2(1);par_set.trial9.pi_grey2(1);...
                par_set.trial10.pi_grey2(1);par_set.trial11.pi_grey2(1);par_set.trial12.pi_grey2(1);...
                par_set.trial13.pi_grey2(1);par_set.trial14.pi_grey2(1);par_set.trial15.pi_grey2(1);]);
            
par_set.allK2=([par_set.trial1.pi_grey2(2);par_set.trial2.pi_grey2(2);par_set.trial3.pi_grey2(2);...
            par_set.trial4.pi_grey2(2);par_set.trial5.pi_grey2(2);par_set.trial6.pi_grey2(2);...
            par_set.trial7.pi_grey2(2);par_set.trial8.pi_grey2(2);par_set.trial9.pi_grey2(2);...
            par_set.trial10.pi_grey2(2);par_set.trial11.pi_grey2(2);par_set.trial12.pi_grey2(2);...
            par_set.trial13.pi_grey2(2);par_set.trial14.pi_grey2(2);par_set.trial15.pi_grey2(2);]);
        
par_set.allB2=([par_set.trial1.pi_grey2(3);par_set.trial2.pi_grey2(3);par_set.trial3.pi_grey2(3);...
            par_set.trial4.pi_grey2(3);par_set.trial5.pi_grey2(3);par_set.trial6.pi_grey2(3);...
            par_set.trial7.pi_grey2(3);par_set.trial8.pi_grey2(3);par_set.trial9.pi_grey2(3);...
            par_set.trial10.pi_grey2(3);par_set.trial11.pi_grey2(3);par_set.trial12.pi_grey2(3);...
            par_set.trial13.pi_grey2(3);par_set.trial14.pi_grey2(3);par_set.trial15.pi_grey2(3);]);        
x1=[par_set.allK;par_set.allK2];
SEM = std(x1)/sqrt(length(x1));               % Standard Error
ts = tinv([0.025  0.975],length(x1)-1);% T-Score
CI951 = max(ts*SEM);% Confidence Intervals
CI951=mean(x1)-std(x1)*1.96/sqrt(length(x1));
meanK=mean(x1);

x2=[par_set.allB;par_set.allB2];
SEM = std(x2)/sqrt(length(x2));               % Standard Error
ts = tinv([0.025  0.975],length(x2)-1);% T-Score
CI952 =max(ts*SEM);% Confidence Intervals
CI952=mean(x2)-std(x2)*1.96/sqrt(length(x2));
meanB=mean(x2);

x3=[par_set.allAlpha;par_set.allAlpha2];
SEM = std(x3)/sqrt(length(x3));               % Standard Error
ts = tinv([0.025  0.975],length(x3)-1);% T-Score
CI953 =max(ts*SEM);% Confidence Intervals
CI953=mean(x3)-std(x3)*1.96/sqrt(length(x3));
meanAlpha=mean(x3);
%% CI95%
fp=figure('Position',[100,100,600,300]);
f3=plot(1,x1,'k*');
        hold on
plot(2,x2,'k*')
        hold on
plot(3,x3,'k*')
        hold on
        
f1=plot([1,2,3],[mean(x1),mean(x2),mean(x3)],'r*');
f1.LineWidth=4;
hold on
f2=errorbar(1,[mean(x1)],[CI951],'b');
f2.LineWidth=1.5;
f2.CapSize=40;
hold on
f2=errorbar(2,[mean(x2)],[CI952],'b');
f2.LineWidth=1.5;
f2.CapSize=40;
hold on
f2=errorbar(3,[mean(x3)],[CI953],'b');
f2.LineWidth=1.5;
f2.CapSize=40;
hold on
legend([f1,f2,f3(1)],'mean','95%CI','sample','Location','northwest')
xlim([0.5,3.5])
xticks([1,2,3])
xticklabels({'k','b','\alpha'})
fp.CurrentAxes.FontWeight='Bold';
fp.CurrentAxes.FontSize=16;
% ylim([0,2])
% for i =1:length(x1)
%     if x1(i)<mean(x1)-CI951 || x1(i)>mean(x1)+CI951
%         plot(1,x1(i),'ko')
%         hold on
%     end
% end
% for i =1:length(x2)
%     if x2(i)<mean(x2)-CI952 || x2(i)>mean(x2)+CI952
%         plot(2,x2(i),'ko')
%         hold on
%     end
% end
% for i =1:length(x3)
%     if x3(i)<mean(x3)-CI953 || x3(i)>mean(x3)+CI953
%         plot(3,x3(i),'ko')
%         hold on
%     end
% end

figure
subplot(3,1,1)
histogram(x1)
subplot(3,1,2)
histogram(x2)
subplot(3,1,3)
histogram(x3)