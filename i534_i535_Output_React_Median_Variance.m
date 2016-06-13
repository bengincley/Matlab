% Benjamin Gincley
% 1/22/2016
% Glickfeld Lab
% New Mice Learning Indicator Analysis - Analyzing and Outputting

clear all; close all; nfig = 0; %Cleared workspace and started fig counter

dr = 'S:\Analysis\Learning_Indicator';
cd(dr);
load New_Mice_Behavior_Learning_Variables.mat

% FIGURE 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Enables Datatype Compatibility
i534_medianReactTimeCorrect = cell2mat(i534_medianReactTimeCorrect);
i534_medianReactTimeCorrect = double(i534_medianReactTimeCorrect);

i535_medianReactTimeCorrect = cell2mat(i535_medianReactTimeCorrect);
i535_medianReactTimeCorrect = double(i535_medianReactTimeCorrect);

% Establishes Plot Parameters
lower_threshold = 275;
upper_threshold = 425;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = 3000; 
y = [0 yLimit];

% i534
%%%%%%%%%%%%%%%%%%%%
i534_training_Day = [1:n_TrainingPeriod_i534]'; %Vector of days of training
t = [0 30];
d = [7 7];

i534_smooth = smooth(i534_medianReactTimeCorrect, 3, 'moving');

subplot(2,2,2)  
hold on;
title('\fontsize{16}i534: Median React Time over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Median React Time')
ylim([0 yLimit]);
plot(i534_training_Day, i534_smooth,'Color', [1 0 0],'LineWidth', 4); % Plots AVERAGE of median react time over training days
plot(i534_training_Day, i534_medianReactTimeCorrect,'k*'); % Plots ACTUAL median react times
% Reference Lines
plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('Moving Average','Actual','Threshold'); %Legend
hold off;

% i535
%%%%%%%%%%%%%%%%%%%%
i535_training_Day = [1:n_TrainingPeriod_i535]'; %Vector of days of training
t = [0 30];
d = [7 7];

i535_smooth = smooth(i535_medianReactTimeCorrect, 3, 'moving');

subplot(2,2,3) 
hold on;
title('\fontsize{16}i535: Median React Time over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Median React Time')
ylim([0 yLimit]);
plot(i535_training_Day, i535_smooth,'Color', [0 0 0.8], 'LineWidth', 4); % Plots AVERAGE of median react time over training days
plot(i535_training_Day, i535_medianReactTimeCorrect,'k*'); % Plots ACTUAL median react times
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
t = [0 30];
d = [7 7];

subplot(2,2,1)
hold on;
title('\fontsize{16}i534, i535 Median R.T. over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Median React Time')
ylim([0 yLimit]);
plot(i534_training_Day, i534_smooth,'Color', [1 0 0],'LineWidth', 4); % Plots i527 median react time over training days
plot(i535_training_Day, i535_smooth,'Color', [0 0 0.8], 'LineWidth', 4);  % Plots i533 median react time over training days
% Reference Lines
plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('i534', 'i535'); %Legend
hold off;

% FIGURE 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

yLimit = 9000000; 
y = [0 yLimit];

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Enables Datatype Compatibility
i534_varReactTimeCorrect = cell2mat(i534_varReactTimeCorrect);
i534_varReactTimeCorrect = double(i534_varReactTimeCorrect);

i534_varReactTimeEarly = cell2mat(i534_varReactTimeEarly);
i534_varReactTimeEarly = double(i534_varReactTimeEarly);

i535_varReactTimeCorrect = cell2mat(i535_varReactTimeCorrect);
i535_varReactTimeCorrect = double(i535_varReactTimeCorrect);

i535_varReactTimeEarly = cell2mat(i535_varReactTimeEarly);
i535_varReactTimeEarly = double(i535_varReactTimeEarly);

% i534
%%%%%%%%%%%%%%%%%%%%
i534_training_Day = [1:n_TrainingPeriod_i534]'; %Vector of days of training
t = [0 n_TrainingPeriod_i534];
d = [7 7];

i534_smoothC = smooth(i534_varReactTimeCorrect, 3, 'moving');
i534_smoothE = smooth(i534_varReactTimeEarly, 3, 'moving');

subplot(2,2,2)  
hold on;
title('\fontsize{16}i534: Variance of React Time over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}React Time Variance')
ylim([0 yLimit]);
plot(i534_training_Day, i534_smoothC,'Color', [1 0 0],'LineWidth', 4); % Plots AVERAGE of CORRECT react time variance over training days
plot(i534_training_Day, i534_smoothE,'Color', [1 0.7 0.7],'LineWidth', 4); % Plots AVERAGE of EARLY react time variance over training days
plot(i534_training_Day, i534_varReactTimeCorrect,'k*');% Plots ACTUAL react time variances for CORRECT over training days
plot(i534_training_Day, i534_varReactTimeEarly,'*', 'Color', [0.5 0.5 0.5]);% Plots ACTUAL react time variances for EARLY over training days
% Reference Lines
%plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
%plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('Correct','Early','Actual Correct', 'Actual Early'); %Legend
hold off;

% i535
%%%%%%%%%%%%%%%%%%%%
i535_training_Day = [1:n_TrainingPeriod_i535]'; %Vector of days of training
t = [0 n_TrainingPeriod_i535];
d = [7 7];

i535_smoothC = smooth(i535_varReactTimeCorrect, 3, 'moving');
i535_smoothE = smooth(i535_varReactTimeEarly, 3, 'moving');

subplot(2,2,3)  
hold on;
title('\fontsize{16}i535: Variance of React Time over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}React Time Variance')
ylim([0 yLimit]);
plot(i535_training_Day, i535_smoothC,'Color', [0 0 0.8],'LineWidth', 4); % Plots AVERAGE of CORRECT react time variance over training days
plot(i535_training_Day, i535_smoothE,'Color', [0.7 0.7 1],'LineWidth', 4); % Plots AVERAGE of EARLY react time variance over training days
plot(i535_training_Day, i535_varReactTimeCorrect,'k*');% Plots ACTUAL react time variances for CORRECT over training days
plot(i535_training_Day, i535_varReactTimeEarly,'*', 'Color', [0.5 0.5 0.5]);% Plots ACTUAL react time variances for EARLY over training days
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
t = [0 n_TrainingPeriod_i534];
d = [7 7];

subplot(2,2,1)
hold on;
title('\fontsize{16}i534, i535 Variance of R.T. over Training -- H&D')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}React Time Variance')
ylim([0 yLimit]);
plot(i534_training_Day, i534_smoothC,'Color', [1 0 0],'LineWidth', 4); % Plots i534 react time variance over training days
plot(i535_training_Day, i535_smoothC,'Color', [0 0 0.8], 'LineWidth', 4);  % Plots i535 react time variance over training days
% Reference Lines
%plot(t,upper,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5) % Target Threshold
%plot(t,lower,'Color', [0.1 0.8 0], 'LineStyle', '--', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,y,'Color', [0.75 0.75 0.75], 'LineWidth', 1.0)
    d=d+7;
end
[h,~] = legend('i534','i535'); %Legend
hold off;