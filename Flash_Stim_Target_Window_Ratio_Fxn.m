% Benjamin Gincley
% 2/18/2016
% Glickfeld Lab
% Flashing Stim Mice Behavior Learning Indicator - Analyzing and Outputting
% Correct Window Ratio - Trials in target window / Total Correct Trials

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Flash_Stim_Mice_Variables.mat

% Enables Datatype Compatibility
i521_cdfDiff = double(cell2mat(i521_cdfDiff));
i522_cdfDiff = double(cell2mat(i522_cdfDiff));
i523_cdfDiff = double(cell2mat(i523_cdfDiff));
i525_cdfDiff = double(cell2mat(i525_cdfDiff));
i526_cdfDiff = double(cell2mat(i526_cdfDiff));
i521_correctRate = double(cell2mat(i521_correctRate));
i522_correctRate = double(cell2mat(i522_correctRate));
i523_correctRate = double(cell2mat(i523_correctRate));
i525_correctRate = double(cell2mat(i525_correctRate));
i526_correctRate = double(cell2mat(i526_correctRate));

% Ratio Calculation - % of all corrects in target window
i521_windowRatio = i521_cdfDiff ./ i521_correctRate;
i522_windowRatio = i522_cdfDiff ./ i522_correctRate;
i523_windowRatio = i523_cdfDiff ./ i523_correctRate;
i525_windowRatio = i525_cdfDiff ./ i525_correctRate;
i526_windowRatio = i526_cdfDiff ./ i526_correctRate;

% Establishes Plot Parameters
lower_threshold = 0.9;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1.02]; 
xLimit = [1 30];
d = [7 7];
t = [0 trainPeriod];
trainingDay = 1:trainPeriod;
type = 'FS';

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% i521
%%%%%%%%%%%%%%%%%%%%
mouse = '521';
i521_smoothC = smooth(i521_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,redD,1,i521_windowRatio,i521_day,trainPeriod,upper,lower,yLimit,xLimit,type)
plot([16 16],yLimit,'Color', purpleL, 'LineStyle', '--', 'LineWidth', 2.0); %Plots day reactTime set to 0.55s
hold off;

% i522
%%%%%%%%%%%%%%%%%%%%
mouse = '522';
i522_smoothC = smooth(i522_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,orangeD,4,i522_windowRatio,i522_day,trainPeriod,upper,lower,yLimit,xLimit,type)
plot([17 17],yLimit,'Color', purpleL, 'LineStyle', '--', 'LineWidth', 2.0); %Plots day reactTime set to 0.55s
hold off;

% i523
%%%%%%%%%%%%%%%%%%%%
mouse = '523';
i523_smoothC = smooth(i523_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,yellowD,5,i523_windowRatio,i523_day,trainPeriod,upper,lower,yLimit,xLimit,type)
hold off;

% i525
%%%%%%%%%%%%%%%%%%%%
mouse = '525';
i525_smoothC = smooth(i525_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,greenD,6,i525_windowRatio,i525_day,trainPeriod,upper,lower,yLimit,xLimit,type)
hold off;

% i526
%%%%%%%%%%%%%%%%%%%%
mouse = '526';
i526_smoothC = smooth(i526_windowRatio, 3, 'moving');
fxnTargWinRatioPlot(mouse,blueD,3,i526_windowRatio,i526_day,trainPeriod,upper,lower,yLimit,xLimit,type)
hold off;

% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}Flashing Stim Correct within 150-550ms / Total Correct')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Correct in 150-550ms / Total Correct')
ylim([0.3, 1.02]);
xlim(xLimit);
plot(trainingDay, i521_smoothC,'Color', redD, 'LineWidth', 3); % Plots i521 over training days
plot(trainingDay, i522_smoothC,'Color', orangeD,'LineWidth', 3); % Plots i522 over training days
plot(trainingDay, i523_smoothC,'Color', yellowD, 'LineWidth', 3);  % Plots i523 over training days
plot(trainingDay, i525_smoothC, 'Color', greenD, 'LineWidth', 3); % Plots i525 over training days
plot(trainingDay, i526_smoothC,'Color', blueD,'LineWidth', 3); % Plots i526 over training days
% Reference Lines
plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[0.95 0.95],'Color', greenM, 'LineStyle', ':', 'LineWidth', 2.0)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Southeast','i521','i522','i523','i525','i526'); %Legend
plot(i521_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i522_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i523_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i525_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i526_day,yLimit,'Color', blueM, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
