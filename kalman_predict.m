function [new_state, new_covar] = kalman_predict(input, state, old_covar, ...
    movement_var)

    system_model = 1; %simple system model
    
    %calculating the new state and covariance
    new_state = system_model*state + input;
    new_covar = system_model*old_covar*system_model' + movement_var;
end
    




