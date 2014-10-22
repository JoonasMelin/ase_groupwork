curNode = map{start(2), start(1)};
curOrient = [-1, 0];

curNode.gScore = 0;
curNode.fScore = curNode.gScore + curNode.getHeuristic(goal);

updateScores(map,curNode, 'S', goal)

while curNode.x ~= goal(1) && curNode.y ~=goal(2)
    for
end