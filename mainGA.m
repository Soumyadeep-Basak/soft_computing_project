% Load iris dataset
load fisheriris
X = meas;
Y = species;

% Convert to binary classification: Setosa vs Others
Y_binary = strcmp(Y, 'setosa'); % 1 if Setosa, 0 otherwise

% Reduce features to 2 for visualization (optional, can keep all 4)
X = X(:, [1 3]);  % Sepal Length & Petal Length

% Combine for GA
data = [X, Y_binary];

% Assign to base workspace
assignin('base', 'data', data);

% Number of variables (w1, w2, threshold)
nVars = 3;  % 2 weights + 1 threshold
lb = [-10 -10 -20];
ub = [10 10 20];


% GA options
options = optimoptions('ga', ...
    'PopulationSize', 30, ...
    'MaxGenerations', 50, ...
    'Display', 'iter', ...
    'PlotFcn', @gaplotbestf);  % Shows best fitness over generations

% Run Genetic Algorithm
[bestRule, bestFitness] = ga(@ruleFitnessFcn, nVars, [], [], [], [], lb, ub, [], options);

% Display results
fprintf('\nBest Rule Found:\n');
fprintf('  w1 = %.3f\n  w2 = %.3f\n  threshold = %.3f\n', bestRule(1), bestRule(2), bestRule(3));
fprintf('Accuracy = %.2f%%\n', -bestFitness * 100);

% Plot the dataset
figure;
gscatter(data(:,1), data(:,2), data(:,3), 'rb', 'ox');
hold on;

% Generate a grid
x1Range = linspace(min(data(:,1))-0.5, max(data(:,1))+0.5, 100);
x2Range = linspace(min(data(:,2))-0.5, max(data(:,2))+0.5, 100);
[x1Grid, x2Grid] = meshgrid(x1Range, x2Range);

decisionValues = bestRule(1) * x1Grid + bestRule(2) * x2Grid;

% Plot decision boundary
contour(x1Grid, x2Grid, decisionValues, [bestRule(3) bestRule(3)], 'k', 'LineWidth', 2);

xlabel('x1'); ylabel('x2');
title('Evolved Rule Decision Boundary');
legend('Class 0', 'Class 1', 'Decision Boundary');
grid on;
