function [new_state, new_covar] = kalman_predict(input, state, old_covar, ...
    movement_var, input_model)

    system_model = [1 0;
                    0 1]; %simple system model
                
    %input is defined as [angle, speed, time]
    %input_model = @(ang, vt, dt) ([cos(ang)*vt*dt, sin(ang)*vt*dt]');
    
    %calculating the new state and covariance
    new_state = system_model*state + input_model(input(1), input(2), input(3));
    
    %determining the new covariance
    angle=input(1);
    time = input(3);
    
    %covariance was given at the direction of the movement (and
    %perpendicular to it), hence the nonlinear function
    Q = [abs(cos(angle)*movement_var(1)*time)+abs(cos(angle)*movement_var(2)*time), 0;
        0 ,abs(sin(angle)*movement_var(1)*time)+abs(sin(angle)*movement_var(2)*time)];
    
    new_covar = system_model*old_covar*system_model' + Q;
end
    




