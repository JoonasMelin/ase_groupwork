init_pos = [0;0];
init_a = 0;
map = naoMap([init_pos;init_a]);

landmarks = [1 0;
            0 0;
            0 2];
        
movements = [0 1;
             pi/2 1;
             0 2];

simulate(map, landmarks, movements, init_pos, init_a);