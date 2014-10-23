function goalNode = updateScores(map, curNode, curOrient, goal, openList)
    %Updating the open list
    openList(end+1) = curNode.neighbors;
    
    lowestInd = 1;
    lowestOpen = openList(lowestInd);
    
    for loop = 1:length(openList)
        %calculating the fScore for the neighbor
        curOpen = openList(loop);
        
        %checking for a case where we are going straight
        
        if strcmp(curOrient, curNeighbor.orient)
            if ~strcmp(curNeighbor.type, 'link')
                warning('Cant deal with multiple outputs on links');
            end            
            curOpen.updateScore(curNode.fScore,curNode.gScore);
        else
            %Not going straight or next node, incrementing G value
            newG = curNode.gScore + 1;
            newF = curNeighbor.getHeuristic(goal);
            curOpen.updateScore(newF, newG);                      
        end
        
        %Checking if this is the best from the open list
        if curOpen.fScore < lowestOpen.fScore
            lowestOpen = curOpen;
            lowestInd = loop;
        end     
            
    end
    
    %checking if we are at goal
    if curNode.x == goal(1) && curNode.y == goal(2)
        goalNode = curNode;
        return
    end
    
    %Removing the lowest open from the open list
    openList(lowestInd) = [];
    
    %Correcting for the next orientation
    if strcmp(lowestOpen.type, 'link')
        curOrient = lowestOpen.orient;
    end
    
    %Opening the next node
    updateScores(map,lowestOpen,curOrient,goal, openList);
end