function testData=funcGreyBoxSysID(testData,par_set)
testData=func_getPhiThetaBfromXYZ(testData,par_set);    % get phi,theta,r0
testData= func3ptFilter(testData);  % get d_phi d_theta
nlgr =funcBuildGreyBox();   % get grey box model
%%%% Estimation Options
opt = nlgreyestOptions;
opt.Display='on';
opt.SearchOptions.MaxIterations = 20;
opt.SearchMethod='lsqnonlin';

%%%% Input Output Data
    z=iddata([testData.theta_rad,testData.velocity_theta_rad],...
        [testData.pm_psi(:,2:4),testData.beta,testData.phi_rad],0.05);
    set(z,  'InputName', {'Pm1','Pm2','Pm3','r_0','Phi'}, ...
            'InputUnit', {'psi','psi','psi','m','rad'},               ...
            'OutputName', {'Angular position','vel'}, ...
            'OutputUnit', {'rad','rad/s'},                         ...
            'TimeUnit', 's');
    test_x=[testData.theta_rad,testData.velocity_theta_rad]';
    test_x0=test_x(:,1);
    
    figure
    h_gcf = gcf;
    set(h_gcf,'DefaultLegendLocation','southeast');
    h_gcf.Position = [100 100 795 634];
for i = 1:z.Nu
   subplot(z.Nu, 1, i);
   plot(z.SamplingInstants, z.InputData(:,i));
   title(['Input #' num2str(i) ': ' z.InputName{i}]);
   xlabel('');
   axis tight;
end
    xlabel([z.Domain ' (' z.TimeUnit ')']);
    
    figure
    h_gcf = gcf;
    set(h_gcf,'DefaultLegendLocation','southeast');
    h_gcf.Position = [100 100 795 634];
for i = 1:z.Ny
   subplot(z.Ny, 1, i);
   plot(z.SamplingInstants, z.OutputData(:,i));
   title(['Output #' num2str(i) ': ' z.OutputName{i}]);
   xlabel('');
   axis tight;
end
xlabel([z.Domain ' (' z.TimeUnit ')']);
%%%% Estimate
figure
nlgr1=nlgr;
compare(z,nlgr1)
fprintf('Estimating\n')
% % opt = nlgreyestOptions('Display','off');
% nlgr1 = nlgreyest(z,nlgr1,opt);
% %%
% figure
% compare(z,nlgr1)
% figure
% pe(z, nlgr1);
% test_data.pi_grey=[nlgreyModel.Parameters(1).Value,nlgreyModel.Parameters(2).Value,nlgreyModel.Parameters(3).Value];
% fprintf('Estimated [alpha,k,d] is [%.4f,%.4f,%.4f] \n',test_data.pi_grey(1),test_data.pi_grey(2),test_data.pi_grey(3))
end