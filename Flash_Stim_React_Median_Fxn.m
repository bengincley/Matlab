% Benjamin Gincley
% 2/18/2016
% Glickfeld Lab
% Flashing Stim Mice Behavior Learning Indicator - Analyzing and Outputting
% React Time Median 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Flash_Stim_Mice_Variables.mat

% Enables Datatype Compatibility
i521_medianReactTimeCorrect = double(cell2mat(i521_medianReactTimeCorrect));
i522_medianReactTimeCorrect = double(cell2mat(i522_medianReactTimeCorrect));
i523_medianReactTimeCorrect = double(cell2mat(i523_medianReactTimeCorrect));
i525_medianReactTimeCorrect = double(cell2mat(i525_medianReactTimeCorrect));
i526_medianReactTimeCorrect = double(cell2mat(i526_medianReactTimeCorrect));

% Establishes Plot Parameters
lower_threshold = 275;
upper_threshold = 425;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 2550]; 
xLimit = [1 30];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'FS';

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% i521
%%%%%%%%%%%%%%%%%%%%
mouse = '521';
i521_smooth = smooth(i521_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,redD,1,i521_medianReactTimeCorrect,i521_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i522
%%%%%%%%%%%%%%%%%%%%
mouse = '522';
i522_smooth = smooth(i522_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,orangeD,4,i522_medianReactTimeCorrect,i522_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i523
%%%%%%%%%%%%%%%%%%%%
mouse = '523';
i523_smooth = smooth(i523_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,yellowD,5,i523_medianReactTimeCorrect,i523_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i525
%%%%%%%%%%%%%%%%%%%%
mouse = '525';
i525_smooth = smooth(i525_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,greenD,6,i525_medianReactTimeCorrect,i525_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i526
%%%%%%%%%%%%%%%%%%%%
mouse = '526';
i526_smooth = smooth(i526_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,blueD,3,i526_medianReactTimeCorrect,i526_day,trainPeriod,upper,lower,yLimit,xLimit,type);


% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}Flashing Stim Mice Median React Time')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Median React Time')
ylim(yLimit);
xlim(xLimit);
plot(trainingDay, i521_smooth,'Color', redD,'LineWidth', 3); % Plots i521 median react time over training days
plot(trainingDay, i522_smooth,'Color', orangeD, 'LineWidth', 3);  % Plots i522 median react time over training days
plot(trainingDay, i523_smooth, 'Color', yellowD, 'LineWidth', 3); % Plots i523 median react time over training days
plot(trainingDay, i525_smooth,'Color', greenD,'LineWidth', 3); % Plots i525 median react time over training days
plot(trainingDay, i526_smooth,'Color', blueD, 'LineWidth', 3); % Plots i526 median react time over training days
% Reference Lines
plot(t,upper,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5)
for k=1:4                                                         % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('i521','i522','i523','i525','i526'); %Legend
plot(i521_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i522_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i523_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i525_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i526_day,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
