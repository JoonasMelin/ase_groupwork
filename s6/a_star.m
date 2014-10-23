clear all;

%%
initializeMap

%%
%Initializing the first node
curNode = map{start(2), start(1)};

curNode.gScore = 0;
curNode.fScore = curNode.gScore + curNode.getHeuristic(goal);
openList = [];

%starting the recursive loop
goalNode = updateScores(map,curNode, 'S', goal, openList);

