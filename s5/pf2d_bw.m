clear all; close all; clc;

goal = [10; 10]; %goal position to reach
nParticles = 1000; % number of particles
initialSpread = 1; % spread of initial particles
gridSize=0.25;

s_1 = 0.1;
s_2 = 0.2;
s_3 = 0.02;
T = 0.2;
%measurement_var = [s_3 0;
%                   0 s_3];

real_state = [0;0];

close_enough = false; %ending criteria


input_model = @(ang, vt, dt) ([cos(ang)*vt*dt, sin(ang)*vt*dt]');

%Anonymous function for the actual measurement
%0 if on white and 1 if on black
measure = @(x,y) (xor(mod(x,gridSize*2)<gridSize, mod(y,gridSize*2)<gridSize));

control = ones(1,3);

euclideanDistance = @(p,q) sqrt(sum((p-q).^2));

p = zeros(nParticles,2);
w = zeros(nParticles,1);

% initialize particles at random from U~(real_state-initialSpread,real_state+initialSpread)
for i = 1:nParticles 
    p(i,:) = [real_state(1)-initialSpread+2*initialSpread*rand() real_state(2)-initialSpread+2*initialSpread*rand()];
end
% current expected position
state = mean(p); % what is actually the expected position?

steps = 0;
duration = 0;

figure;
vis = plot(goal(1),goal(2),'o',inf,inf,'ro',p(:,1),p(:,2),'x');

while ~close_enough
   %prompt = 'input for next move (dt): ';
   control(3) = rand;%input(prompt);
   control(1) = atan2(goal(2)-state(:,2),goal(1)-state(:,1));
   
   %moving the real position
   real_state = real_state+input_model(control(1), control(2), control(3));
    
   % measure
   measurement = measure(real_state(1), real_state(2));
   %set(vis(2),'XData',measurement(1),'YData',measurement(2));pause(.5);
   
   cp = cos(control(1)); sp = sin(control(1)); 
   Rot = [cp -sp; 
          sp  cp]; % rotation matrix

   p2 = zeros(nParticles,2);
   for i = 1:nParticles
       % robot movement error for each particle
       walking_err = sqrt(control(3))*Rot*[randn*s_1;
                            randn*s_2];
       p2(i,:) = walking_err;
   end
   
   % move particles
   p = p + repmat(input_model(control(1),control(2),control(3))',nParticles,1)+p2;
   
   % create weights
   for i = 1:nParticles
      %w(i) = (measure(p(i,1),p(i,2)) == measurement);
      if measurement == 1
          if measure(p(i,1),p(i,2)) == measurement
              w(i)=0.95;
          else
              w(i)=0.05;
          end
      end
      if measurement == 0
          if measure(p(i,1),p(i,2)) == measurement
              w(i)=0.9;
          else
              w(i)=0.1;
          end
      end        
   end
   w = w./sum(w);
   
   % resampling particles
   p3 = zeros(nParticles,2);
   index = randi(nParticles,1);
   beta = 0;
   mw = max(w);
   for i = 1:nParticles
       beta = beta + rand() * 2 * mw;
       while beta > w(index)
           beta = beta - w(index);
           index = index + 1;
           if index > nParticles
               index = index - nParticles;
           end
       end
       p3(i,:) = p(index,:);
   end
   p = p3;
   set(vis(3),'XData',p(:,1),'YData',p(:,2));pause(.5);
   
   %update stats
   steps = steps+1;
   duration = duration+control(3)+T;
   
   % what should the stopping criteria be?
   N = 2; % how sure do we wanna be
   stdev = diag(std(p)); % do these tell anything usefull?
   state = mean(p);
   if goal(1) < state(1)+N*stdev(1) && goal(1) > state(1)-stdev(1) && ...
           goal(2) < state(2)+N*stdev(4) && goal(2) > state(2)-stdev(4) && ...
               N*stdev(1) < .3 && N*stdev(4) < .3
       close_enough = true;
       fprintf('congratulations, you reached your goal in %i steps\nit took %1.2f timeunits\n',steps,duration);
   end
end