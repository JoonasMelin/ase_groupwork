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
        curNode = Node(1,xCoord, yCoord, 'node');
        curNode.blocked = true; %initializing everything as edges
        map{yCoord, xCoord} = curNode;
    end
end

%%
%Adding neighbors
for xCoord = 2:mapWidth-1
    for yCoord = 2:mapHeight-1
        up = Node(1, 0, 1, 'link');
        up.neighbors = map{yCoord+1,xCoord};
        
        down = Node(1, 0, -1, 'link');
        down.neighbors = map{yCoord-1,xCoord};
        
        left = Node(1, -1, 0, 'link');
        left.neighbors = map{yCoord,xCoord-1};
        
        right = Node(1, 1, 0, 'link');
        right.neighbors = map{yCoord,xCoord+1};
        
        map{yCoord,xCoord}.neighbors = [up, down, left, right];
        
        %making this cell valid map cell (unblocking)
        map{yCoord,xCoord}.blocked = false;
    end
end
