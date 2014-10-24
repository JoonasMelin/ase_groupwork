%Initializing the map
mapWidth = 5;
mapHeight = 6;

start = [2,2];
goal = [6,7];

%Because the edges need to be blocked, add edges
mapWidth = mapWidth+2;
mapHeight = mapHeight+2;

%Populating the storage
map = cell(mapHeight, mapWidth);
for xCoord = 1:mapWidth
    for yCoord = 1:mapHeight
        curNode = Node(1,xCoord, yCoord, 'node', 'O');
        curNode.blocked = true; %initializing everything as edges
        map{yCoord, xCoord} = curNode;
    end
end

%%
%Adding neighbors
for xCoord = 2:mapWidth-1
    for yCoord = 2:mapHeight-1
        up = Node(1, xCoord, yCoord,'link', 'N');
        up.neighbors = {map{yCoord+1,xCoord}};
        
        down = Node(1,xCoord, yCoord, 'link', 'S');
        down.neighbors = {map{yCoord-1,xCoord}};
        
        left = Node(1,xCoord, yCoord, 'link', 'W');
        left.neighbors = {map{yCoord,xCoord-1}};
        
        right = Node(1,xCoord, yCoord, 'link', 'E');
        right.neighbors = {map{yCoord,xCoord+1}};
        
        map{yCoord,xCoord}.neighbors = {up, down, left, right};
        
        %making this cell valid map cell (unblocking)
        map{yCoord,xCoord}.blocked = false;
    end
end

%%
%Adding obstacles
obstacles = [3,2;
             3,3;
             3,4;
             3,4;
             3,6;
             3,7;
             5,7;
             5,6;
             5,5;
             5,4;
             5,3];
 for loop = 1:size(obstacles, 1)
     cx = obstacles(loop,1);
     cy = obstacles(loop,2);
     
     map{cy,cx}.blocked = true;
 end