function [u, success_flag] = lmp_time_opt_xcon_precomp_mimo(xI, xG, umax, umin, xmax, xmin, Ntrial,  ANc, RIc, chabo_open_loop_model)
    A = chabo_open_loop_model.A;
    B = chabo_open_loop_model.B;
    
    Ccon = [1, 0, 0, 0, 0; ...
        0, 0, 1, 0, 0; ... 
        0, 0, 0, 0, 1];
    ymax  = [xmax(1); xmax(3); xmax(5)];
    ymin  = [xmin(1); xmin(3); xmin(5)];
    
    success_flag = false;
    for n = 1:Ntrial
        % Compute Input trajectory
        Ri = RIc{n,1};      
        An = ANc{n,1};      
        u  = Ri*(xG-An*xI);
                  
        % extract tires torque and flywheel torque
        uT = u(1:2:length(u));
        uF = u(2:2:length(u));
        
        % Input Constraints
        u_con_flag = sum(uT<=umax(1))==length(uT) && ...
           sum(uT>=umin(1))==length(uT) && ...
           sum(uF<=umax(2))==length(uF) && ...
           sum(uF>=umin(2))==length(uF);
        
        % State Constraints
        X = forward_sim(xI, u, A, B);
        x_con_flag = true;
        for k = 1:size(X,2)                         % for each sample
            y = Ccon*X(:, k);                       % get output vector
            if(sum(y<=ymax)~=length(ymax) || ...    % if state constraint is violated --> 0!
               sum(y>=ymin)~=length(ymin))
                x_con_flag = false;
                break;
            end
        end
        
        if(u_con_flag && ...
           x_con_flag && ...
            n > length(xI) )
            success_flag = true;
            break;
        end
    end
end

