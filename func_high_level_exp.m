function par = func_high_level_exp( par , exp_case )
fprintf( 'Loading exp. data %d ... \n',exp_case )
switch exp_case
	case 1
		set1=importdata('data_collect_1.txt');
    case 2
        set1=importdata('data_collect_2.txt');
    case 3
        set1=importdata('data_collect_3.txt');
     case 4
        set1=importdata('data_collect_4.txt');
     case 5
        set1=importdata('data_collect_5.txt');
     case 6
        set1=importdata('data_collect_6.txt');
     case 7
        set1=importdata('data_collect_7.txt');
     case 8
        set1=importdata('data_collect_8.txt');
     case 9
        set1=importdata('data_collect_9.txt');
     case 10
        set1=importdata('data_collect_10.txt');
     case 11
        set1=importdata('data_collect_11.txt');
     case 12
        set1=importdata('data_collect_12.txt');
     case 13
        set1=importdata('data_collect_13.txt');
     case 14
        set1=importdata('data_collect_14.txt');
     case 15
        set1=importdata('data_collect_15.txt');
end
		time_set=set1(1:end,1)-set1(1,1);
        NoLoad=[];
        ts=timeseries(set1(:,2:end),time_set);
        Fs=20;T=1/Fs;
        par.Ts=T;
        timevec=0:T:time_set(end);
        tsout=resample(ts,timevec);
        resampleData=tsout.Data;
        time_set=[];
        time_set=timevec';
        NoLoad=time_set;NoLoad(:,2:18)=resampleData(:,4:20);
        par.p_offset=(resampleData(end,1:3)-NoLoad(end,2:4));
        par.pd_Pa = NoLoad(1:end,1) ; par.pd_Pa(:,2:4) = 1e5 *resampleData(:,1:3)* 0.0689476;
        par.pd_MPa=NoLoad(1:end,1) ; par.pd_MPa(:,2:4) = 1e-1 *resampleData(:,1:3)* 0.0689476;
        par.pd_psi = NoLoad(1:end,1) ; par.pd_psi(:,2:4) = resampleData(:,1:3);
        par.pm_Pa = NoLoad(1:end,1) ; par.pm_Pa(:,2:4) = 1e5 *( NoLoad(1:end,2:4)+par.p_offset)* 0.0689476;
        par.pm_psi = NoLoad(1:end,1) ; par.pm_psi(:,2:4) = ( NoLoad(1:end,2:4)+par.p_offset);
        par.pm_MPa=NoLoad(1:end,1) ; par.pm_MPa(:,2:4) = 1e-1 *( NoLoad(1:end,2:4)+par.p_offset)* 0.0689476;
        par.f_ex = NoLoad(1:end,1) ; par.f_ex(:,2:7) = 0 ;
        par.tip_exp = NoLoad(1:end,1) ; par.tip_exp(:,2:4) = ( NoLoad(1:end,12:14) - mean(NoLoad(1:end,5:7)) ) ;
        par.base_exp = NoLoad(1:end,1) ; par.base_exp(:,2:4) = ( NoLoad(1:end,5:7) ) ;
        par.tip_RQ = NoLoad(1:end,1) ; par.tip_RQ(:,2:5) = ( NoLoad(1:end,15:18) ) ;
end