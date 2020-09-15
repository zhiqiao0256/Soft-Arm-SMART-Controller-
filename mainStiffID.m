%% Main function for stiffness ID use data 0722
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
par_set.flag_plot_movingCC =0;
%flag for plotting fwd kinematic results
par_set.plot_fwdKinematic =0;
% Check data readme.txt for detail input reference
par_set.trial1=[];
par_set.trial2=[];
par_set.trial3=[];
par_set.trial4=[];
par_set.trial5=[];
par_set.trial6=[];
par_set.trial7=[];
par_set.trial8=[];
par_set.trial9=[];



% Geometric para.
par_set.trianlge_length=70*1e-03;% fabric triangle edge length
par_set.L=0.19;%actuator length
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
    par_set.trial1=func_high_level_exp(par_set.trial1,1);
    par_set.trial2=func_high_level_exp(par_set.trial2,2);
    par_set.trial3=func_high_level_exp(par_set.trial3,3);
    par_set.trial4=func_high_level_exp(par_set.trial4,4);
    par_set.trial5=func_high_level_exp(par_set.trial5,5);
    par_set.trial6=func_high_level_exp(par_set.trial6,6);
    par_set.trial7=func_high_level_exp(par_set.trial7,7);
    par_set.trial8=func_high_level_exp(par_set.trial8,8);
    par_set.trial9=func_high_level_exp(par_set.trial9,9);

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
%% crossValidation MPa
testData=par_set.trial1;
testData2=par_set.trial2;
funcCompareTwoGreyBoxModelMPa(testData,testData2)

testData2=par_set.trial3;
funcCompareTwoGreyBoxModelMPa(testData,testData2)

testData2=par_set.trial4;
funcCompareTwoGreyBoxModelMPa(testData,testData2)

testData2=par_set.trial5;
funcCompareTwoGreyBoxModelMPa(testData,testData2)

%% parameter distribution Mpa
figure
subplot(3,1,1)
plot([par_set.trial1.pi_grey(1);par_set.trial2.pi_grey(1);par_set.trial3.pi_grey(1);par_set.trial4.pi_grey(1);par_set.trial5.pi_grey(1);...
                par_set.trial6.pi_grey(1);par_set.trial7.pi_grey(1);par_set.trial8.pi_grey(1);par_set.trial9.pi_grey(1);],'o');
ylabel('\alpha')
subplot(3,1,2)
plot([par_set.trial1.pi_grey(2);par_set.trial2.pi_grey(2);par_set.trial3.pi_grey(2);par_set.trial4.pi_grey(2);par_set.trial5.pi_grey(2);...
                par_set.trial6.pi_grey(2);par_set.trial7.pi_grey(2);par_set.trial8.pi_grey(2);par_set.trial9.pi_grey(2);],'o');
ylabel('k')
subplot(3,1,3)
plot([par_set.trial1.pi_grey(3);par_set.trial2.pi_grey(3);par_set.trial3.pi_grey(3);par_set.trial4.pi_grey(3);par_set.trial5.pi_grey(3);...
                par_set.trial6.pi_grey(3);par_set.trial7.pi_grey(3);par_set.trial8.pi_grey(3);par_set.trial9.pi_grey(3);],'o');
ylabel('b')

%% Average Model MPa
meanAlpha=mean([par_set.trial1.pi_grey(1);par_set.trial2.pi_grey(1);par_set.trial3.pi_grey(1);par_set.trial4.pi_grey(1);par_set.trial5.pi_grey(1);...
                par_set.trial6.pi_grey(1);par_set.trial7.pi_grey(1);par_set.trial8.pi_grey(1);par_set.trial9.pi_grey(1);]);
meanK=    mean([par_set.trial1.pi_grey(2);par_set.trial2.pi_grey(2);par_set.trial3.pi_grey(2);par_set.trial4.pi_grey(2);par_set.trial5.pi_grey(2);...
                par_set.trial6.pi_grey(2);par_set.trial7.pi_grey(2);par_set.trial8.pi_grey(2);par_set.trial9.pi_grey(2);]);
