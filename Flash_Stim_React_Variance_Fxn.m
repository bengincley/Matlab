% Benjamin Gincley
% 2/18/2016
% Glickfeld Lab
% Flashing Stim Mice Behavior Learning Indicator - Analyzing and Outputting
% React Time Variance 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Flash_Stim_Mice_Variables.mat

% Enables Datatype Compatibility
i521_scaledVarReactTimeCorrect = double(cell2mat(i521_scaledVarReactTimeCorrect));
i521_scaledVarReactTimeEarly = double(cell2mat(i521_scaledVarReactTimeEarly));
i522_scaledVarReactTimeCorrect = double(cell2mat(i522_scaledVarReactTimeCorrect));
i522_scaledVarReactTimeEarly = double(cell2mat(i522_scaledVarReactTimeEarly));
i523_scaledVarReactTimeCorrect = double(cell2mat(i523_scaledVarReactTimeCorrect));
i523_scaledVarReactTimeEarly = double(cell2mat(i523_scaledVarReactTimeEarly));
i525_scaledVarReactTimeCorrect = double(cell2mat(i525_scaledVarReactTimeCorrect));
i525_scaledVarReactTimeEarly = double(cell2mat(i525_scaledVarReactTimeEarly));
i526_scaledVarReactTimeCorrect = double(cell2mat(i526_scaledVarReactTimeCorrect));
i526_scaledVarReactTimeEarly = double(cell2mat(i526_scaledVarReactTimeEarly));

% Establishes Plot Parameters
lower_threshold = 0.66;
upper_threshold = 1.0;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0,10]; 
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
i521_smoothC = smooth(i521_scaledVarReactTimeCorrect, 3, 'moving');
i521_smoothE = smooth(i521_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,redD,redL,1,i521_scaledVarReactTimeCorrect,i521_scaledVarReactTimeEarly,i521_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i522
%%%%%%%%%%%%%%%%%%%%
mouse = '522';
i522_smoothC = smooth(i522_scaledVarReactTimeCorrect, 3, 'moving');
i522_smoothE = smooth(i522_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,orangeD,orangeL,4,i522_scaledVarReactTimeCorrect,i522_scaledVarReactTimeEarly,i522_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i523
%%%%%%%%%%%%%%%%%%%%
mouse = '523';
i523_smoothC = smooth(i523_scaledVarReactTimeCorrect, 3, 'moving');
i523_smoothE = smooth(i523_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,yellowD,yellowL,5,i523_scaledVarReactTimeCorrect,i523_scaledVarReactTimeEarly,i523_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i525
%%%%%%%%%%%%%%%%%%%%
mouse = '525';
i525_smoothC = smooth(i525_scaledVarReactTimeCorrect, 3, 'moving');
i525_smoothE = smooth(i525_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,greenD,greenL,6,i525_scaledVarReactTimeCorrect,i525_scaledVarReactTimeEarly,i525_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i526
%%%%%%%%%%%%%%%%%%%%
mouse = '526';
i526_smoothC = smooth(i526_scaledVarReactTimeCorrect, 3, 'moving');
i526_smoothE = smooth(i526_scaledVarReactTimeEarly, 3, 'moving');
fxnReactVariancePlot(mouse,blueD,blueL,3,i526_scaledVarReactTimeCorrect,i526_scaledVarReactTimeEarly,i526_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}Flashing Stim Mice React Time Variance')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}React Time Variance')
ylim(yLimit);
xlim(xLimit);
plot(trainingDay, i521_smoothC,'Color', redD,'LineWidth', 3); % Plots i521 react time scaledVariance over training days
plot(trainingDay, i521_smoothE,'Color', redL,'LineWidth', 3); % Plots i521 EARLY react time scaledVariance over training days
plot(trainingDay, i522_smoothC,'Color', orangeD, 'LineWidth', 3);  % Plots i522 react time scaledVariance over training days
plot(trainingDay, i522_smoothE,'Color', orangeL,'LineWidth', 3); % Plots i522 EARLY react time scaledVariance over training days
plot(trainingDay, i523_smoothC, 'Color', yellowD, 'LineWidth', 3); % Plots i523 react time scaledVariance over training days
plot(trainingDay, i523_smoothE,'Color', yellowL,'LineWidth', 3); % Plots i523 EARLY react time scaledVariance over training days
plot(trainingDay, i525_smoothC,'Color', greenD,'LineWidth', 3); % Plots i525 react time scaledVariance over training days
plot(trainingDay, i525_smoothE,'Color', greenL,'LineWidth', 3); % Plots i525 EARLY react time scaledVariance over training days
plot(trainingDay, i526_smoothC,'Color', blueD,'LineWidth', 3); % Plots i526 react time scaledVariance over training days
plot(trainingDay, i526_smoothE,'Color', blueL,'LineWidth', 3); % Plots i526 EARLY react time scaledVariance over training days
% Reference Lines
plot(t,upper,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[2.45 2.45],'Color',purpleM, 'LineStyle', ':', 'LineWidth', 1.5)
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('i521 Correct','i521 Early','i522 Correct','i522 Early','i523 Correct','i523 Early','i525 Correct','i525 Early','i526 Correct','i526 Early'); %Legend
plot(i521_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i522_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i523_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i525_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i526_day,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
