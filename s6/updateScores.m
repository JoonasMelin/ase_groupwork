function updateScores(map, curNode, curOrient, goal)

    %Case where we are going straight, the link node gets the same score
    if strcmp(curNode.orient, curOrient)
        %calculating the fScores
        
        curNode.gScore = prevNode.gScore;
    elseif 
    end
    
    
    lowestNeighbor = curNode.neighbors(1);
    for loop = 1:length(curNode.neighbors)
        %calculating the fScore for the neighbor
        curNeighbor = curNode.neighbors(loop);
        
        %checking for a case where we are going straight
        
        if strcmp(curOrient, curNeighbor.orient)
            if ~strcmp(curNeighbor.type, 'link')
                warning('Cant deal with multiple outputs on links');
            end            
            curNeighbor.updateScore(curNode.fScore,curNode.gScore);
            curNeighbor = curNeighbor.neighbor(1);            
        end
        
        %Updating scores on the neighbor
        newG = curNode.gScore + 1;
        newF = curNeighbor.getHeuristic(goal);
        curNeighbor.updateScore(newF, newG);
        
        
        
        
            
    end
end