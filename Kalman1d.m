real_pos = -1;

moves = [-1,-1,-1,1,1,1,1,-1,-1,-1, -1];
measurement_var = 1;
movement_var = 1;

mean_pos = 2;
cur_covar = 1;

state = mean_pos; %the actual state of the machine, now only 1d        


%Anonymous function for the actual measurement
measure = @(a) abs(a)+10';

for input = moves
    [state, cur_covar] = kalman_predict(input, state, cur_covar, ...
        movement_var);
    
    disp(['State after prediction: ', num2str(state), 'var: ', num2str(cur_covar)]);
    
    %measuring the position
    measurement = measure(state);
    
    [state, cur_covar] = kalman_update(measurement, state, cur_covar, ...
        measurement_var);
    
    disp(['State after update: ', num2str(state), 'var: ', num2str(cur_covar)]);
    
    
end





