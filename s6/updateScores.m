function goalNode = updateScores(map, curNode, curOrient, goal, openList)
    disp(['Current node: ']);
    curNode.visited = true;
    
    %Updating the open list
    openList = [openList, curNode.neighbors{:}];
    
    %Pruning blocked nodes from the open list
    blockInds = [];
    for loop = 1:length(openList)
        curOpen = openList(loop);
        if curOpen.blocked || curOpen.visited
            blockInds = [blockInds, loop];
        end
    end
    openList(blockInds) = [];
    
    if length(openList) == 0
        error('Can not reach the goal, no more nodes to open');
        goalNode = curNode;
    end
    
    
    lowestInd = 1;
    lowestOpen = openList(lowestInd);
    
    for loop = 1:length(openList)
        %calculating the fScore for the neighbor
        curOpen = openList(loop);
        
        %checking for a case where we are going straight
        
        if strcmp(curOrient, curOpen.orient)
            if ~strcmp(curOpen.type, 'link')
                warning('Cant deal with multiple outputs on links');
            end
            newG = curNode.gScore;
            newH = curOpen.getHeuristic(goal);
            curOpen.updateScore(newH,newG);
        else
            %Not going straight or next node, incrementing G value
            newG = curNode.gScore + 1;
            newH = curOpen.getHeuristic(goal);
            curOpen.updateScore(newH, newG);                      
        end
        
        %Checking if this is the best from the open list
        if curOpen.fScore < lowestOpen.fScore
            lowestOpen = curOpen;
            lowestInd = loop;
        end     
            
    end
    
    %checking if we are at goal
    if curNode.xCoord == goal(1) && curNode.yCoord == goal(2)
        goalNode = curNode;
        return
    end
    
    %Removing the lowest open from the open list
    openList(lowestInd) = [];
    
    %Correcting for the next orientation
    if strcmp(lowestOpen.type, 'link')
        curOrient = lowestOpen.orient;
    end
    
    printMap(map, lowestOpen);
    pause;
    
    %Opening the next node
    goalNode = updateScores(map,lowestOpen,curOrient,goal, openList);
    
end