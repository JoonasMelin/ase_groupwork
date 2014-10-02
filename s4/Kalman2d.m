


s_1 = 0.1;
s_2 = 0.2;
s_3 = 0.02;
T = 0.2;
movement_var = [s_1, s_2];
measurement_var = [s_3 0;
                   0 s_3];

mean_pos = [0 0];
cur_covar = 1e-16*eye(2);

real_state = mean_pos'; %[x_pos, y_pos, velocity, angle]
state = mean_pos'; %the actual state of the machine, now only 1d        

close_enough = false; %ending criteria

%Anonymous function for the actual measurement
measure = @(x, y) ([x+randn()*s_3; y+randn()*s_3]);
input_model = @(ang, vt, dt) ([cos(ang)*vt*dt, sin(ang)*vt*dt]');

input = [pi/2, 1, 1];

% visualization stuff
x = -5:.1:15;
y = x;
[X Y] = meshgrid(x,y);

while ~close_enough
    [state, cur_covar] = kalman_predict(input, state, cur_covar, ...
        movement_var, input_model);
    
    %moving the real position
    real_state = real_state+input_model(input(1), input(2), input(3));
    
    disp(['State after prediction: X:', num2str(state(1)), ...
        ' Y:', num2str(state(2)), ...
        ' std: ', num2str(sqrt(cur_covar(1,1))), ' ', ...
        num2str(sqrt(cur_covar(2,2)))]);
    cur_covar
    
    %measuring the position
    measurement = measure(real_state(1), real_state(2));
    
    [state, cur_covar] = kalman_update(measurement, state, cur_covar, ...
        measurement_var);
    
    disp('State after update: ');
    state
    cur_covar
    
    %visualization
    Z = mvnpdf([X(:) Y(:)],state',cur_covar);
    Z = reshape(Z,size(X));
    surf(X,Y,Z);
    
    pause;
    
end





