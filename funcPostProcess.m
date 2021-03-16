function testData = funcPostProcess(testData)
%%%% RMSE
x_i=[];x_i_est=[];
x_i=testData.xd_exp(:,2);
x_i_est=testData.x1_exp(:,2);
testData.rmse=sqrt(sum((x_i-x_i_est).^2)/length(x_i));
%%%% Energy of input signal
u_i=[];
u_i=testData.pd_MPa(:,1);
testData.inputEnergy=sum(u_i.^2);
fprintf( 'RMSE %d and InputEnergy %d \n',testData.rmse,testData.inputEnergy)

