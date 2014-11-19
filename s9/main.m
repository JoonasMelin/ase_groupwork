map = naoMap([0,0]);

landmarks = [1 0;
            0 0;
            0 2];
        
movements = [0 1;
             pi/2 1;
             0 2];

simulate(map, landmarks, movements);