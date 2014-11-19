classdef naoMap < handle
    properties
        num_positions
        num_landmarks
        omega
        xi
        mu
        
        max_obs_dist = 3;
        d = 10;
        sigma_l = 1;
        sigma_w = 0.05;
        sigma_m = 0.03;
        
    end
    properties (Access = private)
        
        sigma_t = 0.05;
        
        landmarks = [];
        

    end
    
    methods
        function map = naoMap(init_pos)
            map.omega = eye(3);
            map.xi(:,1) = init_pos;
            map.estimate_pos();
            
            map.num_positions = 1;
            map.num_landmarks = 0;
        end
        function observe_update(map, id, rel_crd, sigma_m)
            idx = find(map.landmarks==id,1);
            if isempty(idx)
                map.landmarks(end+1) = id;
                map.num_landmarks = map.num_landmarks + 1;
                
                X = 3*map.num_positions-2:3*map.num_positions;
                
                map.xi(end+1:end+3) = (map.mu(X) + [rel_crd;0])/sigma_m;
                map.xi(X) = map.xi(X) - (map.mu(X) + [rel_crd;0])/sigma_m;
                
                map.omega(X,X) = map.omega(X,X) + eye(3)/sigma_m; % up left corner
                map.omega(end+1:end+3,end+1:end+3) = eye(3)/sigma_m; % low right corner
                map.omega(X,end-2:end) = -eye(3)/sigma_m; % up right corner
                map.omega(end-2:end,X) = -eye(3)/sigma_m; % low left corner
                
                map.estimate_pos();
                return
            end
            
            L = 3*(map.num_positions+idx)-2:3*(map.num_positions+idx);
            X = 3*map.num_positions-2:3*map.num_positions;
            
            map.xi(L) = map.xi(L) + (map.mu(X) + [rel_crd;0])/sigma_m;
            map.xi(X) = map.xi(X) - (map.mu(X) + [rel_crd;0])/sigma_m;
                
            map.omega(X,X) = map.omega(X,X) + eye(3)/sigma_m; % up left corner
            map.omega(L,L) = map.omega(L,L) + eye(3)/sigma_m; % low right corner
            map.omega(X,L) = map.omega(X,L) - eye(3)/sigma_m; % up right corner
            map.omega(L,X) = map.omega(L,X) - eye(3)/sigma_m; % low left corner
            
            map.estimate_pos();
        end
        
%         function turn(map,something)
%             % turning
%         end
        function walk(map,new_pos, new_pos_sigma, cur_A, ang_sigma)
            %walking
        end
    end % methods
    methods (Access = private)
        function estimate_pos(map)
            map.mu = map.omega\map.xi;
        end
        
   
        
    end % methods
end % classdef