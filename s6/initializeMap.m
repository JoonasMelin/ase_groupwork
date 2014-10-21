%Initializing the map
mapWidth = 10;
mapHeight = 15;

%Populating the storage
map = cell(mapHeight, mapWidth);
for xCoord = 1:mapWidth
    for yCoord = 1:mapHeight
        curNode = Node(1,xCoord, yCoord, 'node');
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
    end
end