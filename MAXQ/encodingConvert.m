function [target_actions] = encodingConvert(actions, encode)

% if ecode is flat, it converst from flat to MAXQ

numAction = length(actions);
target_actions = zeros(numAction, 1);

for i = 1:numAction
    action = actions(i);
    if (strcmp(encode, 'flat'))
        if (action < 5) 
            target_action = action + 7;
        elseif (action == 5)
            target_action = 4;
        else
            target_action = 5;
        end
    else
        if (action > 7)
            target_action = action - 7;
        elseif (action == 4)
            target_action = 5;
        else
            target_action = 6;
        end
    end
    target_actions(i) = target_action;
end
end

