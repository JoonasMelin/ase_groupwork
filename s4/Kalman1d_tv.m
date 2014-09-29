moves = [-1,-1,-1,1,1,1,1,-1,-1,-1, -1];
measurement_var = 1;
movement_var = 1;

mean_pos = 2;
cur_covar = 1;

real_state = mean_pos;
state = mean_pos; %the actual state of the machine, now only 1d

%Anonymous function for the actual measurement
measure = @(a) (abs(a)+10)+randn()*measurement_var;

%visualization stuff
x = -10:0.1:10;
statePdf = exp(-(x-state).^2/(2*cur_covar))/(sqrt(cur_covar)*sqrt(2*pi));
figure; plt = plot(x,statePdf,'b',[real_state real_state],[0 max(statePdf)],'r');
set(plt(1), 'YDataSource','statePdf'); axis tight;
legend('estimate','real state'); title('initial');
pause;

for input = moves
    [state, cur_covar] = kalman_predict(input, state, cur_covar, ...
        movement_var);
    
    %moving the real position
    real_state = real_state+input;
    
    disp(['State after prediction: ', num2str(state), ' std: ', num2str(sqrt(cur_covar))]);
    
    %visualize
    statePdf = exp(-(x-state).^2/(2*cur_covar))/(sqrt(cur_covar)*sqrt(2*pi));
    set(plt(2),'xdata',[real_state real_state],'ydata',[0 max(statePdf)]);
    refreshdata;axis tight; title('prediction');drawnow;
    pause;
    
    %measuring the position
    measurement = measure(real_state);
    
    [state, cur_covar] = kalman_update(measurement, state, cur_covar, ...
        measurement_var);
    
    disp(['State after update: ', num2str(state), ' std: ', num2str(sqrt(cur_covar))]);
    
    %visualize
    statePdf = exp(-(x-state).^2/(2*cur_covar))/(sqrt(cur_covar)*sqrt(2*pi));
    set(plt(2),'xdata',[real_state real_state],'ydata',[0 max(statePdf)]);
    refreshdata;axis tight; title('update');drawnow;
    pause;
end
