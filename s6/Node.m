classdef Node < handle

       properties
           neighbors
           gScore
           fScore
           hScore
           cost
           xCoord
           yCoord
           type
           blocked
           visited
           orient
           
       end

       methods
            function this = Node(cost, x, y, type, orient)
                this.cost = cost;
                this.xCoord = x;
                this.yCoord = y;
                this.type = type;
                this.blocked = false;
                this.gScore = inf;
                this.fScore = inf;
                this.orient = orient;
                this.visited = false;
            end
            
            function manhattanDist = getHeuristic(this, goal)
                manhattanDist = abs(this.xCoord-(goal(1))) + abs(this.yCoord-(goal(2)));             
            end
            
            function updated = updateScore(this, heurScore, gScore)
                if heurScore+gScore < this.fScore
                    this.fScore = heurScore+gScore;
                    this.gScore = gScore;
                    this.hScore = heurScore;
                    updated = true;
                else
                    updated = false;
                end
            end
       end
 end 