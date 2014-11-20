init_pos = [0;0];
init_a = 0;
map = naoMap([init_pos;init_a]);

landmarks = [10 0;
            0 0;
            0 20];
        
figure(1);
plot(landmarks(:,1),landmarks(:,2),'ob', 'MarkerSize', 10, 'LineWidth', 2);
hold on;
        
movements = [0 2;
             pi/2 1;
             0 2;
             0 1;
             pi/4 1;
             0 2;
             pi/4 1;
             0, 2];
movements(:,1) = cumsum(movements(:,1)); %want the angles to be cumulative

simulate(map, landmarks, movements, init_pos, init_a);