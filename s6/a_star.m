curNode = map{start(2), start(1)};

curNode.gScore = 0;
curNode.fScore = curNode.gScore + curNode.getHeuristic(goal);
openList = [];

goalNode = updateScores(map,curNode, 'S', goal, openList);