meanB=    mean([par_set.trial1.pi_grey(3);par_set.trial2.pi_grey(3);par_set.trial3.pi_grey(3);par_set.trial4.pi_grey(3);par_set.trial5.pi_grey(3);...
                par_set.trial6.pi_grey(3);par_set.trial7.pi_grey(3);par_set.trial8.pi_grey(3);par_set.trial9.pi_grey(3);]);
avgModel.pi_grey=[meanAlpha,meanK,meanB];
testData2=par_set.trial1;
funcCompareAverageModel(avgModel,testData2);
testData2=par_set.trial2;
funcCompareAverageModel(avgModel,testData2);
testData2=par_set.trial3;
funcCompareAverageModel(avgModel,testData2);
testData2=par_set.trial4;
funcCompareAverageModel(avgModel,testData2);
testData2=par_set.trial5;
funcCompareAverageModel(avgModel,testData2);
testData2=par_set.trial6;
funcCompareAverageModel(avgModel,testData2);
testData2=par_set.trial7;
funcCompareAverageModel(avgModel,testData2);
testData2=par_set.trial8;
funcCompareAverageModel(avgModel,testData2);
testData2=par_set.trial9;
funcCompareAverageModel(avgModel,testData2);
%% CrossValidation psi
testData2=par_set.trial2;
% testData2=func_getPhiThetaBfromXYZ(testData2,par_set); 
% testData2= func3ptFilter(testData2);
funcCompareTwoGreyBoxModel(testData,testData2);

testData2=par_set.trial3;
testData2=func_getPhiThetaBfromXYZ(testData2,par_set); 
testData2= func3ptFilter(testData2);
funcCompareTwoGreyBoxModel(testData,testData2);

testData2=par_set.trial4;
testData2=func_getPhiThetaBfromXYZ(testData2,par_set); 
testData2= func3ptFilter(testData2);
funcCompareTwoGreyBoxModel(testData,testData2);

testData2=par_set.trial5;
testData2=func_getPhiThetaBfromXYZ(testData2,par_set); 
testData2= func3ptFilter(testData2);
funcCompareTwoGreyBoxModel(testData,testData2);
%% parameter distribution
figure
subplot(3,1,1)
plot([par_set.trail1.pi_grey(1);par_set.trail2.pi_grey(1);par_set.trail3.pi_grey(1);par_set.trail4.pi_grey(1);par_set.trail5.pi_grey(1);],'o');
ylabel('\alpha')
subplot(3,1,2)
plot([par_set.trail1.pi_grey(2);par_set.trail2.pi_grey(2);par_set.trail3.pi_grey(2);par_set.trail4.pi_grey(2);par_set.trail5.pi_grey(2);],'o');
ylabel('k')
subplot(3,1,3)
plot([par_set.trail1.pi_grey(3);par_set.trail2.pi_grey(3);par_set.trail3.pi_grey(3);par_set.trail4.pi_grey(3);par_set.trail5.pi_grey(3);],'o');
ylabel('b')
%% Average Model
meanAlpha=mean([par_set.trail1.pi_grey(1);par_set.trail2.pi_grey(1);par_set.trail3.pi_grey(1);par_set.trail4.pi_grey(1);par_set.trail5.pi_grey(1);]);
meanK=mean([par_set.trail1.pi_grey(2);par_set.trail2.pi_grey(2);par_set.trail3.pi_grey(2);par_set.trail4.pi_grey(2);par_set.trail5.pi_grey(2);]);
meanB=mean([par_set.trail1.pi_grey(3);par_set.trail2.pi_grey(3);par_set.trail3.pi_grey(3);par_set.trail4.pi_grey(3);par_set.trail5.pi_grey(3);]);
avgModel.pi_grey=[meanAlpha,meanK,meanB];
testData2=par_set.trail1;
funcCompareTwoGreyBoxModel(avgModel,testData2);
testData2=par_set.trail2;
funcCompareTwoGreyBoxModel(avgModel,testData2);
testData2=par_set.trail3;
funcCompareTwoGreyBoxModel(avgModel,testData2);
testData2=par_set.trail4;
funcCompareTwoGreyBoxModel(avgModel,testData2);
testData2=par_set.trail5;
funcCompareTwoGreyBoxModel(avgModel,testData2);
%% Full Model
nlgr=funcBuildFullModel();
testData=[];
testData=par_set.trial1;