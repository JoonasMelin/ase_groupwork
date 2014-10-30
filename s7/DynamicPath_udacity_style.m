clear all;
height = 5;
width = 6;

grid = rand(height, width) > 0.8;

costMap = zeros(height,width);

valueMap = repmat(999,[height width]);

policyMap = repmat('#',[height width]);

for x = 1:width
    for y = 1:height
        costMap(y,x) = rand;
    end
end



s = size(costMap);
goal = [s(2), s(1)];

straightMoveCost = 1;
a = 0.1;
diagonalMoveCost = 2+a;
success_prob = 0.7;

%possible Moves for the machine
delta = [[ -1, 0, straightMoveCost]; % N 
         [ 0, 1, straightMoveCost]; % E
         [ 1, 0, straightMoveCost]; % S 
         [ 0, -1, straightMoveCost]; % W
         [ -1, 1, diagonalMoveCost]; % NE 
         [ 1, 1, diagonalMoveCost]; % SE
         [ 1, -1, diagonalMoveCost]; % SW 
         [ -1, -1, diagonalMoveCost]];% NW
     
     %possible Moves for the machine
deltaPolicy = ['N'; % N 
         'E'; % E
         'S'; % S 
         'W'; % W
         '1'; % NE 
         '2'; % SE
         '3'; % SW 
         '4';];% NW

changed = true;
iter = 0;
while changed
    iter = iter+1;
    changed = false;
    for x = 1:width
        for y = 1:height
            if goal(1)==x && goal(2)==y && valueMap(y,x)>costMap(y,x)
                valueMap(y,x) = costMap(y,x);
                policyMap(y,x) = 'O';
                changed = true;
                continue;
            end

            if grid(y,x) == 0
                for i = 1:8
                    v2 = delta(i,3);
                    for j = 0:1
                        y2 = y +j*delta(i,1);
                        x2 = x +j*delta(i,2);

                        if j == 1
                            p2 = success_prob;
                        else
                            p2 = 1- success_prob;
                        end
                        % check for the map limits
                        if x2 >= 1 && x2 <= s(2) && y2 >=1 && y2 <= s(1)
                            v2 = v2 + p2*(valueMap(y2,x2)+costMap(y2,x2));
                        else
                            v2 = v2 + p2*1000; % collision cost
                        end
                    end
                    if v2 < valueMap(y,x)
                            valueMap(y,x)=v2;
                            policyMap(y,x) = deltaPolicy(i);
                            changed = true;
                    end
                end
            end
        end
    end
end

disp('Map:');
grid
disp('Time matrix:');
valueMap
disp('Optimal Path');
policyMap