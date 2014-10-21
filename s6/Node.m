classdef Node < handle

       properties
           neighbors
           cost
           xCoord
           yCoord
           type
           blocked
       end

       methods
            function this = Node(cost, x, y, type)
                this.cost = cost;
                this.xCoord = x;
                this.yCoord = y;
                this.type = type;
                this.blocked = false;
            end
       end
 end 