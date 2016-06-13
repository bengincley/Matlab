% Benjamin Gincley
% 2/18/2016
% Glickfeld Lab
% Flashing Stim Mice Behavior Learning Indicator - Analyzing and Outputting
% CDF Point Extraction and Differences

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Flash_Stim_Mice_Variables.mat

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Enables Datatype Compatibility
i521_cdf_pLower = double(cell2mat(i521_cdf_pLower));
i521_cdf_pUpper = double(cell2mat(i521_cdf_pUpper));
i521_cdfDiff = double(cell2mat(i521_cdfDiff));
i522_cdf_pLower = double(cell2mat(i522_cdf_pLower));
i522_cdf_pUpper = double(cell2mat(i522_cdf_pUpper));
i522_cdfDiff = double(cell2mat(i522_cdfDiff));
i523_cdf_pLower = double(cell2mat(i523_cdf_pLower));
i523_cdf_pUpper = double(cell2mat(i523_cdf_pUpper));
i523_cdfDiff = double(cell2mat(i523_cdfDiff));
i525_cdf_pLower = double(cell2mat(i525_cdf_pLower));
i525_cdf_pUpper = double(cell2mat(i525_cdf_pUpper));
i525_cdfDiff = double(cell2mat(i525_cdfDiff));
i526_cdf_pLower = double(cell2mat(i526_cdf_pLower));
i526_cdf_pUpper = double(cell2mat(i526_cdf_pUpper));
i526_cdfDiff = double(cell2mat(i526_cdfDiff));

% Establishes Plot Parameters
lower_threshold = 0.24;
upper_threshold = 0.30;
identifierThreshold = 0.30;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 
xLimit = [1 30];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'FS';

% i521
%%%%%%%%%%%%%%%%%%%%
mouse = '521';
i521_smoothU = smooth(i521_cdf_pUpper, 3, 'moving');
i521_smoothL = smooth(i521_cdf_pLower, 3, 'moving');
i521_smoothD = smooth(i521_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,redD,1,i521_cdf_pUpper,i521_cdf_pLower,i521_cdfDiff,i521_day1,i521_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i522
%%%%%%%%%%%%%%%%%%%%
mouse = '522';
i522_smoothU = smooth(i522_cdf_pUpper, 3, 'moving');
i522_smoothL = smooth(i522_cdf_pLower, 3, 'moving');
i522_smoothD = smooth(i522_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,orangeD,4,i522_cdf_pUpper,i522_cdf_pLower,i522_cdfDiff,i522_day1,i522_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i523
%%%%%%%%%%%%%%%%%%%%
mouse = '523';
i523_smoothU = smooth(i523_cdf_pUpper, 3, 'moving');
i523_smoothL = smooth(i523_cdf_pLower, 3, 'moving');
i523_smoothD = smooth(i523_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,yellowD,5,i523_cdf_pUpper,i523_cdf_pLower,i523_cdfDiff,i523_day1,i523_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i525
%%%%%%%%%%%%%%%%%%%%
mouse = '525';
i525_smoothU = smooth(i525_cdf_pUpper, 3, 'moving');
i525_smoothL = smooth(i525_cdf_pLower, 3, 'moving');
i525_smoothD = smooth(i525_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,greenD,6,i525_cdf_pUpper,i525_cdf_pLower,i525_cdfDiff,i525_day1,i525_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i526
%%%%%%%%%%%%%%%%%%%%
mouse = '526';
i526_smoothU = smooth(i526_cdf_pUpper, 3, 'moving');
i526_smoothL = smooth(i526_cdf_pLower, 3, 'moving');
i526_smoothD = smooth(i526_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,blueD,3,i526_cdf_pUpper,i526_cdf_pLower,i526_cdfDiff,i526_day1,i526_day2,trainPeriod,threshold,yLimit,xLimit,type)

% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}Flashing Stim Mice % of All Trials with React Time of 150-550 ms')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}% Trials between 150-550ms')
ylim([0 0.75]);
xlim(xLimit);
plot(trainingDay, i521_smoothD,'Color', redD, 'LineWidth', 3); % Plots i521 DIFFERENCE over training days
plot(trainingDay, i522_smoothD,'Color', orangeD,'LineWidth', 3); % Plots i522 DIFFERENCE over training days
plot(trainingDay, i523_smoothD,'Color', yellowD, 'LineWidth', 3);  % Plots i523 DIFFERENCE over training days
plot(trainingDay, i525_smoothD, 'Color', greenD, 'LineWidth', 3); % Plots i525 DIFFERENCE over training days
plot(trainingDay, i526_smoothD,'Color', blueD,'LineWidth', 3); % Plots i526 DIFFERENCE over training days
% Reference Lines
plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[0.27 0.27],'Color', greenM, 'LineStyle', ':', 'LineWidth', 2.0) % Plots Learning Threshold
plot(t,[0.55 0.55],'Color', cyan, 'LineStyle', ':', 'LineWidth', 2.0) % Plots Proficiency Threshold
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Southeast','i521','i522','i523','i525','i526'); %Legend
plot(i521_day1,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i522_day1,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i523_day1,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i525_day1,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i526_day1,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
