classdef Node < handle

       properties
           neighbors
           gScore
           fScore
           cost
           xCoord
           yCoord
           type
           blocked
           orient
       end

       methods
            function this = Node(cost, x, y, type, orient)
                this.cost = cost;
                this.xCoord = x;
                this.yCoord = y;
                this.type = type;
                this.blocked = false;
                this.gScore = -1;
                this.orient = orient;
            end
            
            function manhattanDist = getHeuristic(this, goal)
                manhattanDist = this.x-(goal(1)) + this.y-(goal(2));             
            end
            
            function updated = updateScore(this, fScore, gScore)
                if fScore+gScore < this.fScore+this.gScore
                    this.fScore = fScore;
                    this.gScore = gScore;
                    updated = true;
                else
                    updated = false;
                end
            end
       end
 end 