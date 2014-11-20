init_pos = [0;0];
init_a = 0;
map = naoMap([init_pos;init_a]);

landmarks = [10 0;
            0 0;
            0 20];
        
movements = [0 2;
             pi/2 1;
             0 2];

simulate(map, landmarks, movements, init_pos, init_a);