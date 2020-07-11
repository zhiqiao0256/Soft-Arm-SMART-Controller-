function par = func_alignCameraFrameWithBaseFrame(par,Rz)

    temp_data=[];par.tip_exp_rotated=[];
    temp_data=par.tip_exp(:,2:4)';
    par.tip_exp_rotated(:,1)=par.tip_exp(:,1);
    par.tip_exp_rotated(:,2:4)=[Rz*temp_data]';
end