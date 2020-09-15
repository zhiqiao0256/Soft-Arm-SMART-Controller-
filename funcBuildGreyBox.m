function nlgr =funcBuildGreyBox()
    FileName      = 'funcGreyBoxOde';       % File describing the model structure.
    Order         = [2 5 2];           % Model orders [ny nu nx].
    Parameters    = [1; 0.1;0.1];         % Initial parameters. Np = 3.
    InitialStates = [0; 0];            % Initial initial states.
    Ts            = 0;                 % Time-continuous system.
    nlgr = idnlgrey(FileName, Order, Parameters, InitialStates, Ts, ...
                'Name', 'Arm');
    set(nlgr, 'InputName', {'Pm1','Pm2','Pm3','r_0','Phi'}, ...
              'InputUnit', {'MPa','MPa','MPa','m','rad'},               ...
              'OutputName', {'Angular position','vel'}, ...
              'OutputUnit', {'rad','rad/s'},                         ...
              'TimeUnit', 's');
          
    nlgr = setinit(nlgr, 'Name', {'Bending angle';        ... % x(1).
                       'Anguler vel'});             ... % x(2)
    nlgr = setinit(nlgr, 'Unit', {'rad'; 'rad/s'});
    nlgr = setpar(nlgr, 'Name', {'Alpha';                         ... % k
                      'Stiffness';      ... % a
                      'Damper';});       ... % alpha
    nlgr = setpar(nlgr, 'Unit', {'None';'Nm/rad'; 'Nm/(rad/s)'});
    nlgr = setpar(nlgr, 'Minimum', num2cell(eps(0)*ones(3, 1)));   % All parameters > 0!
    present(nlgr);

