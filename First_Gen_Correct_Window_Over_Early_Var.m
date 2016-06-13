% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% First Gen Mice Behavior Learning Indicator - Analyzing and Outputting
% Percent of trials within 150-550ms divided by scaled variance of early
% trials

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load First_Gen_Mice_Variables.mat

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Enables Datatype Compatibility
i505_cdfDiff = double(cell2mat(i505_cdfDiff));
i506_cdfDiff = double(cell2mat(i506_cdfDiff));
i507_cdfDiff = double(cell2mat(i507_cdfDiff));
i508_cdfDiff = double(cell2mat(i508_cdfDiff));
i509_cdfDiff = double(cell2mat(i509_cdfDiff));

i505_scaledVarReactTimeEarly = double(cell2mat(i505_scaledVarReactTimeEarly));
i506_scaledVarReactTimeEarly = double(cell2mat(i506_scaledVarReactTimeEarly));
i507_scaledVarReactTimeEarly = double(cell2mat(i507_scaledVarReactTimeEarly));
i508_scaledVarReactTimeEarly = double(cell2mat(i508_scaledVarReactTimeEarly));
i509_scaledVarReactTimeEarly = double(cell2mat(i509_scaledVarReactTimeEarly));

i505_ratio = i505_cdfDiff ./ i505_scaledVarReactTimeEarly;
i506_ratio = i505_cdfDiff ./ i506_scaledVarReactTimeEarly;
i507_ratio = i505_cdfDiff ./ i507_scaledVarReactTimeEarly;
i508_ratio = i505_cdfDiff ./ i508_scaledVarReactTimeEarly;
i509_ratio = i505_cdfDiff ./ i509_scaledVarReactTimeEarly;

% Establishes Plot Parameters
lower_threshold = 0.24;
upper_threshold = 0.30;
identifierThreshold = 0.10;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 .5]; 
xLimit = [1 20];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'HD';

% i505
%%%%%%%%%%%%%%%%%%%%
mouse = '505';
i505_smoothed = smooth(i505_ratio, 3, 'moving');
fxnCorrectOverVarPlot(mouse,redD,5,i505_ratio,i505_day,trainPeriod,threshold,yLimit,xLimit,type)

% i506
%%%%%%%%%%%%%%%%%%%%
mouse = '506';
i506_smoothed = smooth(i506_ratio, 3, 'moving');
fxnCorrectOverVarPlot(mouse,orangeD,4,i506_ratio,i506_day,trainPeriod,threshold,yLimit,xLimit,type)

% i507
%%%%%%%%%%%%%%%%%%%%
mouse = '507';
i507_smoothed = smooth(i507_ratio, 3, 'moving');
fxnCorrectOverVarPlot(mouse,yellowD,3,i507_ratio,i507_day,trainPeriod,threshold,yLimit,xLimit,type)

% i508
%%%%%%%%%%%%%%%%%%%%
mouse = '508';
i508_smoothed = smooth(i508_ratio, 3, 'moving');
fxnCorrectOverVarPlot(mouse,greenD,1,i508_ratio,i508_day,trainPeriod,threshold,yLimit,xLimit,type)

% i509
%%%%%%%%%%%%%%%%%%%%
mouse = '509';
i509_smoothed = smooth(i509_ratio, 3, 'moving');
fxnCorrectOverVarPlot(mouse,blueD,6,i509_ratio,i509_day,trainPeriod,threshold,yLimit,xLimit,type)

% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}First Gen Mice % of All Trials with React Time of 150-550 ms')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}% Trials between 150-550ms')
ylim([0 0.75]);
xlim(xLimit);
plot(trainingDay, i505_smoothed,'Color', redD, 'LineWidth', 3); % Plots i505 DIFFERENCE over training days
plot(trainingDay, i506_smoothed,'Color', orangeD,'LineWidth', 3); % Plots i506 DIFFERENCE over training days
plot(trainingDay, i507_smoothed,'Color', yellowD, 'LineWidth', 3);  % Plots i507 DIFFERENCE over training days
plot(trainingDay, i508_smoothed, 'Color', greenD, 'LineWidth', 3); % Plots i508 DIFFERENCE over training days
plot(trainingDay, i509_smoothed,'Color', blueD,'LineWidth', 3); % Plots i509 DIFFERENCE over training days
% Reference Lines
plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[0.27 0.27],'Color', greenM, 'LineStyle', ':', 'LineWidth', 2.0) % Plots Learning Threshold
plot(t,[0.45 0.45],'Color', cyan, 'LineStyle', ':', 'LineWidth', 2.0) % Plots Proficiency Threshold
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Northwest','i505','i506','i507','i508','i509'); %Legend
plot(i505_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i506_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i507_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i508_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i509_day,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
