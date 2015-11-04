function s = initStateGenerate()
    while 1
        pass = randi(4);
        dest = randi(4);
        car = randi(5, 2, 1)';
        s = [dest, pass, car];
        if dest ~= pass
            break;
        end
    end
end

