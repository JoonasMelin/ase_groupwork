curNode = map{start(2), start(1)};
curOrient = [-1, 0];

curNode.gScore = 0;
curNode.fScore = curNode.gScore + curNode.getHeuristic(goal);
openList = 

updateScores(map,curNode, 'S', goal, openList)

while curNode.x ~= goal(1) && curNode.y ~=goal(2)
    for
end