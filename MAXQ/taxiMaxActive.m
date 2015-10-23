function [active] = taxiMaxActive(s, node)
% this function is designed just work for taxi
% node index: root(1), get(2), put(3), pick(4), drop(5),
% navi_get(6), navi_put(7), north(8), east(9), south(10), west(11).


dest = 1; src = 2; x = 3; y = 4;
active = 0;
ssrc = s(src);
%list all the predicate
if (node == 1)
    active = 1; 
elseif (node == 2)
    % get when p not on car
    if (ssrc < 5)
        active = 1;
    end
elseif (node == 3)
    % put when p is on car
    if (ssrc == 5)
        active = 1;
    end
elseif (node == 6)
    active = 1;
elseif (node == 7)
    active = 1;
else
    active = 1;
end
end

