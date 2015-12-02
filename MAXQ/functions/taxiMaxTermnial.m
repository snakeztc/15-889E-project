function [terminal] = taxiMaxTermnial(s, node)
% this function is designed just work for taxi
% node index: root(1), get(2), put(3), pick(4), drop(5),
% navi_get(6), navi_put(7), north(8), east(9), south(10), west(11).

dest = 1; src = 2; x = 3; y = 4;
R = [1 1]; G = [1 5]; Y = [5 1]; B = [5 4];
locs = [R; G; Y; B];

% check terminal state
ssrc = s(src);
sdest = s(dest);
sx = s(x);
sy = s(y);

%list all the predicate
if (ssrc < 5)
    te6 = isequal(locs(ssrc, :), [sx sy]);
else
    te6 = true;
end

%% list all the predicate
terminal_list = zeros(11, 1);
terminal_list(1) = ssrc == sdest;
terminal_list(2) = ssrc == 5;
terminal_list(3) = ssrc == sdest;
terminal_list(6) = te6;
terminal_list(7) = isequal(locs(sdest, :), [sx sy]);
terminal = terminal_list(node);
%}
end

