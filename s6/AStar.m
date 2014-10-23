% obstacle map
grid = [[0, 0, 0, 0, 0, 0];
        [0, 1, 0, 0, 0, 0];
        [0, 0, 0, 1, 0, 0];
        [0, 1, 0, 0, 0, 0];
        [0, 0, 0, 0, 1, 0]];

init = [1,1,3];
s = size(grid);
goal = [s(2), s(1), 3];
cost = 1;

%possible turns for the machine
delta = [[ 0, 0 , 1]; % turn right 
         [ 0, 0 , -1]];% turn left

found = false;

%initialize open table 
x=init(1);
y=init(2);
o=init(3);
g=0;
h=Heuristic(x,y,o,goal(1),goal(2),goal(3));
f=g+h;
open = [f,h,g,x,y,o];

%initialize closed table
closed = grid;
closed(:,:,1:4)=0;
closed(y,x,o)=1;

% expansion table to show search 
expand = repmat(-1,[5 6 4]);

% expansion table to show search 
action = repmat(-1,[5 6 4]);

count = 0;

while ~found
    % if there is no path
    if isempty(open)
        disp('Path not found!');
        return;
    end
    
    % sort the open table and get the best option
    open = sortrows(open,1);
    next = open(1,:);
    x = next(4);
    y = next(5);
    o = next(6);
    g = next(3);
    open(1,:) = [];
    expand(y,x,o) = count;
    count = count+1;
    
    % check if we are at goal
    if x == goal(1) && y == goal(2) && o==goal(3)
            found = true;
    else
        for i=1:3
            x2=x;
            y2=y;
            o2=o;
            
            % Turn left or right
            if i==1
                o2 = o + 1;
            elseif i==2
                o2 = o - 1;
            % move to the cell in front of the machine...
            elseif i==3
                if o==1
                    y2 = y-1;
                end
                if o==2
                    x2 = x+1;
                end
                if o==3
                    y2 = y+1;
                end
                if o==4
                    x2 = x-1;
                end
            end
            
            % check if robot turns from N to W or W to N
            if o2<1
                o2=4;
            end
            if o2>4
                o2=1;
            end
            
            % check for the map limits
            if x2 >= 1 && x2 <= s(2) && y2 >=1 && y2 <= s(1)
                % check if we have already been to the cell or there is an
                % obstacle.
                if closed(y2,x2,o2) == 0 && grid(y2,x2) == 0
                    % calculate cost for the cell and push it to open list
                    % and to closed locations.
                    g2 = g + cost;
                    h2= Heuristic(x2,y2,o2,goal(1),goal(2),goal(3));
                    f2=g2+h2;
                    open = [open; [f2,h2,g2,x2,y2,o2]];
                    closed(y2,x2,o2) = 1;
                    action(y2,x2,o2) = i;
                end
            end
        end
    end
end



% print the path
x=goal(1);
y=goal(2);
o=goal(3);

path = repmat(-1,[5 6]);
path(init(1),init(2))=0;

while x~=init(1) || y~=init(2) || o~=init(3)
    i = action(y,x,o);
    if i==1
        o = o - 1;
    end
    if i==2
        o = o + 1;
    end
    
    if o<1
        o=4;
    end
    if o>4
        o=1;
    end
            
    if i==3
        if o==1
            path(y,x)=0;
            y=y+1;
        end
        if o==2
            path(y,x)=0;
            x=x-1;
        end
        if o==3
            path(y,x)=0;
            y=y-1;
        end
        if o==4
            path(y,x)=0;
            x=x+1;
        end
    end    
end

disp('Path found!');
path