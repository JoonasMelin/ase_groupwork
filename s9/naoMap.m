classdef naoMap < handle
    properties
        num_positions
        num_landmarks
        omega
        xi
        mu
    end
    properties (Access = private)
        max_obs_dist = 3;
        sigma_t = 0.05;
        d = 10;
        sigma_l = 1;
        sigma_w = 0.05;
        sigma_obs = 0.03;
        landmarks = [1 0;
                    0 0;
                    0 2];
    end
    
    methods
        function map = naoMap(init_pos)
            map.omega = eye(3);
            map.xi(:,1) = init_pos;
            map.estimate_pos();
            
            map.num_positions = 1;
            map.num_landmarks = 0;
        end
        function [ids, obs_coords, obs_sigma] = observe(map, nao_pos)
            %observe
            obs_coords = [];
            ids = [];
            for loop = 1:length(map.landmarks)
                cl = map.landmarks(loop,:);
                dist = norm(cl-nao_pos);
                
                if dist < map.max_obs_dist
                    %do the observing
                    obs_id = loop;                    
                    obs_rel_coord = (cl-nao_pos);
                    
                    obs_coords(end+1,:) = obs_rel_coord;
                    ids(end+1) = obs_id;
                    obs_sigma(end+1,:) = [map.sigma_obs, map.sigma_obs];                    
                    
                end
            end
        end
        function turn(map,something)
            % turning
        end
        function walk(map,something)
            %walking
        end
    end % methods
    methods (Access = private)
        function estimate_pos(map)
            map.mu = map.omega\map.xi;
        end
        
        function [new_a, new_sigma] = turnModel(map, b, cur_a)
            new_a = b + sqrt((abs(cur_a-b))/(pi/4)); %wtf? this does not make any sense
            new_sigma = map.sigma_w;
        end
        
        function [new_pos, new_sigma] = movementModel(map, d, cur_pos, cur_a)
            x = cur_pos(1)+d*cos(cur_a);
            y = cur_pos(2)+d*sin(cur_a);
            x_s = cos(cur_a)*map.sigma_l;
            y_s = sin(cur_a)*map.sigma_l;
            
            new_pos = [x y];
            new_sigma = [x_s y_s];
        end
        
    end % methods
end % classdef