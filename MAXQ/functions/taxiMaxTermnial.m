function [terminal] = taxiMaxTermnial(s, node)
% this function is designed just work for taxi
% node index: root(1), get(2), put(3), pick(4), drop(5),
% navi_get(6), navi_put(7), north(8), east(9), south(10), west(11).

dest = 1; src = 2; x = 3; y = 4;
R = [1 1]; G = [1 5]; Y = [5 1]; B = [5 4];
locs = [R; G; Y; B];
terminal = 0;

% check terminal state
ssrc = s(src);
sdest = s(dest);
sx = s(x);
sy = s(y);
%list all the predicate
te1 = ssrc == sdest;
te2 = ssrc == 5;
te3 = ssrc == sdest;
if (ssrc < 5)
    te6 = isequal(locs(ssrc, :), [sx sy]);
else
    te6 = true;
end
te7 = isequal(locs(sdest, :), [sx sy]);

% check for each node
if (node == 1)
     % check if it is final state
    if (te1)
        terminal = 1;
    end
elseif (node == 3)
    if (te3)
        terminal = 1;
    end
elseif (node == 2)
    if (te2)
        terminal = 1;
    end
elseif (node == 6)
    if (te6)
        terminal = 1;
    end
elseif (node == 7)
    if (te7)
        terminal = 1;
    end
else
    terminal = 0;
end

end

