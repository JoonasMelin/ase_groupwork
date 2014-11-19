classdef naoMap < handle
    properties
        num_positions
        num_landmarks
        omega
        xi
        mu
    end
    properties (Access = private)
        sigma_t = 0.05;
        d = 10;
        sigma_l = 1;
        sigma_w = 0.05;
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
        function observe(map, id, rel_crd)
            %observe
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
    end % methods
end % classdef