%% Sample Code
% x = randn(18,141);
% t = randn(18,141);
% net = feedforwardnet([ 36 36 ]);
% net = train(net,x,t);
% view(net)
%%%%%%%%
%% Initialization
trial=par_set.trail3;
data_length=length(trial.pd_psi);
num_input=3+3+3;
num_output=3+3;
input_data=zeros(data_length,num_input);
output_data=zeros(data_length,num_output);
dt=trial.Ts;
% Assaign data (mm,mm/s,mm/s^2,psi)
mv_windowSize = 3; 
mv_b = (1/mv_windowSize)*ones(1,mv_windowSize);
mv_a = 1;
vel_vec=zeros(data_length,3);
acc_vec=zeros(data_length,3);
vel_vec=filter(mv_b,mv_a,[0 0 0;trial.tip_exp(1:end-1,2:4)-trial.tip_exp(2:end,2:4)]*1000/dt);
acc_vec=filter(mv_b,mv_a,[0 0 0;vel_vec(1:end-1,:)-vel_vec(2:end,:)]*1000/dt);
% input_data=[trial.tip_exp(:,2:4), vel_vec,trial.pd_psi(:,2:4)];
% output_data=[vel_vec,acc_vec];

input_data=[trial.tip_exp(:,2:4), vel_vec,trial.pd_psi(:,2:4)];
output_data=[vel_vec,acc_vec];
figure(1)
plot(input_data)
figure(2)
for i =1:3
    [PSD,freq] = pspectrum(vel_vec(:,i));
    plot(freq/pi,abs(PSD))
    hold on
end
%% NN sturcture
net = feedforwardnet([50 50]);
net.layers{1}.transferFcn='tansig'; 
net.layers{2}.transferFcn ='tansig'; 
net.layers{3}.transferFcn='tansig'; 
net = train(net,input_data',output_data');
view(net)
