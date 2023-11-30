% Define the data points
x = [1, 2, 5, 6, 7, 10];
y = [3, 5, 8, 16, 20, 15];

% Parameters for the spline
degree = 3; % Degree of the spline (cubic spline)
numKnots = 5; % Number of knots

% Create a knot vector
knots = augknt(linspace(min(x), max(x), numKnots), degree);

% Fit a B-spline to the data
sp = spap2(knots, degree, x, y);

% Generate a fine grid for plotting
xx = linspace(min(x), max(x), 100); % Points for plotting the spline
yy = fnval(sp, xx); % Evaluate the spline at these points

% Plotting
figure; % Create a new figure
hold on; % Hold on to the current figure
plot(x, y, 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k'); % Plot original data points
plot(xx, yy, 'b-', 'LineWidth', 2); % Plot the fitted B-spline
title('B-spline Fit to Data');
legend('Data Points', 'B-spline Fit', 'Location', 'best');
xlabel('X');
ylabel('Y');
hold off; % Release the figure
