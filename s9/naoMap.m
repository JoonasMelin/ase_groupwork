classdef naoMap < handle
    properties
        num_positions
        num_landmarks
        omega
        xi
        mu
        
        max_obs_dist = 300;
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
                
                map.xi(end+1:end+3) = rel_crd/sigma_m;
                map.xi(X) = map.xi(X) - rel_crd/sigma_m;
                
                map.omega(X,X) = map.omega(X,X) + eye(3)/sigma_m; % up left corner
                map.omega(end+1:end+3,end+1:end+3) = eye(3)/sigma_m; % low right corner
                map.omega(X,end-2:end) = -eye(3)/sigma_m; % up right corner
                map.omega(end-2:end,X) = -eye(3)/sigma_m; % low left corner
                
                map.estimate_pos();
                return
            end
            
            L = 3*(map.num_positions+idx)-2:3*(map.num_positions+idx);
            X = 3*map.num_positions-2:3*map.num_positions;
            
            map.xi(L) = map.xi(L) + rel_crd/sigma_m;
            map.xi(X) = map.xi(X) - rel_crd/sigma_m;
                
            map.omega(X,X) = map.omega(X,X) + eye(3)/sigma_m; % up left corner
            map.omega(L,L) = map.omega(L,L) + eye(3)/sigma_m; % low right corner
            map.omega(X,L) = map.omega(X,L) - eye(3)/sigma_m; % up right corner
            map.omega(L,X) = map.omega(L,X) - eye(3)/sigma_m; % low left corner
            
            map.estimate_pos();
        end
        function walk(map,d_pos,sigma_w)
            newRows = zeros(3,size(map.omega,2));
            map.omega = insertrows(map.omega,newRows,3*(map.num_positions));
            newColumns = zeros(size(map.omega,1),3);
            map.omega = insertrows(map.omega.',newColumns.',3*(map.num_positions)).';
            
            map.xi = insertrows(map.xi,[0, 0, 0]', ...
                3*(map.num_positions));
            
            X1 = 3*map.num_positions-2:3*map.num_positions;
            map.num_positions = map.num_positions + 1;
            X2 = 3*map.num_positions-2:3*map.num_positions;
            
            map.xi(X1) = map.xi(X1) - d_pos./sigma_w;
            map.xi(X2) = map.xi(X2) + d_pos./sigma_w;
                
            map.omega(X1,X1) = map.omega(X1,X1) + diag(1./sigma_w); % up left corner
            map.omega(X2,X2) = map.omega(X2,X2) + diag(1./sigma_w); % low right corner
            map.omega(X1,X2) = map.omega(X1,X2) - diag(1./sigma_w); % up right corner
            map.omega(X2,X1) = map.omega(X2,X1) - diag(1./sigma_w); % low left corner
            
            map.estimate_pos();
        end
        
        function visualize(map, cur_pos)
            xPositions = map.mu(1:3:((map.num_positions)*3)-2);
            yPositions = map.mu(2:3:((map.num_positions)*3)-1);
            xMap = map.mu((((map.num_positions)*3)+1):3:length(map.mu)-2);
            yMap = map.mu((((map.num_positions)*3)+2):3:end-1);
            
            figure(1);
            hold on;
            plot(xPositions,yPositions,'xr', 'MarkerSize', 10, 'LineWidth', 2);
            plot(xMap,yMap,'xg', 'MarkerSize', 11, 'LineWidth', 2);
            legend('Real landmarks', 'Mean position', 'Landmarks on map');
            grid on;
            axis equal;
        end
    end % methods
    methods (Access = private)
        function estimate_pos(map)
            map.mu = map.omega\map.xi;
        end
        
   
        
    end % methods
end % classdef