clear all; close all; clc;

goal = [10; 10]; %goal position to reach

s_1 = 0.1;
s_2 = 0.2;
s_3 = 0.02;
T = 0.2;
movement_var = [s_1, s_2];
measurement_var = [s_3 0;
                   0 s_3];

mean_pos = [0 0];
cur_covar = eye(2);

real_state = mean_pos'; %[x_pos, y_pos, velocity, angle]
state = mean_pos'; %the actual state of the machine, now only 1d        

close_enough = false; %ending criteria

%Anonymous function for the actual measurement
measure = @(x, y) ([x+randn()*s_3; y+randn()*s_3]);
input_model = @(ang, vt, dt) ([cos(ang)*vt*dt, sin(ang)*vt*dt]');

control = [pi/4, 1, 1];

euclideanDistance = @(p,q) sqrt(sum((p-q).^2));
steps = 0;
duration = 0;
figure;

while ~close_enough
    plot(goal(1),goal(2),'yo'); set(gca,'YLim',[-5,15],'XLim',[-5 15]); hold on;
    error_ellipse(cur_covar,state,.95,'style','g');title('current');
    
    %prompt = 'input for next move [angle vt dt]: ';
    %control = input(prompt);
    distanceToTarget = euclideanDistance(state,goal);
    control = [sign(goal(1)-state(1))*acos((goal(1)-state(1))/distanceToTarget)...
               1 ...
               distanceToTarget];
    
    [state, cur_covar] = kalman_predict(control, state, cur_covar, ...
        movement_var, input_model);
    
    %moving the real position
    real_state = real_state+input_model(control(1), control(2), control(3));
    
    disp(['State after prediction: X:', num2str(state(1)), ...
        ' Y:', num2str(state(2)), ...
        ' std: ', num2str(sqrt(cur_covar(1,1))), ' ', ...
        num2str(sqrt(cur_covar(2,2)))]);
    cur_covar
    
    error_ellipse(cur_covar,state,.95,'style','r');title('prediction');% pause;
    
    %measuring the position
    measurement = measure(real_state(1), real_state(2));
    
    [state, cur_covar] = kalman_update(measurement, state, cur_covar, ...
        measurement_var);
    
    disp('State after update: ');
    state
    cur_covar
    
    %visualization
    error_ellipse(cur_covar,state,.95,'style','b');title('update');pause;
    
    %update stats
    steps = steps+1;
    duration = duration+control(3)+T;
    
    N = 2; % how sure do we wanna be
    std = sqrt([cur_covar(1) cur_covar(4)]);
    if goal(1) < state(1)+N*std(1) && goal(1) > state(1)-std(1) && ...
            goal(2) < state(2)+N*std(2) && goal(2) > state(2)-std(2) && ...
                N*std(1) < .3 && N*std(2) < .3
        close_enough = true;
        fprintf('congratulations, you reached your goal in %i steps\nit took %1.2f timeunits\n',steps,duration);
    else
        clf;
    end
end





