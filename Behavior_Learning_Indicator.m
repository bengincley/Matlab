% Benjamin Gincley
% 1/19/2016
% Glickfeld Lab
% Mouse Behavior Learning Indicator Analysis

clear all; close all; nfig = 0; %Cleared workspace and started fig counter

lower_threshold = 275;
upper_threshold = 425;

nfig = nfig +1; %Starts new figure
figure(nfig)  

% i527
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i527_medianReactTime = [1314 2275 2145 1272 599 686 663 519 331 316 174 320 ... %Input of median react times
    205 244 498 484 552 484 526 390 439 454 547 338 295 352 336 416 356 435]';

n_i527_medianReactTime = numel(i527_medianReactTime); % Number of inputs
i527_training_Day = [1:n_i527_medianReactTime]'; %Vector of days of training

i527_smooth = smooth(i527_medianReactTime, 3, 'moving');

subplot(2,2,1)  
plot(i527_training_Day, i527_smooth,'Color', [1 0 0],'LineWidth', 4); % Plots AVERAGE of median react time over training days
title('i527: Median React Time over Training -- H&D')
xlabel('Training Day')
ylabel('Median React Time')
hold on;
plot(i527_training_Day, i527_medianReactTime,'k*'); % Plots ACTUAL median react times
hline = refline([0 lower_threshold]);
hline.Color = 'g';
hline.LineStyle = '--';
hline.LineWidth = 1.5;
hline = refline([0 upper_threshold]);
hline.Color = 'g';
hline.LineStyle = '--';
hline.LineWidth = 1.5;
d = [7 7];
y = [0 2500];
for k=1:4
    plot(d,y,'Color', [0.7 0.7 0.7], 'LineWidth', 1.5)
    d=d+7;
end
[h,~] = legend('Moving Average','Actual','Threshold'); %Legend
hold off;

% i529
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i529_medianReactTime = [325 1092 2472 788 474 361 642 501 454 694.5 394 543 ... %Input of median react times
    647 451 436 360 302 290 300 375 365 369 375 338 310 332 303 324 324 333]';

n_i529_medianReactTime = numel(i529_medianReactTime); % Number of inputs
i529_training_Day = [1:n_i529_medianReactTime]'; %Vector of days of training

i529_smooth = smooth(i529_medianReactTime, 3, 'moving');

subplot(2,2,2)  
plot(i529_training_Day, i529_smooth,'Color', [0 1 1], 'LineWidth', 4); % Plots AVERAGE of median react time over training days
title('i529: Median React Time over Training -- H&D')
xlabel('Training Day')
ylabel('Median React Time')
hold on;
plot(i529_training_Day, i529_medianReactTime,'k*'); % Plots ACTUAL median react times
hline = refline([0 lower_threshold]);
hline.Color = 'g';
hline.LineStyle = '--';
hline.LineWidth = 1.5;
hline = refline([0 upper_threshold]);
hline.Color = 'g';
hline.LineStyle = '--';
hline.LineWidth = 1.5;
d = [7 7];
y = [0 2500];
for k=1:4
    plot(d,y,'Color', [0.7 0.7 0.7], 'LineWidth', 1.5)
    d=d+7;
end
[h,~] = legend('Moving Average','Actual','Threshold'); %Legend
hold off;

% i533
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i533_medianReactTime = [945 876 725 667 1745 1503 1967 976 1802 695 691 395 ... %Input of median react times
    403 531 432 548 459 483 382 390 376 526 443 424 390 358 357 389 407 402]';

n_i533_medianReactTime = numel(i533_medianReactTime); % Number of inputs
i533_training_Day = [1:n_i533_medianReactTime]'; %Vector of days of training

i533_smooth = smooth(i533_medianReactTime, 3, 'moving');

subplot(2,2,3)
plot(i533_training_Day, i533_smooth, 'Color', [0.2 0.2 1], 'LineWidth', 4);
title('i533: Median React Time over Training -- H&D')
xlabel('Training Day')
ylabel('Median React Time')
hold on;
plot(i533_training_Day, i533_medianReactTime,'k*'); % Plots ACTUAL median react times
hline = refline([0 lower_threshold]);
hline.Color = 'g';
hline.LineStyle = '--';
hline.LineWidth = 1.5;
hline = refline([0 upper_threshold]);
hline.Color = 'g';
hline.LineStyle = '--';
hline.LineWidth = 1.5;
d = [7 7];
y = [0 2500];
for k=1:4
    plot(d,y,'Color', [0.7 0.7 0.7], 'LineWidth', 1.5)
    d=d+7;
end
[h,~] = legend('Moving Average','Actual','Threshold'); %Legend
hold off;

% Overlay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,2,4)
hold on;
plot(i527_training_Day, i527_smooth,'Color', [1 0 0],'LineWidth', 4); % Plots i527 of median react time over training days
plot(i529_training_Day, i529_smooth,'Color', [0 1 1], 'LineWidth', 4);  % Plots i533 of median react time over training days
plot(i533_training_Day, i533_smooth, 'Color', [0.2 0.2 1], 'LineWidth', 4); % Plots i533 of median react time over training days
title('i527, i529, i533 Median R.T. over Training -- H&D')
xlabel('Training Day')
ylabel('Median React Time')
hline = refline([0 lower_threshold]);
hline.Color = 'g';
hline.LineStyle = '--';
hline.LineWidth = 1.5;
hline = refline([0 upper_threshold]);
hline.Color = 'g';
hline.LineStyle = '--';
hline.LineWidth = 1.5;
d = [7 7];
y = [0 2500];
for k=1:4
    plot(d,y,'Color', [0.7 0.7 0.7], 'LineWidth', 1.5)
    d=d+7;
end
[h,~] = legend('i527','i529','i533'); %Legend
hold off;