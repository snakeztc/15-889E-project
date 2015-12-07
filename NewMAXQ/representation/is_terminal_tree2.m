function [terminal] = is_terminal_tree2(s, a)
% this function is designed just work for taxi
% action 1 up 2 down 3 left 4 right 5 pick up 6 drop
% subtask 7 get, 8 put, 9 root
dest = 1; src = 2; x = 3; y = 4;
R = [1 1]; G = [1 5]; Y = [5 1]; B = [5 4];
locs = [R; G; Y; B];

% check terminal state
ssrc = s(src);
sdest = s(dest);
sx = s(x);
sy = s(y);

%% list all the predicate
terminal_list = zeros(9, 1); %default is terminal
terminal_list(9) = ssrc == sdest; %root
terminal_list(8) = ssrc == sdest; %put
terminal_list(7) = ssrc == 5; %get
terminal = terminal_list(a);
end

