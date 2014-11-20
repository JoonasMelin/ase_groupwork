function simulate(map, landmarks, movements, cur_pos, cur_A)
% if ~isset(cur_A)
%     cur_A = 0;
% end
% if ~isset(cur_pos)
%     cur_pos = [0, 0];
% end

for step = 1:size(movements,1)
    curD = movements(step,2)*map.d;
    dA = movements(step,1);
    
    %Turning
    [actualA, ang_sigma] = turnModel(map, dA, cur_A);
    cur_A = actualA; %should the measurement and simulation be separated?
    %map.turn(dA,ang_sigma);
    %walking
    [d_pos, new_pos, new_pos_sigma] = movementModel(map, curD, cur_pos, cur_A);
    map.walk([d_pos';dA], [new_pos_sigma';ang_sigma]);
    cur_pos = new_pos';
    
    %Observing
    [ids, obs_coords, obs_sigma] = observe(map, curD, landmarks);
    for obsNo = 1:size(ids, 2)
        %Obs sigma is 2 dimensional vector for both x asnd y dirs, since
        %only one is needed, taking the mean
        map.observe_update(ids(obsNo), [obs_coords(obsNo,:)';-cur_A], ...
            mean(obs_sigma(obsNo, :)));
        
    end
    
    %Visualization
    map.visualize(cur_pos);
    
end

end

function [new_a, new_sigma] = turnModel(map, b, cur_a)
    new_a = b;
    new_sigma = map.sigma_w * (sqrt((abs(cur_a-b))/(pi/4)))^(1/2);
    if new_sigma <= 1e-8
        new_sigma = 1e-8;
    end
end

function [d_pos, new_pos, new_sigma] = movementModel(map, d, cur_pos, cur_a)
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

function [ids, obs_coords, obs_sigma] = observe(map, nao_pos, landmarks)
%observe
obs_sigma = [];
obs_coords = [];
ids = [];
for loop = 1:length(landmarks)
    cl = landmarks(loop,:)';
    dist = norm(cl-nao_pos);

    if dist < map.max_obs_dist
        %do the observing
        obs_id = loop;                    
        obs_rel_coord = (cl-nao_pos);

        obs_coords(end+1,:) = obs_rel_coord;
        ids(end+1) = obs_id;
        obs_sigma(end+1,:) = [map.sigma_m, map.sigma_m];
    end
end

end