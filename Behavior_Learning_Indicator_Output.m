% Benjamin Gincley
% 1/20/2016
% Glickfeld Lab
% Mouse Behavior Learning Indicator Analysis - Analyzing and Outputting

clear all; close all; nfig = 0; %Cleared workspace and started fig counter

dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
load Behavior_Learning_Variables.mat

% FIGURE 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Enables Datatype Compatibility
i527_medianReactTimeCorrect = cell2mat(i527_medianReactTimeCorrect);
i527_medianReactTimeCorrect = double(i527_medianReactTimeCorrect);

i529_medianReactTimeCorrect = cell2mat(i529_medianReactTimeCorrect);
i529_medianReactTimeCorrect = double(i529_medianReactTimeCorrect);

i533_medianReactTimeCorrect = cell2mat(i533_medianReactTimeCorrect);
i533_medianReactTimeCorrect = double(i533_medianReactTimeCorrect);

% Establishes Plot Parameters
lower_threshold = 275;
upper_threshold = 425;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = 2550; 
y = [0 yLimit];

% i527
%%%%%%%%%%%%%%%%%%%%
i527_training_Day = [1:n_TrainingPeriod_i527]'; %Vector of days of training
t = [0 n_TrainingPeriod_i527];
d = [7 7];

i527_smooth = smooth(i527_medianReactTimeCorrect, 3, 'moving');

subplot(2,2,2)  
hold on;
title('\fontsize{16}i527: Median React Time over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Median React Time')
ylim([0 yLimit]);
plot(i527_training_Day, i527_smooth,'Color', [1 0 0],'LineWidth', 4); % Plots AVERAGE of median react time over training days
plot(i527_training_Day, i527_medianReactTimeCorrect,'k*'); % Plots ACTUAL median react times
% Reference Lines
plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('Moving Average','Actual','Threshold'); %Legend
hold off;

% i529
%%%%%%%%%%%%%%%%%%%%
i529_training_Day = [1:n_TrainingPeriod_i529]'; %Vector of days of training
t = [0 n_TrainingPeriod_i529];
d = [7 7];

i529_smooth = smooth(i529_medianReactTimeCorrect, 3, 'moving');

subplot(2,2,3) 
hold on;
title('\fontsize{16}i529: Median React Time over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Median React Time')
ylim([0 yLimit]);
plot(i529_training_Day, i529_smooth,'Color', [0 0 0.8], 'LineWidth', 4); % Plots AVERAGE of median react time over training days
plot(i529_training_Day, i529_medianReactTimeCorrect,'k*'); % Plots ACTUAL median react times
% Reference Lines
plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('Moving Average','Actual','Threshold'); %Legend
hold off;


% i533
%%%%%%%%%%%%%%%%%%%%
i533_training_Day = [1:n_TrainingPeriod_i533]'; %Vector of days of training
t = [0 n_TrainingPeriod_i533];
d = [7 7];

i533_smooth = smooth(i533_medianReactTimeCorrect, 3, 'moving');

subplot(2,2,4)
hold on;
title('\fontsize{16}i533: Median React Time over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Median React Time')
ylim([0 yLimit]);
plot(i533_training_Day, i533_smooth, 'Color', [1 .5 0], 'LineWidth', 4); % Plots Moving Average median react time
plot(i533_training_Day, i533_medianReactTimeCorrect,'k*'); % Plots ACTUAL median react times
% Reference Lines
plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('Moving Average','Actual','Threshold'); %Legend
hold off;

% Overlay
%%%%%%%%%%%%%%%%%%%%
t = [0 n_TrainingPeriod_i533];
d = [7 7];

subplot(2,2,1)
hold on;
title('\fontsize{16}i527, i529, i533 Median R.T. over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Median React Time')
ylim([0 yLimit]);
plot(i527_training_Day, i527_smooth,'Color', [1 0 0],'LineWidth', 4); % Plots i527 median react time over training days
plot(i529_training_Day, i529_smooth,'Color', [0 0 0.8], 'LineWidth', 4);  % Plots i533 median react time over training days
plot(i533_training_Day, i533_smooth, 'Color', [1 .5 0], 'LineWidth', 4); % Plots i533 median react time over training days
% Reference Lines
plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('i527','i529','i533'); %Legend
hold off;

% FIGURE 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

yLimit = 8000000; 
y = [0 yLimit];

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Enables Datatype Compatibility
i527_varReactTimeCorrect = cell2mat(i527_varReactTimeCorrect);
i527_varReactTimeCorrect = double(i527_varReactTimeCorrect);

i527_varReactTimeEarly = cell2mat(i527_varReactTimeEarly);
i527_varReactTimeEarly = double(i527_varReactTimeEarly);

i529_varReactTimeCorrect = cell2mat(i529_varReactTimeCorrect);
i529_varReactTimeCorrect = double(i529_varReactTimeCorrect);

i529_varReactTimeEarly = cell2mat(i529_varReactTimeEarly);
i529_varReactTimeEarly = double(i529_varReactTimeEarly);

