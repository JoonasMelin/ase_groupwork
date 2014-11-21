init_pos = [0;0];
init_a = 0;

landmarks = [10 -10;
            0 -10;
            0 20;
            20 50;
            -20 70;
            -150 100;
            -60 300
            100 450];
        
figure(1);
plot(landmarks(:,1),landmarks(:,2),'ob', 'MarkerSize', 10, 'LineWidth', 2);
axis equal;hold on;

map = naoMap([init_pos;init_a]);

movements = [0 2;
             pi/2 1;
             0 2;
             0 1;
             pi/4 1;
             0 2;
             pi/4 1;
             0, 2;
             -pi/4 2
             0 2
             -pi/4 2
             -pi/4 5
             0 15
             pi/4 10
             pi/4 10
             pi/4 10
             pi/4 10
             pi/4 15];
movements(:,1) = cumsum(movements(:,1)); %want the angles to be cumulative

simulate(map, landmarks, movements, init_pos, init_a);