function printMap(map, curNode)
mapString = [];
disp('F scores:');
for y = 1:size(map,1)
    for x = 1:size(map,2)
        nod = map{y,x};
        if nod.blocked
            mapString = [mapString, char(9), '#' char(9)];
        elseif curNode.xCoord == x && curNode.yCoord == y
            mapString = [mapString, char(9), 'R', char(9)];   
        elseif ~isfinite(nod.fScore)
            mapString = [mapString, char(9), 'X', char(9)];
        else
            mapString=([mapString, char(9),num2str(nod.fScore), char(9) ]);
        end
    end
    disp(mapString);
    mapString = [];
end

disp('Heuristics scores:');
for y = 1:size(map,1)
    for x = 1:size(map,2)
        nod = map{y,x};
        if nod.blocked
            mapString = [mapString, char(9), '#' char(9)];
        elseif curNode.xCoord == x && curNode.yCoord == y
            mapString = [mapString, char(9), 'R', char(9)];
        elseif ~isfinite(nod.fScore)
            mapString = [mapString, char(9), 'X', char(9)];
        else
            mapString=([mapString, char(9),num2str(nod.hScore), char(9) ]);
        end
    end
    disp(mapString);
    mapString = [];
end

disp('Steps:');
for y = 1:size(map,1)
    for x = 1:size(map,2)
        nod = map{y,x};
        if nod.blocked
            mapString = [mapString, char(9), '#' char(9)];
        elseif curNode.xCoord == x && curNode.yCoord == y
            mapString = [mapString, char(9), 'R', char(9)];
        elseif ~isfinite(nod.fScore)
            mapString = [mapString, char(9), 'X', char(9)];
        else
            mapString=([mapString, char(9),num2str(nod.gScore), char(9) ]);
        end
    end
    disp(mapString);
    mapString = [];
end