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
    end
    
    methods
        function map = naoMap()
            % initialize
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