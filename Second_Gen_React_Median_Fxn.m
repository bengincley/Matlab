% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% Second Gen Mice Behavior Learning Indicator - Analyzing and Outputting
% React Time Median 

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Second_Gen_Mice_Variables.mat

% Enables Datatype Compatibility
i527_medianReactTimeCorrect = double(cell2mat(i527_medianReactTimeCorrect));
i529_medianReactTimeCorrect = double(cell2mat(i529_medianReactTimeCorrect));
i533_medianReactTimeCorrect = double(cell2mat(i533_medianReactTimeCorrect));
i534_medianReactTimeCorrect = double(cell2mat(i534_medianReactTimeCorrect));
i535_medianReactTimeCorrect = double(cell2mat(i535_medianReactTimeCorrect));

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
type = 'HD';

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% i527
%%%%%%%%%%%%%%%%%%%%
mouse = '527';
i527_smooth = smooth(i527_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,redD,5,i527_medianReactTimeCorrect,i527_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i529
%%%%%%%%%%%%%%%%%%%%
mouse = '529';
i529_smooth = smooth(i529_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,orangeD,4,i529_medianReactTimeCorrect,i529_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i533
%%%%%%%%%%%%%%%%%%%%
mouse = '533';
i533_smooth = smooth(i533_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,yellowD,1,i533_medianReactTimeCorrect,i533_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i534
%%%%%%%%%%%%%%%%%%%%
mouse = '534';
i534_smooth = smooth(i534_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,greenD,3,i534_medianReactTimeCorrect,i534_day,trainPeriod,upper,lower,yLimit,xLimit,type);

% i535
%%%%%%%%%%%%%%%%%%%%
mouse = '535';
i535_trainingDay = 1:trainPeriod535;
i535_smooth = smooth(i535_medianReactTimeCorrect, 3, 'moving');
fxnReactMedianPlot(mouse,blueD,6,i535_medianReactTimeCorrect,i535_day,trainPeriod535,upper,lower,yLimit,xLimit,type);


% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}Second Gen Mice Median React Time')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}Median React Time')
ylim(yLimit);
xlim(xLimit);
plot(trainingDay, i527_smooth,'Color', redD,'LineWidth', 3); % Plots i527 median react time over training days
plot(trainingDay, i529_smooth,'Color', orangeD, 'LineWidth', 3);  % Plots i529 median react time over training days
plot(trainingDay, i533_smooth, 'Color', yellowD, 'LineWidth', 3); % Plots i533 median react time over training days
plot(trainingDay, i534_smooth,'Color', greenD,'LineWidth', 3); % Plots i534 median react time over training days
plot(i535_trainingDay, i535_smooth,'Color', blueD, 'LineWidth', 3); % Plots i535 median react time over training days
% Reference Lines
plot(t,upper,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', greenM, 'LineStyle', ':', 'LineWidth', 1.5)
for k=1:4                                                         % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('i527','i529','i533','i534','i535'); %Legend
plot(i527_day,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i529_day,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i533_day,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i534_day,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i535_day,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
