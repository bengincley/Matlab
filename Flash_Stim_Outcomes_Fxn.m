% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% Flashing Stim Mice Behavior Learning Indicator - Analyzing and Outputting
% Correct, Early, Lapse Rate

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Flash_Stim_Mice_Variables.mat

% FIGURE 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Enables Datatype Compatibility
i521_correctRate = double(cell2mat(i521_correctRate));
i521_earlyRate = double(cell2mat(i521_earlyRate));
i521_missRate = double(cell2mat(i521_missRate));
i522_correctRate = double(cell2mat(i522_correctRate));
i522_earlyRate = double(cell2mat(i522_earlyRate));
i522_missRate = double(cell2mat(i522_missRate));
i523_correctRate = double(cell2mat(i523_correctRate));
i523_earlyRate = double(cell2mat(i523_earlyRate));
i523_missRate = double(cell2mat(i523_missRate));
i525_correctRate = double(cell2mat(i525_correctRate));
i525_earlyRate = double(cell2mat(i525_earlyRate));
i525_missRate = double(cell2mat(i525_missRate));
i526_correctRate = double(cell2mat(i526_correctRate));
i526_earlyRate = double(cell2mat(i526_earlyRate));
i526_missRate = double(cell2mat(i526_missRate));

% Establishes Plot Parameters
lower_threshold = 0.35;
upper_threshold = 0.45;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1]; 
xLimit = [1 30];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'FS';

% i521
%%%%%%%%%%%%%%%%%%%%
mouse = '521';
i521_smoothC = smooth(i521_correctRate, 3, 'moving');
i521_smoothE = smooth(i521_earlyRate, 3, 'moving');
i521_smoothM = smooth(i521_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,redD,1,i521_correctRate,i521_earlyRate,i521_missRate,i521_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i522
%%%%%%%%%%%%%%%%%%%%
mouse = '522';
i522_smoothC = smooth(i522_correctRate, 3, 'moving');
i522_smoothE = smooth(i522_earlyRate, 3, 'moving');
i522_smoothM = smooth(i522_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,orangeD,4,i522_correctRate,i522_earlyRate,i522_missRate,i522_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i523
%%%%%%%%%%%%%%%%%%%%
mouse = '523';
i523_smoothC = smooth(i523_correctRate, 3, 'moving');
i523_smoothE = smooth(i523_earlyRate, 3, 'moving');
i523_smoothM = smooth(i523_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,yellowD,5,i523_correctRate,i523_earlyRate,i523_missRate,i523_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i525
%%%%%%%%%%%%%%%%%%%%
mouse = '525';
i525_smoothC = smooth(i525_correctRate, 3, 'moving');
i525_smoothE = smooth(i525_earlyRate, 3, 'moving');
i525_smoothM = smooth(i525_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,greenD,6,i525_correctRate,i525_earlyRate,i525_missRate,i525_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% i526
%%%%%%%%%%%%%%%%%%%%
mouse = '526';
i526_smoothC = smooth(i526_correctRate, 3, 'moving');
i526_smoothE = smooth(i526_earlyRate, 3, 'moving');
i526_smoothM = smooth(i526_missRate, 3, 'moving');
fxnOutcomesPlot(mouse,blueD,3,i526_correctRate,i526_earlyRate,i526_missRate,i526_day,trainPeriod,upper,lower,yLimit,xLimit,type)

% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}Flashing Stim Mice Correct Rate over Training')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Percentage')
ylim([0 0.75]);
xlim(xLimit);
plot(trainingDay, i521_smoothC,'Color', redD,'LineWidth', 3); % Plots i521 CORRECT rate over training days
plot(trainingDay, i522_smoothC,'Color', orangeD, 'LineWidth', 3);  % Plots i522 CORRECT rate over training days
plot(trainingDay, i523_smoothC, 'Color', yellowD, 'LineWidth', 3); % Plots i523 CORRECT rate over training days
plot(trainingDay, i525_smoothC,'Color', greenD,'LineWidth', 3); % Plots i525 CORRECT rate over training days
plot(trainingDay, i526_smoothC,'Color', blueD, 'LineWidth', 3); % Plots i526 CORRECT rate over training days
% Reference Lines
plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[0.4 0.4],'Color', greenM, 'LineStyle', ':', 'LineWidth', 2.0)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Southwest','i521','i522','i523','i525','i526'); %Legend
plot(i521_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i522_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i523_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i525_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i526_day,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
