% Benjamin Gincley
% 1/18/2016
% Glickfeld Lab
% Mouse Behavior Learning Indicator Analysis

clear all; close all; nfig = 0; %Cleared workspace and started fig counter

% i527
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i527_medianReactTime = [1314 2275 2145 1272 599 686 663 519 331 316 174 320 ... %Input of median react times
    205 244 498 484 552 484 526 390 439 454 547 338 295 352 336 416 356 435]';
n_i527_medianReactTime = numel(i527_medianReactTime); % Number of inputs
i527_training_Day = [1:n_i527_medianReactTime]'; %Vector of days of training
a=0; %Sets number of days before
b=2; % Sets number of days after
x=0;
limit1 =  numel(i527_medianReactTime)-b-1; % Matches Matrix Dimensions
upper_threshold = 400; % Time in ms determined to be indicative of task learning
lower_threshold = 275;
for g=1:limit1
    if a <= 0 | x <= 0
        a=a+1;
        b=b+1;
        x=x+1;
    elseif a >= limit1
        break
    else 
        for k=1:limit1; % Loop to calculate averaged median react times
        i527_ave_MedianReactTime(:,x) = mean(i527_medianReactTime(a:b));
        %disp(ave_MedianReactTime);
        a=a+1;
        b=b+1;
        x=x+1;
        end
    end
end
limit2 = numel(i527_ave_MedianReactTime); % Shortening of window to allow for future calculation
i527_training_DayLimit = [1:limit2]'; % Shortening of time window to match ^^

nfig = nfig +1; %Starts new figure
figure(nfig)  
plot(i527_training_DayLimit, i527_ave_MedianReactTime,'k','LineWidth', 4); % Plots AVERAGE of median react time over training days
title('i527: Median React Time over Time')
xlabel('Training Day')
ylabel('Median React Time')
hold on;
plot(i527_training_Day, i527_medianReactTime,'b*'); % Plots ACTUAL median react times
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
    plot(d,y,'Color', [0.3 0.3 0.3])
    d=d+7;
end
[h,~] = legend('Average','Actual','Threshold'); %Legend
hold off;

% i529
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i529_medianReactTime = [325 1092 2472 788 474 361 642 501 454 694.5 394 543 ... %Input of median react times
    647 451 436 360 302 290 300 375 365 369 375 338 310 332 303 324 324 333]';
n_i529_medianReactTime = numel(i529_medianReactTime); % Number of inputs
i529_training_Day = [1:n_i529_medianReactTime]'; %Vector of days of training
a=0; %Sets number of days before
b=2; % Sets number of days after
x=0;
limit1 =  numel(i529_medianReactTime)-b-1; % Matches Matrix Dimensions
upper_threshold = 400; % Time in ms determined to be indicative of task learning
lower_threshold = 275;
for g=1:limit1
    if a <= 0 | x <= 0
        a=a+1;
        b=b+1;
        x=x+1;
    elseif a >= limit1
        break
    else 
        for k=1:limit1; % Loop to calculate averaged median react times
        i529_ave_MedianReactTime(:,x) = mean(i529_medianReactTime(a:b));
        %disp(ave_MedianReactTime);
        a=a+1;
        b=b+1;
        x=x+1;
        end
    end
end
limit2 = numel(i529_ave_MedianReactTime); % Shortening of window to allow for future calculation
i529_training_DayLimit = [1:limit2]'; % Shortening of time window to match ^^

nfig = nfig +1; %Starts new figure
figure(nfig)  
plot(i529_training_DayLimit, i529_ave_MedianReactTime,'k','LineWidth', 4); % Plots AVERAGE of median react time over training days
title('i529: Median React Time over Time')
xlabel('Training Day')
ylabel('Median React Time')
hold on;
plot(i529_training_Day, i529_medianReactTime,'b*'); % Plots ACTUAL median react times
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
    plot(d,y,'Color', [0.3 0.3 0.3])
    d=d+7;
end
[h,~] = legend('Average','Actual','Threshold'); %Legend
hold off;

% i533
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i533_medianReactTime = [945 876 725 667 1745 1503 1967 976 1802 695 691 395 ... %Input of median react times
    403 531 432 548 459 483 382 390 376 526 443 424 390 358 357 389 407 402]';
n_i533_medianReactTime = numel(i533_medianReactTime); % Number of inputs
i533_training_Day = [1:n_i533_medianReactTime]'; %Vector of days of training
a=0; %Sets number of days before
b=2; % Sets number of days after
x=1;
limit1 =  numel(i533_medianReactTime)-b-1; % Matches Matrix Dimensions
upper_threshold = 400; % Time in ms determined to be indicative of task learning
lower_threshold = 275;
for g=1:limit1
    if a <= 0 | x <= 0
        a=a+1;
        b=b+1;
        x=x+1;
    elseif a >= limit1
        break
    else 
        for k=1:limit1; % Loop to calculate averaged median react times
        i533_ave_MedianReactTime(:,x) = mean(i533_medianReactTime(a:b));
        %disp(ave_MedianReactTime);
        a=a+1;
        b=b+1;
        x=x+1;
        end
    end
end
limit2 = numel(i533_ave_MedianReactTime); % Shortening of window to allow for future calculation
i533_training_DayLimit = [1:limit2]'; % Shortening of time window to match ^^

nfig = nfig +1; %Starts new figure
figure(nfig)  
plot(i533_training_DayLimit, i533_ave_MedianReactTime,'k','LineWidth', 4); % Plots AVERAGE of median react time over training days
title('i533: Median React Time over Time')
xlabel('Training Day')
ylabel('Median React Time')
hold on;
plot(i533_training_Day, i533_medianReactTime,'b*'); % Plots ACTUAL median react times
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
    plot(d,y,'Color', [0.3 0.3 0.3])
    d=d+7;
end
[h,~] = legend('Average','Actual','Threshold'); %Legend
hold off;

i533_smooth = smooth(i533_medianReactTime, 3, 'moving');
nfig = nfig +1; %Starts new figure
figure(nfig)  
plot(i533_training_Day, i533_smooth, 'k', 'LineWidth', 4);
title('i533: Median React Time over Time')
xlabel('Training Day')
ylabel('Median React Time')
hold on;
plot(i533_training_Day, i533_medianReactTime,'b*'); % Plots ACTUAL median react times
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
    plot(d,y,'Color', [0.3 0.3 0.3])
    d=d+7;
end
[h,~] = legend('Average','Actual','Threshold'); %Legend
hold off;