function [primitive] = taxiMaxPrimitve(node)
if (node > 7 || node == 4 || node == 5)
    primitive = true;
else
    primitive = false;
end
end

