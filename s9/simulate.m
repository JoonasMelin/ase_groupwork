function simulate(map, landmarks, movements, cur_pos, cur_A)
real_pos = cur_pos;
real_A = cur_A;
%Doing the map initialization before we move
%Observing
[ids, obs_coords, obs_sigma] = observe(map, cur_pos, cur_A, landmarks);
for obsNo = 1:size(ids, 2)
    %Obs sigma is 2 dimensional vector for both x asnd y dirs, since
    %only one is needed, taking the mean
    map.observe_update(ids(obsNo), [obs_coords(obsNo,:)';-cur_A], ...
        mean(obs_sigma(obsNo, :)));

end
map.visualize();
pause;

for step = 1:size(movements,1)
    curD = movements(step,2)*map.d;
    dA = movements(step,1);
    
    %Turning
    [actualA, ang_sigma] = turnModel(map, dA, cur_A);
    [real_A, ang_sigma] = turnModel(map, dA, real_A);
    difA = actualA-cur_A;
    cur_A = actualA; %should the measurement and simulation be separated?
    %map.turn(dA,ang_sigma);
    %walking
    [d_pos, new_pos, new_pos_sigma] = movementModel(map, curD, cur_pos, cur_A);
    [d_pos_na, real_pos, new_pos_sigma_na] = movementModel(map, curD, real_pos, real_A);
    map.walk([d_pos';difA], [new_pos_sigma';ang_sigma]);
    cur_pos = new_pos';
    real_pos_t = real_pos';
    
    %Observing
    [ids, obs_coords, obs_sigma] = observe(map, real_pos_t, real_A, landmarks);
    for obsNo = 1:size(ids, 2)
        %Obs sigma is 2 dimensional vector for both x asnd y dirs, since
        %only one is needed, taking the mean
        map.observe_update(ids(obsNo), [obs_coords(obsNo,:)';-cur_A], ...
            mean(obs_sigma(obsNo, :)));
        
    end
    
    %Visualization
    map.visualize();
    pause;
    
end
hold off;
end

function [new_a, new_sigma] = turnModel(map, b, cur_a)
    
    new_sigma = map.sigma_w * (sqrt((abs(cur_a-b))/(pi/4)))^(1/2);
    new_a = b + rand(1)*new_sigma;
    if new_sigma <= 1e-8
        new_sigma = 1e-8;
    end
end

function [d_pos, new_pos, new_sigma] = movementModel(map, d, cur_pos, cur_a)
    d = d+rand(1)*map.sigma_l;
    x = cur_pos(1)+d*cos(cur_a);
    y = cur_pos(2)+d*sin(cur_a);

    x_s = cos(cur_a)*map.sigma_l;
    if  x_s <= 1e-8
        x_s = 1e-8;
    end
    y_s = sin(cur_a)*map.sigma_l;
    if y_s <= 1e-8
        y_s = 1e-8;
    end

    d_pos = [d*cos(cur_a) d*sin(cur_a)];
    new_pos = [x,y];

    new_sigma = [x_s y_s];
end

function [ids, obs_coords, obs_sigma] = observe(map, nao_pos, orient, landmarks)
%observe
obs_sigma = [];
obs_coords = [];
ids = [];
for loop = 1:length(landmarks)
    cl = landmarks(loop,:)';
    dist = norm(cl-nao_pos);
    obs_rel_coord = (cl-nao_pos);
    
    orient_vec_landmark = obs_rel_coord/dist;
    orient_vec_nao = [cos(orient), sin(orient)];
    angle_between = acos(dot(orient_vec_landmark,orient_vec_nao));

    if ((dist < map.max_obs_dist) && ((-pi/3) < angle_between) && (angle_between < (pi/3)))
        %do the observing
        obs_id = loop;    

        obs_coords(end+1,:) = obs_rel_coord + randn * map.sigma_m;
        ids(end+1) = obs_id;
        obs_sigma(end+1,:) = [map.sigma_m, map.sigma_m];
    end
end

end