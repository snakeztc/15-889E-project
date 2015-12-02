function [sp, r, terminal] = taxi_domain(s, a)
% state is [dest, src, x, y] = [4 5 5 5] = 500
% src = 5 means on taxi
% action 1 up 2 down 3 left 4 right 5 pick up 6 drop
% x 1 2 3 4 5
% 1 R  |    G
% 2    |
% 3
% 4  |   |
% 5 Y|   |B

dest = 1; src = 2; x = 3; y = 4;
mapSize = 5;
R = [1 1]; G = [1 5]; Y = [5 1]; B = [5 4];
locs = [R; G; Y; B];
terminal = 0;

% check terminal state
ssrc = s(src);
sdest = s(dest);
sx = s(x);
sy = s(y);
if (ssrc < 5 && ssrc == sdest)
    sp = s;
    r = 0;
    terminal = 1;
    return;
end

% check illegal pick up
if (a == 5)
    if (ssrc < 5 && sum([sx sy]==locs(ssrc, :)) == 2)
        sp = [sdest, 5, sx, sy];
        r = -1;
    else
        sp = s;
        r = -10;
    end
    return;
end
% check illegal dropoff
if (a == 6)
    if (ssrc == 5 && isequal([sx sy], locs(sdest, :)))
        sp = [sdest, sdest, sx, sy];
        r = 20;
    else
        sp = s;
        r = -10;
    end
    return;
end

%check move
if (a == 1)
    newX = sx - 1;
    newY = sy;
elseif (a == 2)
    newX = sx + 1;
    newY = sy;
elseif (a == 3)
    newX = sx;
    newY = sy - 1;
elseif (a == 4)
    newX = sx;
    newY = sy + 1;
else
    disp('worng');
end

r = -1;
% hit boundary
if (newX < 1 || newX > mapSize || newY < 1 || newY > mapSize)
    sp = s;
    return;
end
% hit wall
if (a == 3 && (isequal([sx sy], [1 3]) || isequal([sx sy], [2 3]) ...
        || isequal([sx sy], [4 2]) || isequal([sx sy], [5 2]) ...
        || isequal([sx sy], [4 4]) || isequal([sx sy], [5 4])))
    sp = s;
    return;
end
% hit wall
if (a == 4 && (isequal([sx sy], [1 2]) || isequal([sx sy], [2 2]) ...
        || isequal([sx sy], [4 1]) || isequal([sx sy], [5 1]) ...
        || isequal([sx sy], [4 3]) || isequal([sx sy], [5 3])))
    sp = s;
    return;
end

sp = [sdest, ssrc, newX, newY];

end


