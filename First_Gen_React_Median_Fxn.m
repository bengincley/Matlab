% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% First Gen Mice Behavior Learning Indicator - Analyzing and Outputting
% React Time Median 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load First_Gen_Mice_Variables.mat

% Enables Datatype Compatibility
i505_medianReactTimeCorrect = double(cell2mat(i505_medianReactTimeCorrect));
i506_medianReactTimeCorrect = double(cell2mat(i506_medianReactTimeCorrect));
i507_medianReactTimeCorrect = double(cell2mat(i507_medianReactTimeCorrect));
i508_medianReactTimeCorrect = double(cell2mat(i508_medianReactTimeCorrect));
i509_medianReactTimeCorrect = double(cell2mat(i509_medianReactTimeCorrect));

% Establishes Plot Parameters
lower_threshold = 275;
upper_threshold = 425;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
yLimit = [0 1550]; 
xLimit = [1 20];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'HD';

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% i505
%%%%%%%%%%%%%%%%%%%%
mouse = '505';
i505_smooth = smooth(i505_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,redD,5,i505_medianReactTimeCorrect,i505_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i506
%%%%%%%%%%%%%%%%%%%%
mouse = '506';
i506_smooth = smooth(i506_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,orangeD,4,i506_medianReactTimeCorrect,i506_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i507
%%%%%%%%%%%%%%%%%%%%
mouse = '507';
i507_smooth = smooth(i507_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,yellowD,3,i507_medianReactTimeCorrect,i507_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i508
%%%%%%%%%%%%%%%%%%%%
mouse = '508';
i508_smooth = smooth(i508_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,greenD,1,i508_medianReactTimeCorrect,i508_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i509
%%%%%%%%%%%%%%%%%%%%
mouse = '509';
i509_smooth = smooth(i509_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,blueD,6,i509_medianReactTimeCorrect,i509_day,trainPeriod,upper,lower,yLimit,xLimit,type);


% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}First Gen Mice Median React Time')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Median React Time')
ylim(yLimit);
xlim(xLimit);
plot(trainingDay, i505_smooth,'Color', redD,'LineWidth', 3); % Plots i505 median react time over training days
plot(trainingDay, i506_smooth,'Color', orangeD, 'LineWidth', 3);  % Plots i506 median react time over training days
plot(trainingDay, i507_smooth, 'Color', yellowD, 'LineWidth', 3); % Plots i507 median react time over training days
plot(trainingDay, i508_smooth,'Color', greenD,'LineWidth', 3); % Plots i508 median react time over training days
plot(trainingDay, i509_smooth,'Color', blueD, 'LineWidth', 3); % Plots i509 median react time over training days
% Reference Lines
plot(t,upper,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5)
for k=1:4                                                         % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('i505','i506','i507','i508','i509'); %Legend
plot(i505_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i506_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i507_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i508_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i509_day,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
