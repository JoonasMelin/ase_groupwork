function h = Heuristic( x, y, o, xg,yg, og)
%% Manhattan distance to goal
    o_cost = abs(og-o);
    if (o_cost == 3)
        o_cost = 1;
    end
    h = xg-x + yg-y + o_cost;
end

