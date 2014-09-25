

moves = [-1,-1,-1,1,1,1,1,-1,-1,-1, -1];
measurement_var = 1;
movement_var = 1;

mean_pos = 2;
cur_covar = 1;

real_state = mean_pos;
state = mean_pos; %the actual state of the machine, now only 1d        


%Anonymous function for the actual measurement
measure = @(a) (abs(a)+10)+randn()*measurement_var;

for input = moves
    [state, cur_covar] = kalman_predict(input, state, cur_covar, ...
        movement_var);
    
    %moving the real position
    real_state = real_state+input;
    
    disp(['State after prediction: ', num2str(state), ' std: ', num2str(sqrt(cur_covar))]);
    
    %measuring the position
    measurement = measure(state);
    
    [state, cur_covar] = kalman_update(measurement, state, cur_covar, ...
        measurement_var);
    
    disp(['State after update: ', num2str(state), ' std: ', num2str(sqrt(cur_covar))]);
    
    %visualization
    figure(1);
    hold off;
    plot(state, 0, 'ob');
    hold on;
    plot(real_state, 0, 'xr');
    
    %calculating the deviation
    halfStd = sqrt(cur_covar)/2;
    plot(state+halfStd, 0.5, 'xg');
    plot(state-halfStd, 0.5, 'xg');
    line([state+halfStd, state-halfStd], [0.5, 0.5]);
    
    axis([state-2, state+2, -0.2, 0.8]);
    axis equal;
    grid on;
    
    pause;
    
end





