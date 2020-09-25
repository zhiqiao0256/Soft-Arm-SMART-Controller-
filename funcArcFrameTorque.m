function testData=funcArcFrameTorque(testData,par_set)
        phi=testData.phi_rad;
        pm1=testData.pm_MPa(:,2);
        pm2=testData.pm_MPa(:,3);
        pm3=testData.pm_MPa(:,4);
        tau=(sin(phi).*(0.5*pm1+0.5*pm3-pm2)-sqrt(3)*cos(phi).*(0.5*pm1-0.5*pm3));
        figure
        subplot(3,1,1)
        plot(testData.pm_MPa(:,1),phi)
        legend('phi(rad)')
        subplot(3,1,2)
        plot(testData.pm_MPa(:,1),testData.pm_MPa(:,2:4))
        legend('p1(MPa)','p2(MPa)','p3(MPa)')
        subplot(3,1,3)
        plot(testData.pm_MPa(:,1),tau)
        hold on
        plot(testData.pm_MPa(:,1),tau*0.03*0.07)
        legend('tau','\alpha tau')
        testData.tau=tau;
end