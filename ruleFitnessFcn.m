function fitness = ruleFitnessFcn(rule)
    % Access data from base workspace
    data = evalin('base', 'data');
    correct = 0;

    for i = 1:size(data, 1)
        x = data(i, 1:2);
        y = data(i, 3);
        pred = double(dot(rule(1:2), x) > rule(3));
        if pred == y
            correct = correct + 1;
        end
    end

    fitness = -correct / size(data, 1);  % Minimize negative accuracy
end