i533_varReactTimeCorrect = cell2mat(i533_varReactTimeCorrect);
i533_varReactTimeCorrect = double(i533_varReactTimeCorrect);

i533_varReactTimeEarly = cell2mat(i533_varReactTimeEarly);
i533_varReactTimeEarly = double(i533_varReactTimeEarly);

% i527
%%%%%%%%%%%%%%%%%%%%
i527_training_Day = [1:n_TrainingPeriod_i527]'; %Vector of days of training
t = [0 n_TrainingPeriod_i527];
d = [7 7];

i527_smoothC = smooth(i527_varReactTimeCorrect, 3, 'moving');
i527_smoothE = smooth(i527_varReactTimeEarly, 3, 'moving');

subplot(2,2,2)  
hold on;
title('\fontsize{16}i527: Variance of React Time over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}React Time Variance')
ylim([0 yLimit]);
plot(i527_training_Day, i527_smoothC,'Color', [1 0 0],'LineWidth', 4); % Plots AVERAGE of CORRECT react time variance over training days
plot(i527_training_Day, i527_smoothE,'Color', [1 0.7 0.7],'LineWidth', 4); % Plots AVERAGE of EARLY react time variance over training days
plot(i527_training_Day, i527_varReactTimeCorrect,'k*');% Plots ACTUAL react time variances for CORRECT over training days
plot(i527_training_Day, i527_varReactTimeEarly,'*', 'Color', [0.5 0.5 0.5]);% Plots ACTUAL react time variances for EARLY over training days
% Reference Lines
%plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
%plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('Correct','Early','Actual Correct', 'Actual Early'); %Legend
hold off;

% i529
%%%%%%%%%%%%%%%%%%%%
i529_training_Day = [1:n_TrainingPeriod_i529]'; %Vector of days of training
t = [0 n_TrainingPeriod_i529];
d = [7 7];

i529_smoothC = smooth(i529_varReactTimeCorrect, 3, 'moving');
i529_smoothE = smooth(i529_varReactTimeEarly, 3, 'moving');

subplot(2,2,3)  
hold on;
title('\fontsize{16}i529: Variance of React Time over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}React Time Variance')
ylim([0 yLimit]);
plot(i527_training_Day, i529_smoothC,'Color', [0 0 0.8],'LineWidth', 4); % Plots AVERAGE of CORRECT react time variance over training days
plot(i527_training_Day, i529_smoothE,'Color', [0.7 0.7 1],'LineWidth', 4); % Plots AVERAGE of EARLY react time variance over training days
plot(i527_training_Day, i529_varReactTimeCorrect,'k*');% Plots ACTUAL react time variances for CORRECT over training days
plot(i527_training_Day, i529_varReactTimeEarly,'*', 'Color', [0.5 0.5 0.5]);% Plots ACTUAL react time variances for EARLY over training days
% Reference Lines
%plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
%plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('Correct','Early','Actual Correct', 'Actual Early'); %Legend
hold off;

% i533
%%%%%%%%%%%%%%%%%%%%
i533_training_Day = [1:n_TrainingPeriod_i533]'; %Vector of days of training
t = [0 n_TrainingPeriod_i533];
d = [7 7];

i533_smoothC = smooth(i533_varReactTimeCorrect, 3, 'moving');
i533_smoothE = smooth(i533_varReactTimeEarly, 3, 'moving');

subplot(2,2,4)  
hold on;
title('\fontsize{16}i533: Variance of React Time over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}React Time Variance')
ylim([0 yLimit]);
plot(i527_training_Day, i533_smoothC,'Color', [1 .5 0],'LineWidth', 4); % Plots AVERAGE of CORRECT react time variance over training days
plot(i527_training_Day, i533_smoothE,'Color', [1 .8 .5],'LineWidth', 4); % Plots AVERAGE of EARLY react time variance over training days
plot(i527_training_Day, i533_varReactTimeCorrect,'k*');% Plots ACTUAL react time variances for CORRECT over training days
plot(i527_training_Day, i533_varReactTimeEarly,'*', 'Color', [0.5 0.5 0.5]);% Plots ACTUAL react time variances for EARLY over training days
% Reference Lines
%plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
%plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('Correct','Early','Actual Correct', 'Actual Early'); %Legend
hold off;

% Overlay
%%%%%%%%%%%%%%%%%%%%
t = [0 n_TrainingPeriod_i533];
d = [7 7];

subplot(2,2,1)
hold on;
title('\fontsize{16}i527, i529, i533 Variance of R.T. over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}React Time Variance')
ylim([0 yLimit]);
plot(i527_training_Day, i527_smoothC,'Color', [1 0 0],'LineWidth', 4); % Plots i527 react time variance over training days
plot(i529_training_Day, i529_smoothC,'Color', [0 0 0.8], 'LineWidth', 4);  % Plots i529 react time variance over training days
plot(i533_training_Day, i533_smoothC, 'Color', [1 .5 0], 'LineWidth', 4); % Plots i533 react time variance over training days
% Reference Lines
%plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
%plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('i527','i529','i533'); %Legend
hold off;